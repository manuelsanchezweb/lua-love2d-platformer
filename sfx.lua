SFX = {}
SFX.sounds = {}
SFX.backgroundMusic = nil

function SFX:load()
    self.sounds["jump"] = love.audio.newSource("assets/sfx/player_jump.ogg", "static")
    self.sounds["coin"] = love.audio.newSource("assets/sfx/player_get_coin.ogg", "static")
end

function SFX:playJump()
    self.sounds["jump"]:play()
end

function SFX:playCoin()
    self.sounds["coin"]:play()
end

function SFX:loadBackgroundMusic(path)
    self.backgroundMusic = love.audio.newSource(path, "stream")
    self.backgroundMusic:setLooping(true)  -- Enable looping
    self.backgroundMusic:setVolume(0.5)  -- Adjust volume as needed
end

function SFX:playBackgroundMusic()
    if self.backgroundMusic then
        self.backgroundMusic:play()
    end
end

function SFX:stopBackgroundMusic()
    if self.backgroundMusic then
        self.backgroundMusic:stop()
    end
end

function SFX:pauseBackgroundMusic()
    if self.backgroundMusic then
        self.backgroundMusic:pause()
    end
end

function SFX:resumeBackgroundMusic()
    if self.backgroundMusic and not self.backgroundMusic:isPlaying() then
        self.backgroundMusic:play()
    end
end