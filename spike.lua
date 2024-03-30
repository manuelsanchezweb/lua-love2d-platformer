local Player = require("player")
local Spike = {
    img = love.graphics.newImage("assets/spikes.png")
}
Spike.__index = Spike
Spike.width = Spike.img:getWidth()
Spike.height = Spike.img:getHeight() 
local ActiveSpikes = {}

function Spike.new(x, y)
    local instance = setmetatable({}, Spike) -- create a new instance of the Spike class
    instance.x = x
    instance.y = y + instance.height

    instance.damage = 1

    instance.scaleX = 1
    instance.toBeRemoved = false

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    instance.randomTimeOffset = math.random(0, 100)

    table.insert(ActiveSpikes, instance)
end

function Spike:update(dt)
    -- for i, instance in ipairs(ActiveSpikes) do
    --     if CheckCollision(Player.x, Player.y, Player.width, Player.height, instance.x, instance.y, instance.width, instance.height) then
    --         table.remove(ActiveSpikes, i)
    --     end
    -- end
   
end


function Spike:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1 , self.width/2, self.height)
end

function Spike:drawAll()
    for i, instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end

function Spike:updateAll(dt)
    for i, instance in ipairs(ActiveSpikes) do
        instance:update(dt)
    end
end

function Spike.removeAll()
    for i,v in ipairs(ActiveSpikes) do
       v.physics.body:destroy()
    end
 
    ActiveSpikes = {}
 end

function Spike.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveSpikes) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if(a == Player.physics.fixture or b == Player.physics.fixture) then
                Player:takeDamage(instance.damage)
                return true
            end
        end
    end
end



return Spike