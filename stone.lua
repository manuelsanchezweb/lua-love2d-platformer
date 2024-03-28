local Stone = {
    img = love.graphics.newImage("assets/stone.png")
}
Stone.__index = Stone
Stone.width = Stone.img:getWidth()
Stone.height = Stone.img:getHeight()
local ActiveStones = {}

function Stone.new(x, y)
    local instance = setmetatable({}, Stone) -- create a new instance of the Stone class
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

    table.insert(ActiveStones, instance)
end

function Stone:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.rotation = self.physics.body:getAngle()
end

function Stone:update(dt)
    self:syncPhysics()
   
end


function Stone:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1 , self.width/2, self.height/2)
    -- love.graphics.draw(self.img, self.x, self.y, self.rotation, self.scaleX, 1 , self.width/2, self.height/2) -- shows rotation
end

function Stone:drawAll()
    for i, instance in ipairs(ActiveStones) do
        instance:draw()
    end
end

function Stone:updateAll(dt)
    for i, instance in ipairs(ActiveStones) do
        instance:update(dt)
    end
end

return Stone