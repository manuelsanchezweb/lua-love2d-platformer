local GUI = {}
local Player = require("player")

function GUI:load()
    self.coins = {}
    self.coins.img = love.graphics.newImage("assets/coin-new.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 3
    self.coins.x = 50
    self.coins.y = 100

    self.font = love.graphics.newFont("assets/bit.ttf", 36)

     -- Existing initialization
    self.musicButton = {
        img = love.graphics.newImage("assets/sound-off.png"),  -- Assuming you have a 'sound-off' sprite
        imgOn = love.graphics.newImage("assets/sound-on.png"),  -- Assuming you have a 'sound-on' sprite
        x = love.graphics.getWidth() - 100,  -- Positioning the button on the top-right
        y = 50,
        scale = 3,
        width = nil,
        height = nil,
        isMusicOn = true  -- Music is initially on
    }
    self.musicButton.width = self.musicButton.img:getWidth() * self.musicButton.scale
    self.musicButton.height = self.musicButton.img:getHeight() * self.musicButton.scale

    self.hearts = {}
    self.hearts.img = love.graphics.newImage("assets/heart.png")
    self.hearts.width = self.hearts.img:getWidth()
    self.hearts.height = self.hearts.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 50
    self.hearts.scale = 3
    self.hearts.spacing = self.hearts.width * self.hearts.scale + 10
end

function GUI:draw()
    self:drawCoins()
    self:drawCoinsText()
    self:drawHearts()

    if self.musicButton.isMusicOn then
        love.graphics.draw(self.musicButton.img, self.musicButton.x, self.musicButton.y, 0, self.musicButton.scale, self.musicButton.scale)
    else
        love.graphics.draw(self.musicButton.imgOn, self.musicButton.x, self.musicButton.y, 0, self.musicButton.scale, self.musicButton.scale)
    end
end

function GUI:update(dt)

end

function GUI:drawCoins()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
end

function GUI:drawCoinsText()
    love.graphics.setFont(self.font)
    local x = self.coins.x + self.coins.width * self.coins.scale
    local y = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.print(" : "..Player.coins, x + 1, y + 1)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(" : "..Player.coins, x, y)
end

function GUI:drawHearts()
    for i = 1, Player.hearts.current do
        local x = self.hearts.x + i * self.hearts.spacing
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.draw(self.hearts.img, x + 1, self.hearts.y + 1, 0, self.hearts.scale, self.hearts.scale)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
    end
end

function GUI:mousePressed(x, y)
    if x > self.musicButton.x and x < self.musicButton.x + self.musicButton.width and y > self.musicButton.y and y < self.musicButton.y + self.musicButton.height then
        self.musicButton.isMusicOn = not self.musicButton.isMusicOn
        if self.musicButton.isMusicOn then
            SFX:resumeBackgroundMusic()
        else
            SFX:stopBackgroundMusic()
        end
    end
end

return GUI