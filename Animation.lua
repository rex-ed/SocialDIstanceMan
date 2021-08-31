-- Animation code mainly copied from the mario assignment

Animation = Class{}

function Animation:init(params)

    self.texture = params.texture

    -- quads defining this animation
    self.frames = params.frames or {}

    -- time in seconds each frame takes (1/20 by default)
    self.interval = params.interval or 0.05

    self.endFrames = params.endFrames or {#self.frames}

    -- stores amount of time that has elapsed
    self.timer = 0

    self.currentFrame = 1
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end

function Animation:restart()
    self.timer = 0
    self.currentFrame = 1
end

function Animation:isOver(reverse)
    if not reverse then
        for _, frame in pairs(self.endFrames) do
            if self.currentFrame == frame then return true end
        end
    else
        if self.currentFrame == 1 then return true end
    end
end

function Animation:update(dt, reverse)
    self.timer = self.timer + dt

    -- iteratively subtract interval from timer to proceed in the animation,
    -- in case we skipped more than one frame
    while self.timer > self.interval do
        self.timer = self.timer - self.interval

        if not reverse then
            self.currentFrame = (self.currentFrame < #self.frames) and self.currentFrame + 1 or 1
        else
            self.currentFrame = (self.currentFrame > 1) and self.currentFrame - 1 or #self.frames
        end
    end
end
