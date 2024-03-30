local Box = {
    img = love.graphics.newImage("assets/box.png")
}
Box.__index = Box
Box.width = Box.img:getWidth()
Box.height = Box.img:getHeight()
local ActiveBoxes = {}

function Box.new(x, y)
    local instance = setmetatable({}, Box) -- create a new instance of the Box class
    instance.x = x
    instance.y = y
    instance.rotation = 0

    instance.scaleX = 1
    instance.toBeRemoved = false

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(60)

    instance.randomTimeOffset = math.random(0, 100)

    table.insert(ActiveBoxes, instance)
end

function Box:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.rotation = self.physics.body:getAngle()
end

function Box:update(dt)
    self:syncPhysics()
   
end


function Box:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1 , self.width/2, self.height/2)
    -- love.graphics.draw(self.img, self.x, self.y, self.rotation, self.scaleX, 1 , self.width/2, self.height/2) -- shows rotation
end

function Box:drawAll()
    for i, instance in ipairs(ActiveBoxes) do
        instance:draw()
    end
end

function Box:updateAll(dt)
    for i, instance in ipairs(ActiveBoxes) do
        instance:update(dt)
    end
end

function Box.removeAll()
    for i,v in ipairs(ActiveBoxes) do
       v.physics.body:destroy()
    end
 
    ActiveBoxes = {}
 end
 

return Box