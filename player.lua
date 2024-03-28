local Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.startX = self.x
    self.startY = self.y
    self.width = 24
    self.height = 27
    self.xVel = 0
    self.yVel = 100
    self.maxSpeed = 200
    self.acceleration = 4000 -- it will take 0.05 seconds to reach max speed - 200 / 4000 = 0.05
    self.friction = 3500 -- it will take 0.057 seconds to stop from max speed - 200 / 3500 = 0.057
    self.gravity = 1500 -- 1500 pixels per second squared
    self.direction = "right"
    self.state = "idle"
    self.coins = 0
    self.hearts = {
        current = 3;
        max = 3;
    }

    self.color ={
        red = 1,
        green = 1,
        blue = 1,
        speed = 3
    }

    self.grounded = false
    self.hasDoubleJump = true
    self.jumpAmount = -600

    self.graceTime = 0
    self.graceDuration = 0.1

    self.alive = true

    self:loadAssets()

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true) -- prevent player from rotating
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape) 
    self.physics.body:setGravityScale(0) -- prevent player from falling

end

function Player:incrementCoins()
    self.coins = self.coins + 1
end

function Player:update(dt)
    self:unTint(dt)
    self:respawn()
    self:setState()
    self:setDirection()
    self:animate(dt)
    self:decreaseGraceTime(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end 
end

function Player:applyFriction(dt)
    if self.xVel > 0 then
        self.xVel = math.max(self.xVel - self.friction * dt, 0)
    elseif self.xVel < 0 then
        self.xVel = math.min(self.xVel + self.friction * dt, 0)
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:move(dt)
    if love.keyboard.isDown("right", "d") then
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("left", "a") then
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
    else 
        self:applyFriction(dt)
    end
end

function Player:takeDamage(amount)

    self.hearts.current = self.hearts.current - amount
    self:tintRed()
    if self.hearts.current <= 0 then

        self.hearts.current = 0
        self:die()
    end
end

function Player:die()
    self.alive = false
end


function Player:respawn()
    if not self.alive then
        self.physics.body:setPosition(self.startX, self.startY)
        self.alive = true
        self.hearts.current = self.hearts.max
    end
end

function Player:beginContact(a, b, collision)
    if (self.grounded) then return end
    local nx, ny = collision:getNormal() -- returns coordinates of the collision normal

    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.yVel = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.yVel = 0
        end
    end
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if(self.currentGroundCollision == collision) then
            self.grounded = false
        end
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
    self.hasDoubleJump = true
    self.graceTime = self.graceDuration
end

function Player:jump(key)
    if key == "up" or key == "w" then
        if self.grounded or self.graceTime > 0 then
            self.yVel = self.jumpAmount
            self.grounded = false
            self.graceTime = 0
            SFX:playJump()  -- Play jump sound
        elseif self.hasDoubleJump then
            self.yVel = self.jumpAmount * 0.75
            self.hasDoubleJump = false
            SFX:playJump()  -- Play jump sound
        end
    end
end

function Player:decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt
    end
end

function Player:loadAssets()
    self.animation = {
        timer = 0,  -- time since the animation started 
        rate = 0.2 -- time between frames
    }

    self.animation.run = {
        total = 4, -- number of frames in the animation
        current = 1, -- current frame being displayed
        img = {}
    }

    for i=1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/run/walk"..i..".png")
    end

    self.animation.air = {
        total = 4, -- number of frames in the animation
        current = 1, -- current frame being displayed
        img = {}
    }

    for i=1, self.animation.air.total do
        self.animation.air.img[i] = love.graphics.newImage("assets/player/idle/idle"..i..".png")
    end

    self.animation.idle = {
        total = 4, -- number of frames in the animation
        current = 1, -- current frame being displayed
        img = {}
    }

    for i=1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/idle"..i..".png")
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()

end

function Player:draw()
    local scaleX = 1.5 -- Default scale for x is now 2
    local scaleY = 1.5 -- Default scale for y is now 2
    
    if self.direction == "left" then
        scaleX = -1.5 -- Flipping and scaling the character in the x direction
    end
    
    -- Adjust the origin of scaling and rotation to be the center of the sprite
    local originX = self.animation.width / 2
    local originY = self.animation.height / 2
    
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, scaleY, originX, originY )
    love.graphics.setColor(1, 1, 1, 1)
end

function Player:tintRed()
    self.color.red = 1
    self.color.green = 0
    self.color.blue = 0
end

function Player:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNextFrame()
    end
end

function Player:setNextFrame()
    local anim = self.animation[self.state] -- this is a reference, it will mirror the changes made to self.animation
    if(anim.current < anim.total) then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Player:setDirection()
    if self.xVel > 0 then
        self.direction = "right"
    elseif self.xVel < 0 then
        self.direction = "left"
    end
end

function Player:setState()
    if self.grounded then
        if self.xVel == 0 then
            self.state = "idle"
        else
            self.state = "run"
        end
    else
        self.state = "air"
    end
end

return Player