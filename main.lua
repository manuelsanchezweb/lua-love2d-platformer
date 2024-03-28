local STI = require("sti")
require("player")

function love.load()
    Map = STI("map/first.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact) -- set up collision callbacks
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    background = love.graphics.newImage("assets/background-forest.png")
    Player:load()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    Map:draw(0, 0, 2, 2)
    love.graphics.push() -- push the current transformation matrix to the stack
    love.graphics.scale(2, 2)
    Player:draw()
    love.graphics.pop() -- pop the transformation matrix from the stack
end

function love.keypressed(key)
    Player:jump(key)
end

function beginContact(a, b, collision) 
    -- a and b are the colliding fixtures, collision is the Contact object
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end 
