Building = Class{}

function Building:init(grid, type)
    self.type = type
    self.grid = grid

    if self.type == 'shop' then
        self.texture = love.graphics.newImage('buildings/shop.png')

        self.x = self.grid.gridX - 18
        self.y = self.grid.gridY + 120
        self.ry = self.grid.gridY - 75
        self.width = 276
        self.height = 150

        for i = 0, 1 do
            for j = 1, 4 do
                self.grid.tiles[self.grid.width * i + j].blocked = 'const'
                self.grid.tiles[self.grid.width * i + j].building = self
            end
        end
    elseif self.type == 'quarantine' then
        self.texture = love.graphics.newImage('buildings/quarantine.png')

        self.bedTextures = {
            love.graphics.newImage('buildings/beds1.png'),
            love.graphics.newImage('buildings/beds2.png'),
            love.graphics.newImage('buildings/beds3.png'),
            love.graphics.newImage('buildings/beds4.png')
        }

        self.top = love.graphics.newImage('buildings/quarantine top.png')

        self.x = self.grid.gridX - 90
        self.y = self.grid.gridY + self.grid.heightPix
        self.ry = self.grid.gridY + self.grid.heightPix - 294
        self.width = 147
        self.height = 260

        for i = self.grid.height - 3, self.grid.height - 1 do
            self.grid.tiles[self.grid.width * i + 1].blocked = 'const'
            self.grid.tiles[self.grid.width * i + 1].building = self
        end

        self.level = 1

        self.beds = {{}, {}, {}, {}}
        self:loadBeds()

        self.people = {}
    elseif self.type == 'bank' then
        self.texture = love.graphics.newImage('buildings/bank.png')

        self.x = self.grid.gridX + self.grid.widthPix - 252
        self.y = self.grid.gridY + 120
        self.ry = self.grid.gridY - 75
        self.width = 267
        self.height = 200

        for i = 0, 1 do
            for j = self.grid.width - 3, self.grid.width do
                self.grid.tiles[self.grid.width * i + j].blocked = 'const'
                self.grid.tiles[self.grid.width * i + j].building = self
            end
        end
    elseif self.type == 'med lab' then
        self.texture = love.graphics.newImage('buildings/lab.png')

        self.x = self.grid.gridX + self.grid.widthPix - 117
        self.y = self.grid.gridY + self.grid.heightPix
        self.ry = self.grid.gridY + self.grid.heightPix - 306
        self.width = 258
        self.height = 260

        for i = self.grid.height - 3, self.grid.height do
            self.grid.tiles[self.grid.width * i].blocked = 'const'
            self.grid.tiles[self.grid.width * i].building = self
        end
    end
end

function Building:loadBeds()
    for n = 1, 4 do
        local beds = self.beds[n]
        for i = 1, n + 2 do
            if not beds[i] then
                beds[i] = {}
                beds[i].open = true
            end

            if i < 5 then
                beds[i].side = true
                beds[i].x = self.x + (n < 3 and 72 or 54)
                beds[i].y = self.ry + 207 + (n == 1 and 66 or 45) * (i - 1)
            else
                beds[i].x = self.x + 126
                beds[i].y = self.ry + (n == 3 and 231 or 186) + (i == 6 and 90 or 0)
            end
        end
    end
end

function Building:render()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(self.texture, self.x, self.ry, 0, 3, 3)

    if self.type == 'quarantine' then

        love.graphics.draw(self.bedTextures[self.level], self.x + (self.level < 3 and 30 or 9), self.ry + 105, 0, 3, 3)

        for _, person in pairs(self.people) do
            love.graphics.draw(person.texture, person.animation:getCurrentFrame(),
                math.floor(person.x - person.width / 2), math.floor(person.y - person.height),
                    person.r, person.grid.tileSize / 20, person.grid.tileSize / 20)
        end

        love.graphics.draw(self.top, self.x, self.ry, 0, 3, 3)
    end
end