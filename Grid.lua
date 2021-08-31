Grid = Class{}

function Grid:init(width, height, tileSize)
    Timer = 0
    self.width = width
    self.height = height
    self.tileSize = tileSize
    self.widthPix = self.width * self.tileSize
    self.heightPix = self.height * self.tileSize
    self.fade = 1

    self.gridX = math.floor(WINDOW_WIDTH / 2 - self.widthPix / 2)
    self.gridY = math.floor(WINDOW_HEIGHT / 2 - self.heightPix / 2) + 39

    self.background = love.graphics.newImage('buildings/background.png')
    self.tiles = {}

    self.path = love.graphics.newImage('tiles/path.png')
    self.path1 = love.graphics.newImage('tiles/path1.png')
    self.grass = {
        love.graphics.newImage('tiles/grass.png'),
        love.graphics.newImage('tiles/grass1.png'),
        love.graphics.newImage('tiles/grass2.png'),
        love.graphics.newImage('tiles/grass3.png'),
        love.graphics.newImage('tiles/grass4.png')
    }

    self.grassPat = {}

    self.blockedSymbol = love.graphics.newImage('tiles/blocked.png')

    math.randomseed(os.time())

    for h = 1, self.height do
        for w = 1, self.width do
            local pos = (h - 1) * self.width + w

            self.tiles[pos] = {}

            self.tiles[pos].position = pos

            self.tiles[pos].tileX = (w - 1) * self.tileSize + self.gridX
            self.tiles[pos].tileY = (h - 1) * self.tileSize + self.gridY

            self.tiles[pos].person = nil
            self.tiles[pos].infected = 'clean'
            self.tiles[pos].blocked = false
            self.tiles[pos].building = false

            table.insert(self.grassPat, pos, math.random(#self.grass))
        end
    end
    self.Ptimer = 10
    self.Mtimer = 0
    self.things = {}
    self.idNum = 1
    self.personCount = 0
    self.sickPeople = 0

    self.player = Player(self)
    table.insert(self.things, self.player)

    self.quarantine = Building(self, 'quarantine')
    table.insert(self.things, self.quarantine)

    table.insert(self.things, Building(self, 'shop'))
    table.insert(self.things, Building(self, 'bank'))
    table.insert(self.things, Building(self, 'med lab'))

    self.flag = nil
    self.menu = nil
    self.ui = UI(self)

    items[1].amount = 200
    self.incomeRate = 10
    self.income = 10

    for _, option in pairs(menus.bank.options) do
        option.price = 100
    end

    self.pTimer = 10
    self.mTimer = 5

    self.score = 0
end

function Grid:update(dt)
    for _, tile in pairs(self.tiles) do
        tile.highlighted = false
        tile.infected = 'clean'
        tile.person = nil
        tile.blocked = (tile.blocked == 'const') and 'const' or false
    end

    self.personCount = 0
    self.sickPeople = 0
    for _, thing in pairs(self.things) do
        if thing.type == 'person' or thing.type == 'player' then thing:update(dt) end
        if thing.type == 'person' and thing.state ~= 'quarantine' then
            if thing.carrier then self.sickPeople = self.sickPeople + 1 end
            self.personCount = self.personCount + 1
        end
    end

    self.pTimer = self.pTimer + dt
    self.mTimer = self.mTimer + dt

    if self.pTimer > 10 + math.floor(self.personCount / 2) and self.personCount < 40 and not tutorial then
        table.insert(self.things, Person(grid, self.idNum))
        self.idNum = self.idNum + 1
        self.pTimer = 0
    end

    if self.mTimer > self.incomeRate and self.personCount > 0 then
        items[1].amount = items[1].amount + (self.income * self.personCount)
        self.ui:purchase(items[1], (self.income * self.personCount))
        self.mTimer = 0
    end

    self.score = self.score + (self.personCount * dt)

    if math.floor(self.score) > highScore then
        highScore = math.floor(self.score)
    end

    self.ui:update()

    if (self.sickPeople >= self.personCount and self.personCount > 3) then
        keyMenu = Menu(self, 'game over')

        save()
    end

    if self.fade > 0 then
        self.fade = self.fade - 0.05
    end

    Timer = Timer + dt
end

function Grid:adjacentTile(direction, position)
    -- returns the adjacent tile in given direction if the tile exists
    if direction == 1 then
        if position - self.width > 0 then
            return self.tiles[position - self.width]
        else
            return false
        end
    elseif direction == 2 then
        if position % self.width ~= 0 then
            return self.tiles[position + 1]
        else
            return false
        end
    elseif direction == 3 then
        if position + self.width <= self.width * self.height then
            return self.tiles[position + self.width]
        else
            return false
        end
    elseif direction == 4 then
        if (position - 1) % self.width ~= 0 then
            return self.tiles[position - 1]
        else
            return false
        end
    end
end

function Grid:render()
    --love.graphics.clear(0.2, 0.2, 0.2)
    love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.draw(self.background)

    -- render the grid
    for pos, tile in pairs(self.tiles) do
        local texture

        love.graphics.setColor(1, 1, 1, 1)

        if pos % self.width == 0 or pos % self.width == 1 then
            texture = self.path
        elseif math.ceil(pos / self.width) == 1 or math.ceil(pos / self.width) == self.height then
            texture = self.path1
        else
           texture = self.grass[self.grassPat[pos]]

            if (self.width % 2 == 1 and pos % 2 == 0) or
                (self.width % 2 == 0 and pos % 2 == math.ceil(pos / self.width) % 2) then

                love.graphics.setColor(0.95, 0.95, 0.95, 1)
            end
        end


        love.graphics.draw(texture, tile.tileX, tile.tileY, 0, self.tileSize / 20, self.tileSize / 20)

        if tile.highlighted == 'red' then
            love.graphics.setColor(1, 0, 0, 1/15 * math.sin(2 * Timer) + 1/4)
            love.graphics.rectangle('fill', tile.tileX, tile.tileY, self.tileSize, self.tileSize)
        end

        if tile.highlighted == 'white' then
            love.graphics.setColor(1, 1, 1, 1/15 * math.sin(2 * Timer) + 1/4)
            love.graphics.rectangle('fill', tile.tileX, tile.tileY, self.tileSize, self.tileSize)
        end

        if tile.highlighted == 'blocked' then
            love.graphics.setColor(1, 1, 1, 1/15 * math.sin(2 * Timer) + 1/4)
            love.graphics.draw(self.blockedSymbol, tile.tileX, tile.tileY, 0, 3, 3)
        end
    end

    -- render objects from the top of the grid to the bottom (to give depth)
    table.sort(self.things,
        function(i, j)
            if i.y ~= j.y then
                return i.y < j.y
            else
                if math.abs(i.x - j.x) > 3 then
                    return i.x > j.x
                else
                    if i.id and j.id then
                        return i.id > j.id
                    else
                        return true
                    end
                end
            end
        end)

    for _, thing in pairs(self.things) do
        thing:render()
    end

    love.graphics.setColor(1, 1, 1, 1)

    if self.flag then
        self.flag:render()
    end

    if self.menu then
        self.menu:render()
    end

    self.ui:render()

    if self.fade > 0 then
        love.graphics.setColor(0, 0, 0, self.fade)
        love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    end
end