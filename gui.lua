GUI = {}

function GUI:load()
    self.coins = {}
    self.coins.img = love.graphics.newImage("assets/coin-new.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 3
    self.coins.x = 50
    self.coins.y = 50
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
end

function GUI:draw()
    self:drawCoins()
    self:drawText()

    if self.musicButton.isMusicOn then
        love.graphics.draw(self.musicButton.img, self.musicButton.x, self.musicButton.y, 0, self.musicButton.scale, self.musicButton.scale)
    else
        love.graphics.draw(self.musicButton.imgOn, self.musicButton.x, self.musicButton.y, 0, self.musicButton.scale, self.musicButton.scale)
    end
end

function GUI:update(dt)

end

function GUI:drawCoins()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)

end

function GUI:drawText()
    love.graphics.setFont(self.font)

    local x = self.coins.x + self.coins.width * self.coins.scale + 10
    local y = self.coins.y + self.coins.height * self.coins.scale - self.font:getHeight()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print("x " .. Player.coins, x, y)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("x " .. Player.coins, x, y)
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