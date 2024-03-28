local STI = require("sti")
require("player")
require("coin")
require("gui")
require("sfx")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
    Map = STI("map/first.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact) -- set up collision callbacks
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    background = love.graphics.newImage("assets/background-forest.png")
    Player:load()
    GUI:load()
    SFX:load()
    SFX:loadBackgroundMusic("assets/sfx/life-full-of-joy.wav")  -- Replace with your actual music file path
    SFX:playBackgroundMusic()
    Coin.new(200, 300)
    Coin.new(400, 200)
    Coin.new(500, 200)
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
    GUI:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    Map:draw(0, 0, 2, 2)
    love.graphics.push() -- push the current transformation matrix to the stack
    love.graphics.scale(2, 2)
    Player:draw()
    Coin:drawAll()
     
    love.graphics.pop() -- pop the transformation matrix from the stack
    GUI:draw() -- draw the GUI on top of everything else / static / camera will not affect it
end

function love.keypressed(key)
    Player:jump(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then  -- If the left mouse button is pressed
        GUI:mousePressed(x, y)
    end
end

function beginContact(a, b, collision) 
    if Coin.beginContact(a, b, collision) then
        return
    end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end 
