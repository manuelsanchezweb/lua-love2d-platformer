local Enemy = {}
Enemy.__index = Enemy
local Player = require("player")

local ActiveEnemies = {}

function Enemy.new(x, y)
    local instance = setmetatable({}, Enemy) -- create a new instance of the Enemy class
    instance.x = x
    instance.y = y
    instance.offsetY = -8
    instance.rotation = 0

    instance.flipCooldown = 0

    instance.speed = 100
    instance.speedMod = 1
    instance.xVel = instance.speed

    instance.damage = 1

    instance.rageCounter = 0
    instance.rageTrigger = 3

    instance.state = "walk"

    instance.animation = {
        timer = 0,
        rate = 0.2
    }
    instance.animation.run = {
        total = 6,
        current = 1,
        img = Enemy.runAnim
    }
    instance.animation.walk = {
        total = 6,
        current = 1,
        img = Enemy.walkAnim
    }
    instance.animation.draw = instance.animation.walk.img[1]

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width * 0.55, instance.height * 0.5)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(25)

    table.insert(ActiveEnemies, instance)
end

function Enemy.loadAssets()
    Enemy.runAnim = {}
    for i = 1, 6 do
        Enemy.runAnim[i] = love.graphics.newImage("assets/enemy/run/run" .. i .. ".png")
    end
    Enemy.walkAnim = {}
    for i = 1, 6 do
        Enemy.walkAnim[i] = love.graphics.newImage("assets/enemy/walk/walk" .. i .. ".png")
    end

    Enemy.width = Enemy.runAnim[1]:getWidth()
    Enemy.height = Enemy.runAnim[1]:getHeight()
end

function Enemy:incrementRage()
    self.rageCounter = self.rageCounter + 1
    if self.rageCounter > self.rageTrigger then
       self.state = "run"
       self.speedMod = 3
       self.rageCounter = 0
    else
       self.state = "walk"
       self.speedMod = 1
    end
 end
 
 function Enemy:flipDirection()
    if self.flipCooldown <= 0 then
        self.xVel = -self.xVel
        self.flipCooldown = 0.1 -- Set the cooldown to 2 seconds before the next flip is allowed
    end
 end

function Enemy:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel * self.speedMod, 100)
end

function Enemy:update(dt)
    self:syncPhysics()
    self:animate(dt)

     -- Decrement the flip cooldown timer
     if self.flipCooldown > 0 then
        self.flipCooldown = self.flipCooldown - dt
    end
end

function Enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt

    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNextFrame()
    end
end

function Enemy:setNextFrame()
    local anim = self.animation[self.state] -- this is a reference, it will mirror the changes made to self.animation
    if(anim.current < anim.total) then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end


function Enemy:draw()
    local scaleX = 1
    if(self.xVel < 0) then
       scaleX = -1
    end
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, 0, scaleX, 1 , self.width/2, self.height/2)
    -- love.graphics.draw(self.img, self.x, self.y, self.rotation, self.scaleX, 1 , self.width/2, self.height/2) -- shows rotation

    -- self:drawDebugOutline() -- debug mode
end

function Enemy:drawDebugOutline()
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.polygon("line", self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
    love.graphics.setColor(255, 255, 255, 255)
end

function Enemy:drawAll()
    for i, instance in ipairs(ActiveEnemies) do
        instance:draw()
    end
end

function Enemy:updateAll(dt)
    for i, instance in ipairs(ActiveEnemies) do
        instance:update(dt)
    end
end

function Enemy.removeAll()
    for i,v in ipairs(ActiveEnemies) do
       v.physics.body:destroy()
    end
 
    ActiveEnemies = {}
 end

function Enemy.beginContact(a, b, collision)

    for i, instance in ipairs(ActiveEnemies) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
            end
            -- Using a tolerance for comparing floating-point numbers
            instance:incrementRage()
            instance:flipDirection()
        end
    end
 end

return Enemy