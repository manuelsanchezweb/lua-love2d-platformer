love.graphics.setDefaultFilter("nearest", "nearest")

local GUI = require("gui") 
local Coin = require("coin")
local Spike = require("spike")
local Box = require("box")
local Enemy = require("enemy")
local Camera = require("camera")
local Map = require("map")
-- way of using locals above - better for performance, keeps the code clean and organized, and avoids global variables
-- for the moment, GUI is only used in main.lua, so it's not necessary to make it global
local Player = require("player")
require("sfx")
-- I am going to let the sfx global so that we can see an example of global

function love.load()
    Enemy.loadAssets()
    Map:load()
  
    background = love.graphics.newImage("assets/background-forest.png")
    Player:load()
    GUI:load()
    SFX:load()

    -- SFX:loadBackgroundMusic("assets/sfx/life-full-of-joy.wav")  -- Replace with your actual music file path
    -- SFX:playBackgroundMusic()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
    Spike:updateAll(dt)
    Enemy:updateAll(dt)
    Box:updateAll(dt)
    GUI:update(dt)
	Camera:setPosition(Player.x, 0)
    Map:update()
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

    -- debugSolidOutlines() 

    Camera:apply()
    Player:draw()
    Enemy:drawAll()
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
    Enemy.beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end 



function debugSolidOutlines()
    for _, object in ipairs(Map.layers.solid.objects) do
        love.graphics.setColor(1, 0, 0, 1) -- Set the color to red for the outline

        -- Adjust coordinates and size for camera position and scale
        local drawX = (object.x - Camera.x) * Camera.scale
        local drawY = (object.y - Camera.y) * Camera.scale
        local drawWidth = object.width * Camera.scale
        local drawHeight = object.height * Camera.scale

        if object.shape == "rectangle" then
            love.graphics.rectangle("line", drawX, drawY, drawWidth, drawHeight)
        elseif object.shape == "polygon" then
            local worldPoints = {}
            for i = 1, #object.polygon, 2 do
                local px = object.polygon[i]
                local py = object.polygon[i + 1]
                -- Adjust each point by the camera's position and scale
                table.insert(worldPoints, (px - Camera.x) * Camera.scale)
                table.insert(worldPoints, (py - Camera.y) * Camera.scale)
            end
            love.graphics.polygon("line", worldPoints)
        elseif object.shape == "ellipse" then
            -- Note: Adjusting ellipse drawing assuming you have a way to determine its radii
            local radiusX = (object.width / 2) * Camera.scale
            local radiusY = (object.height / 2) * Camera.scale
            love.graphics.ellipse("line", drawX + radiusX, drawY + radiusY, radiusX, radiusY)
        end

        love.graphics.setColor(1, 1, 1, 1) -- Reset the color to white
    end
end
