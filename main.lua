love.graphics.setDefaultFilter("nearest", "nearest")
local STI = require("sti")
local GUI = require("gui") 
local Coin = require("coin")
local Spike = require("spike")
local Camera = require("camera")
local Box = require("box")
-- way of using locals above - better for performance, keeps the code clean and organized, and avoids global variables
-- for the moment, GUI is only used in main.lua, so it's not necessary to make it global
local Player = require("player")
require("sfx")
-- I am going to let the sfx global so that we can see an example of global

function love.load()
    Map = STI("map/first.lua", {"box2d"})
    World = love.physics.newWorld(0, 2000) -- create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 2000
    World:setCallbacks(beginContact, endContact) -- set up collision callbacks
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    MapWidth = Map.layers.ground.width * 16
    background = love.graphics.newImage("assets/background-forest.png")
    Player:load()
    GUI:load()
    SFX:load()
    SFX:loadBackgroundMusic("assets/sfx/life-full-of-joy.wav")  -- Replace with your actual music file path
    SFX:playBackgroundMusic()
    Coin.new(200, 300)
    Coin.new(400, 200)
    Coin.new(500, 200)
    Coin.new(600, 200)
    Spike.new(240, 209)
    Spike.new(400, 320)
    Box.new(400, 250)
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
    Spike:updateAll(dt)
    Box:updateAll(dt)
    GUI:update(dt)
	Camera:setPosition(Player.x, 0)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    Map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

    Camera:apply()
    Player:draw()
    Coin:drawAll()
    Spike:drawAll()
    Box:drawAll()
    Camera:clear()
     
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
    if Spike.beginContact(a, b, collision) then
        return
    end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end 
