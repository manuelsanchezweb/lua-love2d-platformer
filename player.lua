Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60
    self.xVel = 0
    self.yVel = 100
    self.maxSpeed = 200
    self.acceleration = 4000 -- it will take 0.05 seconds to reach max speed - 200 / 4000 = 0.05
    self.friction = 3500 -- it will take 0.057 seconds to stop from max speed - 200 / 3500 = 0.057
    self.gravity = 1500 -- 1500 pixels per second squared

    self.grounded = false
    self.hasDoubleJump = true
    self.jumpAmount = -500

    self.graceTime = 0
    self.graceDuration = 0.1

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true) -- prevent player from rotating
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape) -- attach shape to body

end

function Player:update(dt)
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
        if self.xVel - self.friction * dt < 0 then
            self.xVel = 0
        else
            self.xVel = self.xVel - self.friction * dt
        end
    elseif self.xVel < 0 then
        if self.xVel + self.friction * dt > 0 then
            self.xVel = 0
        else
            self.xVel = self.xVel + self.friction * dt
        end
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:move(dt)
    if love.keyboard.isDown("right", "d") then
        if self.xVel < self.maxSpeed then
            if(self.xVel + self.acceleration * dt > self.maxSpeed) then
                self.xVel = self.xVel + self.acceleration * dt
            else
                self.xVel = self.maxSpeed
            end
        end
    elseif love.keyboard.isDown("left", "a") then
        if self.xVel > -self.maxSpeed then
            if(self.xVel - self.acceleration * dt < -self.maxSpeed) then
                self.xVel = self.xVel - self.acceleration * dt
            else
                self.xVel = -self.maxSpeed
            end
        end
    else 
        self:applyFriction(dt)
    end
end

function Player:draw()
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function Player:beginContact(a, b, collision)
    if (self.grounded) then return end
    local nx, ny = collision:getNormal() -- returns coordinates of the collision normal

    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
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
        elseif self.hasDoubleJump then
            self.yVel = self.jumpAmount * 0.75
            self.hasDoubleJump = false
        end
    end
end

function Player:decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt
    end
end