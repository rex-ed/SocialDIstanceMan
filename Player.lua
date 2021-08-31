Player = Class{}

function Player:init(grid)
    self.grid = grid

    self.width = 20
    self.height = 20

    self.x = self.grid.gridX + self.grid.widthPix / 2 - self.width / 2
    self.y = self.grid.gridY + self.grid.widthPix / 2 - self.width / 2

    self.direction = DIRECTIONS['down']

    self.type = 'player'

    self.selectedPerson = nil

    self.speed = 390

    self.atlas = love.graphics.newImage('SDM atlas.png')

    self.animations = {
        ['right'] = Animation({
            texture = self.atlas,

            frames = {
                love.graphics.newQuad(20, 0, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(37, 0, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(57, 0, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(37, 0, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(20, 0, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(79, 0, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(101, 0, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(79, 0, 20, 20, self.atlas:getDimensions())
            },

            interval = .115,

            endFrames = {1, 5}
        }),
        ['left'] = Animation({
            texture = self.atlas,

            frames = {
                love.graphics.newQuad(18, 20, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(38, 20, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(58, 20, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(38, 20, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(18, 20, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(80, 20, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(100, 20, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(80, 20, 20, 20, self.atlas:getDimensions())
            },

            interval = .115,

            endFrames = {1, 2, 4, 5, 6, 8}
        }),
        ['front'] = Animation({
            texture = self.atlas,

            frames = {
                love.graphics.newQuad(19, 40, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(39, 40, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(19, 40, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(59, 40, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(81, 40, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(59, 40, 20, 20, self.atlas:getDimensions())
            },

            interval = .125,

            endFrames = {1, 3, 4, 6}
        }),
        ['back'] = Animation({
            texture = self.atlas,

            frames = {
                love.graphics.newQuad(19, 60, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(39, 60, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(19, 60, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(59, 60, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(81, 60, 20, 20, self.atlas:getDimensions()),
                love.graphics.newQuad(59, 60, 20, 20, self.atlas:getDimensions())
            },

            interval = .125,

            endFrames = {1, 3, 4, 6}
        }),
        ['idle'] = {
            Animation({
                texture = self.atlas,

                frames = {
                    love.graphics.newQuad(0, 60, 20, 20, self.atlas:getDimensions())
                }

            }),
            Animation({
                texture = self.atlas,

                frames = {
                    love.graphics.newQuad(0, 0, 20, 20, self.atlas:getDimensions())
                }
            }),
            Animation({
                texture = self.atlas,

                frames = {
                    love.graphics.newQuad(0, 40, 20, 20, self.atlas:getDimensions())
                }

            }),
            Animation({
                texture = self.atlas,

                frames = {
                    love.graphics.newQuad(1, 20, 20, 20, self.atlas:getDimensions())
                }
            })
        }
    }

    self.state = 'idle'
    self.animation = self.animations['idle'][self.direction]

    self.shadow = love.graphics.newImage('objects/shadow.png')

    self.behaviors = {
        ['idle'] = function(dt)
            if self.animation:isOver() then
                self.animation = self.animations['idle'][self.direction]
            end

            if love.keyboard.isDown(controls.up) or love.keyboard.isDown(controls.left) or
                love.keyboard.isDown(controls.down) or love.keyboard.isDown(controls.right) then

                self.state = 'moving'
                self.animations['right']:restart()
                self.animations['left']:restart()
            end
        end,
        ['moving'] = function(dt)
            local speed

            if (love.keyboard.isDown(controls.up) or love.keyboard.isDown(controls.down)) and
                (love.keyboard.isDown(controls.left) or love.keyboard.isDown(controls.right)) then
                    speed = math.sqrt(self.speed^2 / 2) * dt
                else
                    speed = self.speed * dt
                end

            if love.keyboard.isDown(controls.up) then
                self.animation = self.animations['back']
                -- move up (bound by top)
                if self.y - speed >= self.grid.gridY then
                    if self:tileIn(self.x, self.y - speed).blocked ~= 'const' then
                        self.y = self.y - speed
                    end
                else
                    self.y = self.grid.gridY
                end
                self.direction = DIRECTIONS['up']
            elseif love.keyboard.isDown(controls.down) then
                self.animation = self.animations['front']
                -- move down (bound by bottom)
                if self.y + speed <= self.grid.heightPix + self.grid.gridY - 9 then
                    if self:tileIn(self.x, self.y + speed).blocked ~= 'const' then
                        self.y = self.y + speed
                    end
                else
                    self.y = self.grid.heightPix + self.grid.gridY - 9
                end
                self.direction = DIRECTIONS['down']
            end

            if love.keyboard.isDown(controls.left) then
                self.animation = self.animations['left']
                -- move left (bound by left edge)
                if self.x - speed >= self.grid.gridX + self.width then
                    if self:tileIn(self.x - speed - self.width, self.y).blocked ~= 'const' then
                        self.x = self.x - speed
                    end
                else
                    self.x = self.grid.gridX + self.width
                end
                self.direction = DIRECTIONS['left']
            elseif love.keyboard.isDown(controls.right) then
                self.animation = self.animations['right']
                -- move right (bount by right edge)
                if self.x + speed <= self.grid.widthPix + self. grid.gridX - self.width then
                    if self:tileIn(self.x + speed + self.width, self.y).blocked ~= 'const' then
                        self.x = self.x + speed
                    end
                else
                    self.x = self.grid.widthPix + self.grid.gridX - self.width
                end
                self.direction = DIRECTIONS['right']
            elseif not (love.keyboard.isDown(controls.up) or love.keyboard.isDown(controls.down)) then
                -- if not moving, set state to idle
                self.state = 'idle'
            end
        end,
        ['selecting'] = function(dt)
            self.animation = self.animations['idle'][self.direction]

            if not love.keyboard.isDown(controls.select) and
                (love.keyboard.isDown(controls.up) or love.keyboard.isDown(controls.left) or
                    love.keyboard.isDown(controls.down) or love.keyboard.isDown(controls.right)) and self.selectedPerson then

                self.selectedPerson.selected = false
                self.selectedPerson = nil

                self.state = 'moving'
            end

            if self.grid.menu then
                self.grid.menu:update(dt)
            end

        end
    }
end

function Player:update(dt)
    self.behaviors[self.state](dt)

    self.animation:update(dt)

    if self.grid:adjacentTile(self.direction, self:tileIn().position) and
        self.grid:adjacentTile(self.direction, self:tileIn().position).building then

            if not self.grid.ui.buildingFlag then
                self.grid.ui:BuildingFlag(self.grid:adjacentTile(self.direction, self:tileIn().position).building)
            end
    elseif self.grid.ui.buildingFlag then
        self.grid.ui.buildingFlag = nil
    end
end

function Player:select()
    if self.state ~= 'selecting' then
        local adjTile = self.grid:adjacentTile(self.direction, self:tileIn().position)
        if self:tileIn().person then
            self.state = 'selecting'
            self.selectedPerson = self:tileIn().person
            self.selectedPerson.selected = true
        elseif adjTile ~= false then
            self.selectedPerson = adjTile.person

            if self.selectedPerson then
                self.selectedPerson.selected = true
                self.state = 'selecting'
            end

            if adjTile.building and not (tutorial and tutorial.freezeMenu) then
                self.grid.menu = Menu(self.grid, adjTile.building.type)
                self.state = 'selecting'
            end
        elseif not (tutorial and tutorial.freezeMenu) then
            self.grid.menu = Menu(self.grid, 'welcome sign')
            self.state = 'selecting'
        end
    end
end

function Player:action(key)
    -- turn the selected person around
    if key == controls.select then
        self.selectedPerson.direction = (self.selectedPerson.direction > 2)
            and self.selectedPerson.direction - 2 or self.selectedPerson.direction + 2

        self.selectedPerson.nextTile = self.grid:adjacentTile(self.selectedPerson.direction, self.selectedPerson.tile.position)
        if not self.selectedPerson.nextTile then
            self.selectedPerson.nextTile = self.selectedPerson.tile
        end
    end

    for id, itemKey in pairs(controls.items) do
        if key == itemKey then
            local item = items[id]
            if item.amount ~= 0 and not self.selectedPerson:isWearing(item.type) and
            not (item.type ~= 'test' and self.selectedPerson:isWearing(items[id + (id % 2 == 0 and 1 or -1)].type)) 
                and not (item.type == 'test' and self.selectedPerson.sick) then

                item.amount = item.amount - 1
                self.grid.ui:purchase(item, -1)
                self.grid.ui:itemUsed(item, self.x, self.y, self.selectedPerson)
            end
        end
    end

    if key == controls.quarantine then
        if #self.grid.quarantine.people < self.grid.quarantine.level + 2 then
            self.selectedPerson.state = 'quarantine'

            table.insert(self.grid.quarantine.people, self.selectedPerson)

            if self.selectedPerson.Qtimer > 0 and self.selectedPerson.escapeTimer > 6 then
                self.selectedPerson.Qtimer = 0
            end

            self.selectedPerson.selected = false
            self.selectedPerson = nil
            self.state = 'idle'
        end
    end
end

function Player:tileIn(x, y)
    if not(x and y) then
        x = self.x
        y = self.y
    end

    local curTile

    for _, tile in pairs(self.grid.tiles) do
        if tile.tileX <= x and tile.tileY <= y then
            curTile = tile
        end
    end

    return curTile
end

function Player:render()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(self.shadow, math.floor(self.x - 33), math.floor(self.y - self.height / 4),
        0, self.grid.tileSize / 20, self.grid.tileSize / 20)

    love.graphics.draw(self.atlas, self.animation:getCurrentFrame(), math.floor(self.x),
        math.floor(self.y - self.height), 0,
        self.grid.tileSize / 20, self.grid.tileSize / 20, math.floor(self.width / 2), math.floor(self.height / 2))
end