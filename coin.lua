local Player = require("player")
local Coin = {
    img = love.graphics.newImage("assets/coin-new.png"),
}
Coin.__index = Coin
Coin.width = Coin.img:getWidth()
Coin.height = Coin.img:getHeight()
local ActiveCoins = {}

function Coin.new(x, y)
    local instance = setmetatable({}, Coin) -- create a new instance of the Coin class
    instance.x = x
    instance.y = y
    instance.scaleX = 1
    instance.toBeRemoved = false


    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    instance.randomTimeOffset = math.random(0, 100)

    table.insert(ActiveCoins, instance)
end

function Coin:remove()
    for i, instance in ipairs(ActiveCoins) do
        if instance == self then
            Player:incrementCoins()
            SFX:playCoin()
            self.physics.body:destroy()
            table.remove(ActiveCoins, i)
        end
    end
end

function Coin:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

function Coin:update(dt)
    -- for i, instance in ipairs(ActiveCoins) do
    --     if CheckCollision(Player.x, Player.y, Player.width, Player.height, instance.x, instance.y, instance.width, instance.height) then
    --         table.remove(ActiveCoins, i)
    --     end
    -- end
    -- self:spin(dt)
    self:checkRemove()
end

function Coin:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset) -- oscillate between -1 and 1
end

function Coin:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1 , self.width/2, self.height/2)
end

function Coin:drawAll()
    for i, instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end

function Coin:updateAll(dt)
    for i, instance in ipairs(ActiveCoins) do
        instance:update(dt)
    end
end

function Coin.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveCoins) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if(a == Player.physics.fixture or b == Player.physics.fixture) then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

function Coin.endContact(a, b, collision)
end

return Coin