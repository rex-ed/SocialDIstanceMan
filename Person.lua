Person = Class{}

function Person:init(grid, id, startSide)
    math.randomseed(os.time())

    self.grid = grid
    self.id = id
    self.type = 'person'

    self.width = self.grid.tileSize
    self.height = self.grid.tileSize

    -- get start position
    local side = startSide or math.random(4)
    if side == 1 then
        -- start at a random position on the top
        self.tile = self.grid.tiles[math.random(5, self.grid.width - 5)]

        self.x = self.tile.tileX + self.grid.tileSize / 2
        self.y = (self.tile.tileY + self.grid.tileSize / 2) - self.grid.tileSize

        self.direction = DIRECTIONS['down']
    elseif side == 2 then
       -- start at a random position on the right
       self.tile = self.grid.tiles[self.grid.width * math.random(5, self.grid.height - 5)]

       self.x = (self.tile.tileX + self.grid.tileSize / 2) + self.grid.tileSize
       self.y = self.tile.tileY + self.height * 3 / 4

       self.direction = DIRECTIONS['left']
    elseif side == 3 then
         -- start at a random position on the bottom
         self.tile = self.grid.tiles[math.random(self.grid.width * (self.grid.height - 1) + 3,
         self.grid.width * self.grid.height) - 1]

     self.x = self.tile.tileX + self.grid.tileSize / 2
     self.y = (self.tile.tileY + self.grid.tileSize / 2) + self.grid.tileSize

     self.direction = DIRECTIONS['up']
    else
        -- start at a random position on the left
        self.tile = self.grid.tiles[self.grid.width * math.random(2, self.grid.height - 4) + 1]

        self.x = (self.tile.tileX + self.grid.tileSize / 2) - self.grid.tileSize
        self.y = self.tile.tileY + self.height * 3 / 4

        self.direction = DIRECTIONS['right']
    end

    self.timer = 0

    self.Qtimer = 0
    self.escapeTimer = 0
    self.Qstate = 'entering'
    self.r = 0
    local bed

    self.nextTile = self.tile

    self.tilePrevInfected = 'clean'

    self.carrier = false

    local sickChance
    if (self.grid.personCount > 3 and self.grid.sickPeople == 0) or
    (self.grid.personCount > 20 and self.grid.sickPeople / self.grid.personCount < 1/2) then
        sickChance = 0
    elseif self.grid.sickPeople / self.grid.personCount > 5/6 then
        sickChance = 10
    else
        sickChance = 6
    end

    if math.random(10) > sickChance then
        self.carrier = true
    end

    self.sick = false
    --self.immune = (math.random(6) < 2) and true or false

    self.items = {}

    self.selected = false

    self.speed = 3000 / self.grid.tileSize

    self.shadow = love.graphics.newImage('objects/shadow.png')
    self.texture = love.graphics.newImage('people/person' .. math.random(5) .. ' atlas.png')

    self.animations = {
        ['idle'] = {
            Animation({
                texture = self.texture,

                frames = {
                    love.graphics.newQuad(0, 20, 20, 20, self.texture:getDimensions())
                },

                endFrames = {1}
            }),
            Animation({
                texture = self.texture,

                frames = {
                    love.graphics.newQuad(0, 40, 20, 20, self.texture:getDimensions())
                },

                endFrames = {1}
            }),
            Animation({
                texture = self.texture,

                frames = {
                    love.graphics.newQuad(0, 0, 20, 20, self.texture:getDimensions())
                },

                endFrames = {1}
            }),
            Animation({
                texture = self.texture,

                frames = {
                    love.graphics.newQuad(0, 60, 20, 20, self.texture:getDimensions())
                },

                endFrames = {1}
            }),
        },
        ['moving'] = {
            Animation({
                texture = self.texture,

                frames = {
                    love.graphics.newQuad(20, 20, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(0, 20, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(40, 20, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(0, 20, 20, 20, self.texture:getDimensions())
                },

                interval = 0.22,

                endFrames = {2, 4}
            }),
            Animation({
                texture = self.texture,

                frames = {
                    love.graphics.newQuad(20, 40, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(0, 40, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(40, 40, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(0, 40, 20, 20, self.texture:getDimensions())
                },

                interval = 0.22,

                endFrames = {2, 4}
            }),
            Animation({
                texture = self.texture,

                frames = {
                    love.graphics.newQuad(20, 0, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(0, 0, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(40, 0, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(0, 0, 20, 20, self.texture:getDimensions())
                },

                interval = 0.22,

                endFrames = {2, 4}
            }),
            Animation({
                texture = self.texture,

                frames = {
                    love.graphics.newQuad(20, 60, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(0, 60, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(40, 60, 20, 20, self.texture:getDimensions()),
                    love.graphics.newQuad(0, 60, 20, 20, self.texture:getDimensions())
                },

                interval = 0.22,

                endFrames = {2, 4}
            }),
        }
    }
    self.animation = self.animations['idle'][3]

    self.behaviors = {
        ['idle'] = function(dt)
            if self.animation:isOver() then
                self.animation = self.animations['idle'][self.direction]
            end

            self.x = self.tile.tileX + self.grid.tileSize / 2
            self.y = self.tile.tileY + self.height * 3 / 4

            self.timer = self.timer + dt

            if self.timer >= math.random(10) and not self.selected then
                if self:pickNext() then
                    self.state = 'moving'
                end
            end
        end,
        ['moving'] = function(dt)
            self.animation = self.animations['moving'][self.direction]

            if not self.nextTile then self:pickNext() return end

            if self.nextTile.blocked and self.nextTile.blocked ~= self.id then
                self.nextTile = self.tile
                self.state = 'idle'
            end

            if self.direction == 1 then
                -- if not to destination, move
                if self.y > self.nextTile.tileY + self.height * 3 / 4 then
                    self.y = self.y - self.speed * dt

                    -- if halfway, change tile
                    if self.y < self.tile.tileY + self.height * 3 / 8 then
                        self.tile = self.nextTile
                    end
                else
                    self.state = 'idle'
                    self.timer = 0
                end
            elseif self.direction == 2 then
                if self.x < self.nextTile.tileX + self.grid.tileSize / 2 then
                    self.x = self.x + self.speed * dt

                    -- if halfway, change tile
                    if self.x > self.nextTile.tileX then
                        self.tile = self.nextTile
                    end
                else
                    self.state = 'idle'
                    self.timer = 0
                end
            elseif self.direction == 3 then
                if self.y < self.nextTile.tileY + self.height * 3 / 4 then
                    self.y = self.y + self.speed * dt

                    -- if halfway, change tile
                    if self.y > self.nextTile.tileY + self.height * 3 / 8 then
                        self.tile = self.nextTile
                    end
                else
                    self.state = 'idle'
                    self.timer = 0
                end
            else
                if self.x > self.nextTile.tileX + self.grid.tileSize / 2 then
                    self.x = self.x - self.speed * dt

                    -- if halfway, change tile
                    if self.x < self.tile.tileX then
                        self.tile = self.nextTile
                    end
                else
                    self.state = 'idle'
                    self.timer = 0
                end
            end
        end,
        ['pushing'] = function(dt)
            local TX = self.tile.tileX + self.grid.tileSize / 2
            local TY = self.tile.tileY + self.height * 3 / 4

            self.x = self.x - (self.x - TX) / 5
            self.y = self.y - (self.y - TY) / 5

            if self.x < TX + self.speed * dt and self.x > TX - self.speed * dt and
                self.y < TY + self.speed * dt and self.y > TY - self.speed * dt then

                self.state = 'idle'
            end
        end,
        ['quarantine'] = function(dt)
            self.Qtimer = self.Qtimer + dt
            self.escapeTimer = 0
            
            if self.Qstate == 'entering' then
                bed = nil
                if math.abs(self.x - self.grid.gridX) > 10 or
                    math.abs(self.y - (self.grid.gridY + self.grid.heightPix - 90)) > 10 then
                        self.x = self.x - (self.x - self.grid.gridX) / 10
                        self.y = self.y - (self.y - (self.grid.gridY + self.grid.heightPix - 90)) / 10
                else
                    for _, b in pairs(self.grid.quarantine.beds[self.grid.quarantine.level]) do
                        if b.open then
                            self.x = b.x
                            self.y = b.y
                            if b.side == true then
                                self.animation = self.animations['idle'][2]
                                self.r = (2 * math.pi) * 3 / 4
                            else
                                self.animation = self.animations['idle'][3]
                                self.r = 0
                            end
                            bed = b
                            bed.open = false
                            break
                        end
                    end
                    self.Qstate = 'in'
                end
            end


            if self.Qstate == 'in' and self.Qtimer > 10 and self.Qtimer % 5 < 1 / 60 then
                if math.random(40) == 1 then
                    self.Qstate = 'exiting'
                end
            end

            if self.Qstate == 'exiting' then
                self.y = self.grid.gridY + self.grid.heightPix - 15
                self.r = 0
                bed.open = true
                self.direction = 2
                self.animation = self.animations['moving'][self.direction]

                if self.x < self.grid.gridX + 87 then
                    self.x = self.x + self.speed * dt
                else
                    self.tile = self.grid.tiles[self.grid.width * (self.grid.height - 1) + 2]
                    self.nextTile = self.tile
                    self.state = 'idle'
                    self.Qstate = 'entering'
                    self.escapeTimer = dt

                    for index, person in pairs(self.grid.quarantine.people) do
                        if person == self then
                            table.remove(self.grid.quarantine.people, index)
                        end
                    end
                end
            end

            if self.Qstate == 'in' and self.Qtimer > 120 then
                if self.x > 0 then
                    bed.open = true
                    self.direction = 4
                    self.r = 0
                    self.animation = self.animations['moving'][self.direction]

                    self.y = self.grid.quarantine.ry + 240
                    self.x = self.x - self.speed * dt
                else
                    for index, person in pairs(self.grid.quarantine.people) do
                        if person == self then
                            table.remove(self.grid.quarantine.people, index)
                        end
                    end

                    for index, person in pairs(self.grid.things) do
                        if person == self then
                            table.remove(self.grid.things, index)
                        end
                    end
                end
            end
        end
    }

    self.state = 'moving'
end

function Person:update(dt)
    self.behaviors[self.state](dt)

    if self.state ~= 'quarantine' then
        self.tile.person = self

        self:range()

        if not self.carrier and self.tile.infected ~= self.tilePrevInfected then
            self:recieve()
            self.tilePrevInfected = self.tile.infected
        end
    end

    if self.escapeTimer > 0 then
        self.escapeTimer = self.escapeTimer + dt
    end

    self.animation:update(dt)

    if self.Qstate ~= 'in' then
        for _, item in pairs(self.items) do
            item:update(dt)
        end
    end
end

function Person:pickNext()
    math.randomseed(os.time() * self.timer)
    local absDir = self.direction

    if not self.nextTile or self.nextTile == self.tile then
        -- 50% chance for no turn
        if math.random(3) == 1 then
            -- 75% of turns will turn 90 degrees
            if math.random(5) ~= 5 then
                -- turn either to the left
                if math.random(2) == 1 then
                    absDir = absDir + 1
                else
                    -- or the right
                    absDir = absDir - 1
                end
            else
            -- 25% of turns will turn 180 degrees
                absDir = absDir + 2
            end
        end

        if absDir > 4 then
            self.direction = absDir - 4
        elseif absDir < 1 then
            self.direction = 4 + absDir
        else
            self.direction = absDir
        end
    end
    
    self.nextTile = self.grid:adjacentTile(self.direction, self.tile.position)

    if self.nextTile and self.nextTile.blocked and self.nextTile.blocked ~= self.id then
        self.nextTile = false
    end

    return self.nextTile
end

function Person:isWearing(item)
    for _, thing in pairs(self.items) do
        if thing.typeName == item then
            return true
        end
    end

    return false
end

function Person:range()
    local range = {}
    local dir

    if not self:isWearing('gloves') and not self:isWearing('sanitizer') then
        range[self.tile] = 'strong'
    end

    if self:isWearing('mask') then
        if self.grid:adjacentTile(self.direction, self.tile.position) then
            range[self.grid:adjacentTile(self.direction, self.tile.position)] = 'weak'
        end
    elseif self:isWearing('sheild') then
        for i = self.direction - 1, self.direction + 1, 2 do
            if i < 1 then
                dir = i + 4
            elseif i > 4 then
                dir = i - 4
            else
                dir = i
            end

            if self.grid:adjacentTile(dir, self.tile.position) then
                range[self.grid:adjacentTile(dir, self.tile.position)] = 'mid'
            end
        end
    else
        -- normal range
        for i = self.direction - 1, self.direction + 1 do
            if i < 1 then
                dir = i + 4
            elseif i > 4 then
                dir = i - 4
            else
                dir = i
            end
            -- add adjacent tiles in front and to the sides
            if self.grid:adjacentTile(dir, self.tile.position) then
                range[self.grid:adjacentTile(dir, self.tile.position)] = 'mid'

                if self.grid:adjacentTile(self.direction, self.grid:adjacentTile(dir, self.tile.position).position) then
                    range[self.grid:adjacentTile(self.direction, self.grid:adjacentTile(dir, self.tile.position).position)] = 'weak'
                end
            end
        end
    end

    if self:isWearing('rod') then
        if self.grid:adjacentTile(self.direction, self.tile.position) then
            if self.grid:adjacentTile(self.direction, self.tile.position).blocked ~= 'const' then
                self.grid:adjacentTile(self.direction, self.tile.position).blocked = self.id
            end

            if self.grid:adjacentTile(self.direction, self.grid:adjacentTile(self.direction, self.tile.position).position)
            and self.grid:adjacentTile(self.direction, self.grid:adjacentTile(self.direction, self.tile.position).position).blocked ~= 'const' then
                self.grid:adjacentTile(self.direction, self.grid:adjacentTile(self.direction, self.tile.position).position).blocked = self.id
            end
        end
    end

    if self:isWearing('tube') then
        for _, dir in pairs(DIRECTIONS) do
            if self.grid:adjacentTile(dir, self.tile.position) and
                self.grid:adjacentTile(dir, self.tile.position).blocked ~= 'const' then
                self.grid:adjacentTile(dir, self.tile.position).blocked = self.id

                if not range[self.grid:adjacentTile(dir, self.tile.position)] then
                    range[self.grid:adjacentTile(dir, self.tile.position)] = 'blocked'
                end
            end
        end

        self.tile.blocked = self.id
    end

    for tile, strength in pairs(range) do
        if self.selected then
            if self.sick then
                tile.highlighted = 'red'
            else
                tile.highlighted = 'white'
            end

            if tile.blocked == self.id then
                tile.highlighted = 'blocked'
            end
        end

        if self.carrier then
            tile.infected = (strength ~= 'blocked' and strength or 'clean')
        end
    end
end

function Person:recieve()
    if not self.tile.blocked or (self.tile.blocked and self.tile.blocked == self.id) then
        if self.tile.infected == 'strong' then
            if math.random(10) < 9 then
                self.carrier = true
            end
        elseif self.tile.infected == 'mid' then
            if math.random(10) < 7 then
                self.carrier = true
            end
        elseif self.tile.infected == 'weak' then
            if math.random(10) < 4 then
                self.carrier = true
            end
        end

        if self.carrier and not self.immune then
            self.sick = true
        end
    end
end

function Person:push(pushDir)
    if self.state ~= 'quarantine' then
        if self.tile.blocked and self.tile.blocked ~= self.id then
            local dir
            for i = 0, 3 do
                dir = pushDir + i

                if dir < 1 then
                    dir = dir + 4
                elseif i > 4 then
                    dir = dir - 4
                end

                if self.grid:adjacentTile(dir, self.tile.position) and
                    not (self.grid:adjacentTile(dir, self.tile.position).blocked and
                    self.grid:adjacentTile(dir, self.tile.position).blocked ~= self.id) then

                    self.direction = dir
                    self.tile = self.grid:adjacentTile(dir, self.tile.position)
                    self.state = 'pushing'

                    return
                end
            end
        else
            if self.direction ~= pushDir then
                self.direction = self.direction + ((self.direction > 2) and -2 or 2)
            end

            if self.grid:adjacentTile(self.direction, self.tile.position) and
                not (self.grid:adjacentTile(self.direction, self.tile.position).blocked ~= self.id and
                self.grid:adjacentTile(self.direction, self.tile.position).blocked) then

                self.nextTile = self.grid:adjacentTile(self.direction, self.tile.position)
                self.state = 'moving'
            end
        end
    end
end

function Person:render()
    if self.Qstate ~= 'in' then
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(self.shadow, math.floor(self.x - 33), math.floor(self.y - 18),
            0, self.grid.tileSize / 20, self.grid.tileSize / 20)

        if self.sick then
            love.graphics.setColor(1, 2/5 * math.sin(2.5 * Timer) + 4/5, 2/5 * math.sin(2.5 * Timer) + 4/5, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end

        love.graphics.draw(self.texture, self.animation:getCurrentFrame(),
            math.floor(self.x - self.width / 2), math.floor(self.y - self.height),
                self.r, self.grid.tileSize / 20, self.grid.tileSize / 20)

        for _, item in pairs(self.items) do
            item:render(self.animation.currentFrame)
        end
    end
end