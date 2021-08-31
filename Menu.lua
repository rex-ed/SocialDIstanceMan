Menu = Class{}

menus = {
    ['shop'] = {
        ['background'] = love.graphics.newImage('buildings/shop menu.png'),
        ['width'] = 240,
        ['height'] = 226,
        ['item shadow'] = love.graphics.newImage('objects/shadow.png'),
        ['price tag'] = love.graphics.newImage('objects/price tag.png'),
        ['start'] = 2,
        ['length'] = 6
    },
    ['bank'] = {
        ['background'] = love.graphics.newImage('buildings/bank menu.png'),
        ['width'] = 240,
        ['height'] = 158,
        ['options'] = {
            { -- income per person
                ['icon'] = love.graphics.newImage('objects/income per person.png'),
                ['value'] = 'income',  -- use grid[value] for per person amount
                ['description'] = 'increase the income collected per person',
                ['scale'] = 0,
                ['price'] = 100,
            },
            { -- income rate
                ['icon'] = love.graphics.newImage('objects/income rate.png'),
                ['value'] = 'incomeRate',
                ['description'] = 'increase the rate at which income is collected',
                ['scale'] = 0,
                ['price'] = 100,
            },
        },
        ['option highlight'] = love.graphics.newImage('objects/bank icon highlight.png'),
    },
    ['quarantine'] = {
        ['background'] = love.graphics.newImage('buildings/quarantine menu.png'),
        ['page'] = love.graphics.newImage('objects/quarantine page.png'),
        ['width'] = 192,
        ['height'] = 230,
        ['options'] = {
            {
                ['header'] = 'patients',
                ['bar'] = love.graphics.newImage('objects/loading bar.png'),
                ['generic person'] = love.graphics.newImage('people/person1 front.png')
            },
            {
                ['header'] = 'capacity',
                ['beds'] = {
                    love.graphics.newImage('buildings/beds1.png'),
                    love.graphics.newImage('buildings/beds2.png'),
                    love.graphics.newImage('buildings/beds3.png'),
                    love.graphics.newImage('buildings/beds4.png'),
                },
                ['button'] = love.graphics.newImage('objects/button.png'),
                ['arrow'] = love.graphics.newImage('objects/arrow.png'),
            },
        },
    },
    ['med lab'] = {
        ['background'] = love.graphics.newImage('buildings/med lab menu.png'),
        ['width'] = 200,
        ['height'] = 206,
        ['options'] = {
            {
                ['icon'] = love.graphics.newImage('objects/tests highlighted.png'),
                ['x'] = 70,
                ['y'] = 112,
                ['title'] = 'purchase a test',
                ['C description'] = 'use on asymptomatic visitors to see if they are silent carriers. results ',
                ['V description'] = 'take ' .. items[8].speed .. ' seconds.',
                ['price'] = 150
            },
            {
                ['icon'] = love.graphics.newImage('objects/census highlighted.png'),
                ['x'] = 138,
                ['y'] = 92,
                ['title'] = 'take a census',
                ['C description'] = 'mass test everyone in the park to see the total number of infected people.',
                ['V description'] = '',
                ['price'] = 250
            },
            {
                ['icon'] = love.graphics.newImage('objects/microscope highlighted.png'),
                ['x'] = 1,
                ['y'] = 56,
                ['title'] = 'fund research',
                ['C description'] = 'speeds up the process of getting test results back. ',
                ['V description'] = 'time reduced from ' .. items[8].speed .. ' seconds to ' .. items[8].speed - 10 .. ' seconds.',
                ['price'] = 100
            },
        },
        ['census'] = love.graphics.newImage('objects/census.png'),
        ['censusWidth'] = 168,
        ['censusHeight'] = 172,
    },
    ['welcome sign'] = {
        ['background'] = love.graphics.newImage('buildings/welcome sign.png'),
        ['width'] = 161,
        ['height'] = 150,
        ['options'] = {
            'yes',
            'no'
        },
        ['cooldown'] = 5,
        ['cooldownStart'] = -5,
    },
    ['main'] = {
        ['background'] = function() return love.window.getFullscreen() and love.graphics.newImage('buildings/big main.png') or love.graphics.newImage('buildings/main menu background.png') end,
        ['width'] = function() return love.window.getFullscreen() and 455 or 427 end,
        ['height'] = function() return love.window.getFullscreen() and 256 or 231 end,
        ['title'] = love.graphics.newImage('objects/title.png'),
        ['SDM'] = love.graphics.newImage('objects/big SDM.png'),
        ['viruses'] = love.graphics.newImage('objects/main viruses.png'),
        ['options'] = {
            'start game',
            'how to play',
            'options',
            'give feedback',
            'quit',
        }
    },
    ['pause'] = {
        ['background'] = love.graphics.newImage('buildings/pause menu.png'),
        ['width'] = 144,
        ['height'] = 101,
        ['zzz'] = love.graphics.newImage('objects/zzz.png'),
        ['options'] = {
            ['paused'] = {
                'resume',
                'quit'
            },
            ['are you sure you want to quit?'] = {
                'yes',
                'no'
            }
        },
        ['length'] = 2
    },
    ['game over'] = {
        ['background'] = love.graphics.newImage('buildings/game over.png'),
        ['width'] = 160,
        ['height'] = 127,
        ['options'] = {
            'retry',
            'quit'
        },
    },
    ['options'] = {
        ['background'] = love.graphics.newImage('buildings/options menu.png'),
        ['width'] = 139,
        ['height'] = 120,
        ['options'] = {
            'up',
            'left',
            'down',
            'right',
            'select',
            'back',
            'pause',
            'fullscreen',
            'quarantine',
            'sanitizer',
            'gloves',
            'shield',
            'mask',
            'rod',
            'tube',
            'apply changes',
            'cancel',
            'restore defaults'
        }
    },
    ['button'] = love.graphics.newImage('objects/button.png'),
    ['button highlight'] = love.graphics.newImage('objects/button highlight.png'),
}

function Menu:init(grid, type)
    self.type = type

    self.grid = grid

    self.scale = 0
    self.rWidth = 0
    self.rHeight = 0

    self.dim = 0
    self.state = 'enter'

    self.selectedItem = menus[self.type].start or 1

    if self.type == 'shop' then
        for _, item in pairs(items) do
            if _ < 8 and _ > 1 then
                item.scale = 0
                item.example = love.graphics.newImage('objects/' .. item.type .. ' example.png')
            end
        end
    elseif self.type == 'quarantine' then
        self.pgTurn = Animation ({
            frames = {
                love.graphics.newQuad(0, 0, 123, 175, menus.quarantine.page:getDimensions()),
                love.graphics.newQuad(125, 0, 123, 175, menus.quarantine.page:getDimensions()),
                love.graphics.newQuad(249, 0, 123, 175, menus.quarantine.page:getDimensions()),
                love.graphics.newQuad(372, 0, 123, 175, menus.quarantine.page:getDimensions()),
                love.graphics.newQuad(495, 0, 123, 175, menus.quarantine.page:getDimensions()),
            },
            interval = 0.05,
        })

        menus.quarantine.upgradePrice = math.floor(300 * (1.5 ^ (self.grid.quarantine.level - 1)))
    elseif self.type == 'pause' then
        self.pauseState = 'paused'
    elseif self.type == 'options' then
        self.tempControls = {}
        for i, option in pairs(menus.options.options) do
            if i < 16 then
                self.tempControls[i] = controls[option] and controls[option] or controls.items[i - 8]
            end
        end
    elseif self.type == 'main' then
        --self.intro = love.audio.newSource('Piano roll.mp3', 'static')
        --love.audio.play(self.intro)
    end
end

function Menu:keyPressed(key)
    if self.state == 'input' then
        self.tempControls[self.selectedItem] = key
        self.state = 'static'
        return
    end

    if self.state ~= 'static' then
        if self.state == 'census' and key == controls.select then
            self.census.scale = self.census.scale - 0.01
        elseif  key == controls.back and self.type ~= 'main' and self.type ~= 'game over' then
            self.state = 'exit'
        end

        return
    end

    if key == controls.back and self.type ~= 'main' then
        self.state = 'exit'
    end

    local list = (self.type == 'shop' and items or menus[self.type].options)
    local start = menus[self.type].start or 1
    local length = menus[self.type].length or #menus[self.type].options

    if self.type ~= 'options' and (key == controls.right or (self.type ~= 'shop' and key == controls.down))
        and self.selectedItem ~= (length + start - 1) then
        self.selectedItem = self.selectedItem + 1
        if self.type == 'quarantine' then self.state = 'turn' end
    elseif self.type ~= 'options' and (key == controls.left or (self.type ~= 'shop' and key == controls.up))
        and self.selectedItem ~= start then
        self.selectedItem = self.selectedItem - 1
        if self.type == 'quarantine' then self.state = 'turn' end
    elseif key == controls.select then
        if self.type == 'quarantine' then
            if self.selectedItem == 1 then
                self.selectedItem = 2
                self.state = 'turn'
            elseif items[1].amount > menus.quarantine.upgradePrice and
                self.grid.quarantine.level < 4 then

                items[1].amount = items[1].amount - menus.quarantine.upgradePrice
                self.grid.ui:purchase(items[1], -menus.quarantine.upgradePrice)
                menus.quarantine.upgradePrice = 300 * (1.5) ^ self.grid.quarantine.level
                self.grid.quarantine.level = self.grid.quarantine.level + 1

                for _, person in pairs(self.grid.quarantine.people) do
                    person.Qstate = 'entering'
                end
            end
        elseif self.type == 'welcome sign' then
            if self.selectedItem == 1 and (Timer - menus[self.type].cooldownStart) > menus[self.type].cooldown then
                table.insert(self.grid.things, Person(grid, self.grid.idNum, self.grid.player.direction))
                self.grid.idNum = self.grid.idNum + 1
                menus[self.type].cooldownStart = Timer
            end

            self.state = 'exit'
        elseif self.type == 'pause' then
            if self.pauseState == 'paused' then
                if self.selectedItem == 1 then
                    self.state = 'exit'
                else
                    self.pauseState = 'are you sure you want to quit?'
                end
            else
                if self.selectedItem == 1 then
                    self.state = 'fade out'
                    tutorial = nil 
                else
                    self.pauseState = 'paused'
                end
            end
        elseif self.type == 'main' then
            if self.selectedItem == 3 then
                self.menu = Menu(nil, 'options')
            elseif self.selectedItem == 4 then
            love.system.openURL('https://docs.google.com/forms/d/e/1FAIpQLSchyFUm3OYod7hflU7RGn7T6SaqeMH481gPKOrM_IRffYbeZA/viewform?usp=sf_link')
            elseif self.selectedItem == 5 then
                love.event.quit()
            else
                self.state = 'fade out'
            end
        elseif self.type == 'game over' then
            self.state = 'fade out'
        elseif self.type == 'options' then
            if self.selectedItem < 16 then
                self.state = 'input'
            elseif self.selectedItem == 16 then
                for i, entry in pairs(menus.options.options) do
                    if controls[entry] then
                        controls[entry] = self.tempControls[i]
                    elseif controls.items[entry] then
                        controls.items[entry] = self.tempControls[i]
                    end
                end

                save()
                self.state = 'exit'
            elseif self.selectedItem == 17 then
                self.state = 'exit'
            elseif self.selectedItem == 18 then
                controls = defaultControls
                save()
                self.state = 'exit'
            end
        elseif list[self.selectedItem].price ~= 'maxed out' and list[self.selectedItem].price <= items[1].amount then
                items[1].amount = items[1].amount - list[self.selectedItem].price
                    self.grid.ui:purchase(items[1], -list[self.selectedItem].price)

            if self.type == 'shop' then
                list[self.selectedItem].amount = list[self.selectedItem].amount + (self.selectedItem == 2 and 3 or 1)
                self.grid.ui:purchase(list[self.selectedItem], (self.selectedItem == 2 and 3 or 1))
            elseif self.type == 'bank' then
                if self.selectedItem == 1 then
                    self.grid.income = self.grid.income + 2
                    list[1].price = math.floor(list[1].price * 1.5)
                elseif self.grid.incomeRate > 1 then
                    self.grid.incomeRate = self.grid.incomeRate - 1
                    list[2].price = self.grid.incomeRate == 1 and 'maxed out' or math.floor(list[2].price * 1.8)
                end
            elseif self.type == 'med lab' then
                if self.state ~= 'census' then
                    if self.selectedItem == 1 then
                        items[8].amount = items[8].amount + 1
                        self.grid.ui:purchase(items[8], 1)
                    elseif self.selectedItem == 2 then
                        local sick = 0
                        for _, person in pairs(self.grid.things) do
                            if person.type == 'person' and person.sick and person.state ~= 'quarrantine' then
                                sick = sick + 1
                            end
                        end

                        self.census = {
                            ['scale'] = 0,
                            ['stats'] = {
                                {['name'] = 'total people', ['num'] = self.grid.personCount},
                                {['name'] = 'total infected', ['num'] = self.grid.sickPeople},
                                {['name'] = 'sick people', ['num'] = sick},
                                {['name'] = 'silent carriers', ['num'] = self.grid.sickPeople - sick},
                            },
                        }
                        self.state = 'census'
                    else
                        if items[8].speed > 0 then
                            items[8].speed = items[8].speed - 5
                            list[self.selectedItem].price = items[8].speed > 0 and
                                list[self.selectedItem].price * 1.5 or 'maxed out'
                            list[1]['V description'] = (items[8].speed > 0 and 'take ' .. items[8].speed .. ' seconds.' or 'available instantly.')
                            list[3]['V description'] = items[8].speed > 0 and 'time reduced from ' .. items[8].speed .. ' seconds to ' ..
                                (items[8].speed > 5 and items[8].speed - 5 .. ' seconds' or 'instantly') or 'tests fully upgraded' .. '.'
                        end
                    end
                end
            end
        end
    end

    if self.type == 'shop' then
        if key == controls.up then
            self.selectedItem = (self.selectedItem < (4 + menus[self.type].start - 1) and self.selectedItem + 3
                or self.selectedItem - 3)
        elseif key == controls.down then
            self.selectedItem = (self.selectedItem > (3 + menus[self.type].start - 1) and self.selectedItem - 3
                or self.selectedItem + 3)
        end
    elseif self.type == 'options' then
        if key == controls.right then
            if self.selectedItem > 15 then
                self.selectedItem = self.selectedItem + (self.selectedItem < 18 and 1 or -2)
            elseif self.selectedItem < 9 then
                self.selectedItem = self.selectedItem + 8
            end
        elseif key == controls.left then
            if self.selectedItem > 15 then
                self.selectedItem = self.selectedItem - (self.selectedItem > 16 and 1 or -2)
            elseif self.selectedItem > 8 then
                self.selectedItem = self.selectedItem -8
            end
        elseif key == controls.up then
            if self.selectedItem ~= 1 and self.selectedItem ~= 9 and self.selectedItem < 16 then
                self.selectedItem = self.selectedItem - 1
            elseif self.selectedItem == 16 then
                self.selectedItem = 8
            elseif self.selectedItem == 18 then
                self.selectedItem = 15
            end
        elseif key == controls.down then
            if self.selectedItem ~= 8 and self.selectedItem < 15 then
                self.selectedItem = self.selectedItem + 1
            elseif self.selectedItem == 8 then
                self.selectedItem = 16
            elseif self.selectedItem == 15 then
                self.selectedItem = 18
            end
        end
    end
end

function Menu:update(dt)
    if self.state == 'enter' then
        if self.scale + (self.type == 'main' and 0.3 or 0.5) <  (self.type == 'main' and WINDOW_WIDTH / menus.main.width() or 3) then
            self.scale = self.scale + (self.type == 'main' and 0.3 or 0.5)
            self.dim = self.dim + 0.1
        else
            self.scale = 3
            self.state = 'static'
        end
    elseif self.state == 'exit' then
        if self.scale > 0 then
            self.scale = self.scale - 0.5
            self.dim = self.dim - 0.1
        else
            self.scale = 0

            if self.type == 'options' then
                keyMenu.menu = nil
            else
                self.grid.menu = nil
                keyMenu = nil
                if not self.grid.player.selectedPerson then
                    self.grid.player.state = 'idle'
                end
            end
        end
    elseif self.state == 'fade out' then
        if not self.fade then
            self.fade = 0
        else
            if self.fade < 2 then
                self.fade = self.fade + 0.05
            else
                if self.type == 'pause' or (self.type == 'game over' and self.selectedItem == 2) then
                    keyMenu = Menu(nil, 'main')
                    grid = nil
                else
                    keyMenu = nil
                    if self.selectedItem == 1 then
                        grid = Grid(16, 10, 60)
                    elseif self.selectedItem == 2 then
                        tutorial = Tutorial()
                    end
                end
            end
        end
    elseif self.state == 'turn' then
        local reverse = (self.selectedItem == 1) and true or false

        self.pgTurn:update(dt, reverse)

        if self.pgTurn:isOver(reverse) then
            self.state = 'static'
        end
    elseif self.state == 'census' then
        self.census.scale = self.census.scale + (self.census.scale * 100 % 2 == 0 and
            (self.census.scale < 1 and 0.12 or 0) or -0.1)
        if self.census.scale < 0 then self.state = 'static' end
    end

    if self.type == 'shop' or self.type == 'bank' then
        local list = (self.type == 'shop' and items or menus.bank.options)

        for _, option in pairs(list) do
            option.scale = self.scale
        end
        list[self.selectedItem].scale = self.scale + 1
    end

    if self.type ~= 'main' then
        self.rWidth = self.scale * menus[self.type].width
        self.rHeight = self.scale * menus[self.type].height
    else
        self.rWidth = self.scale * menus.main.width()
        self.rHeight = self.scale * menus.main.height()

        if self.menu then self.menu:update() end
    end

end

local key = love.graphics.newImage('objects/key.png')
local keyLeft = love.graphics.newQuad(0, 0, 5, 13, key:getDimensions())
local keyMid = love.graphics.newQuad(5, 0, 6, 13, key:getDimensions())
local keyRight = love.graphics.newQuad(11, 0, 5, 13, key:getDimensions())

function drawKey(x, y, word, opacity)
    if word == 'return' then
        word = 'enter'
    elseif word == 'rshift' then
        word = 'shift'
    elseif word == 'lctrl' then
        word = 'ctrl'
    elseif word == 'escape' then
        word = 'esc'
    end
    local keyWidth = (#word) * 12

    love.graphics.setColor(1, 1, 1, opacity)
    love.graphics.draw(key, keyLeft, x, y, 0, 2, 2)
    love.graphics.draw(key, keyMid, x + 10, y, 0, keyWidth / 6 , 2)
    love.graphics.draw(key, keyRight, x + 10 + keyWidth, y, 0, 2, 2)

    love.graphics.setColor(0, 0, 0, opacity)
    love.graphics.setFont(MED_WONDER)
    love.graphics.printf(word, x + 1, y + 3, keyWidth + 20, "center")
end

function textbox(x, y, width, height, scale, opacity)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', x + scale, y, (width - 1) * scale, scale)
    love.graphics.rectangle('fill', x, y + scale, scale, (height - 1) * scale)
    love.graphics.rectangle('fill', x + scale, y + (height * scale), (width - 1) * scale, scale)
    love.graphics.rectangle('fill', x + (width * scale), y + scale, scale, (height - 1) * scale)

    opacity = opacity or 0.8
    love.graphics.setColor(1, 1, 1, opacity)
    love.graphics.rectangle('fill', x + scale, y + scale, (width - 1) * scale, (height - 1) * scale)

    love.graphics.setColor(1, 1, 1, 1)
end

function Menu:render()
    love.graphics.setColor(0, 0, 0, self.dim)
    love.graphics.rectangle('fill', 1, 1, WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)

    local x = math.floor((WINDOW_WIDTH / 2) - (self.rWidth / 2))
    local y = math.floor((WINDOW_HEIGHT / 2) - (self.rHeight / 2))

    if self.type ~= 'main' then
        love.graphics.draw(menus[self.type].background, x, y, 0, self.scale, self.scale)
    end

    if self.type ~= 'main' and self.type ~= 'game over' and (self.state == 'static' or self.state == 'turn') then
        drawKey(x + self.rWidth + 5, y + 10, controls.back)
        love.graphics.print('to exit', x + self.rWidth + 10, y + 35)
    end

    love.graphics.setColor(1, 1, 1, 1)
    if self.type == 'shop' then
        textbox(x + 6 * self.scale, y + 154 * self.scale, 227, 67, self.scale)
        local i = 0
        for _, item in pairs(items) do
            if _ > 1 and _ < 8 then

            local itemX = math.floor(x + ((62 + (62 * (i < 3 and i or i - 3))) * self.scale))
            local itemY = math.floor(y + (((i < 3 and 103 or 138)) * self.scale))

            love.graphics.setColor(1, 1, 1, 1)
            if item.shadow then
                love.graphics.draw(item.shadow, itemX  - (item.width / 2), itemY, 0, item.scale, 
                item.scale, math.floor(item.width / 2), item.height)
            else
                love.graphics.draw(menus.shop['item shadow'], itemX + item.width / 2, itemY + 6, 0, item.scale, item.scale, 11, 9)
            end

            if _ ~= self.selectedItem then
                love.graphics.setColor(0.85, 0.85, 0.85, 1)
            end

            love.graphics.draw(item.icon, itemX  - (item.width / 2), itemY, 0, item.scale, 
                item.scale, math.floor(item.width / 2), item.height)

            if _ == self.selectedItem and love.keyboard.isDown(controls.select) then
                love.graphics.setBlendMode('add')
                love.graphics.setColor(1, 1, 1, 0.3)
                love.graphics.draw(item.icon, itemX  - (item.width / 2), itemY, 0, item.scale, 
                item.scale, math.floor(item.width / 2), item.height)
                love.graphics.setBlendMode('alpha')
            end

            love.graphics.setColor(1, 1, 1, 1)
            
            love.graphics.draw(menus.shop["price tag"], itemX - 42, itemY + 6, 0, self.scale, self.scale)
            
            if item.price < items[1].amount then
                love.graphics.setColor(0, 0.4, 0.1, 1)
            else
                love.graphics.setColor(0.8, 0, 0, 1)
            end
            love.graphics.setFont(MED_WONDER)
            love.graphics.printf(item.price, itemX - 42, itemY + 9, 56, 'right')
            love.graphics.print('$', itemX - 37, itemY + 9)

            i = i + 1

            end
        end

        love.graphics.setColor(0, 0, 0, self.scale / 3)
        love.graphics.setFont(BIG_WONDER)
        love.graphics.printf(items[self.selectedItem].name, x + 24, y + 468, 224 * self.scale, 'center')

        love.graphics.setFont(MED_WONDER)
        love.graphics.printf(items[self.selectedItem].description, x + 36, y + 513, 400)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(items[self.selectedItem].example,
            x + 189 * self.scale, y + 191 * self.scale, 0, self.scale / 3, self.scale / 3, 112, 80)

    elseif self.type == 'bank' then
        local i = 0

        love.graphics.setColor(1, 1, 1, 1)
        textbox(x + (self.selectedItem == 1 and 30 or 35) * self.scale, y + 126 * self.scale,
            (self.selectedItem == 1 and 178 or 168), 20, self.scale)

        for _, option in pairs(menus.bank.options) do
            local optionX = x + ((141 + i) * self.scale / 3) + (26 * self.scale)
            local optionY = y + (100 * self.scale / 3) + (25 * self.scale) - (_ == self.selectedItem and 12 or 0)

            if option.price ~= 'maxed out' and option.price < items[1].amount then
                love.graphics.setColor(1, 1, 1, 1)
            else
                love.graphics.setColor(0.5, 0.5, 0.5, 1)
            end

            if _ == self.selectedItem then
                love.graphics.draw(menus.bank["option highlight"], optionX, optionY, 0, self.scale, self.scale, 30, 28)

                love.graphics.draw(menus["button highlight"], optionX, optionY + (120 * self.scale / 3) +
                (_ == self.selectedItem and 12 or 0), 0, self.scale, self.scale, 36, 10)
            end

            love.graphics.draw(option.icon, optionX, optionY, 0, self.scale, self.scale, 26, 25)

            love.graphics.rectangle('fill', optionX - 31 * self.scale, optionY + 34 * self.scale +
                (_ == self.selectedItem and 12 or 0), 60 * self.scale, 12 * self.scale)
            love.graphics.setColor((option.price ~= 'maxed out' and option.price <= items[1].amount) and 0 or 1,
                (option.price ~= 'maxed out' and option.price <= items[1].amount) and 1 or 0, 0, 1)
            love.graphics.draw(menus.button, optionX, optionY + (40 * self.scale) +
                (_ == self.selectedItem and 12 or 0), 0, self.scale, self.scale, 32, 7)

                if _ == self.selectedItem and love.keyboard.isDown(controls.select) then
                    love.graphics.setBlendMode('add')
                    love.graphics.setColor(1, 1, 1, 0.3)
                    love.graphics.draw(menus.button, optionX, optionY + (40 * self.scale) +
                    (_ == self.selectedItem and 12 or 0), 0, self.scale, self.scale, 32, 7)
                    love.graphics.setBlendMode('alpha')
                end

            if self.state == 'static' then
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.setFont(BIG_WONDER)
                if option.price == 'maxed out' then
                    love.graphics.printf('maxed out', optionX - 96, optionY + 114
                    + (_ == self.selectedItem and 12 or 0), 192, 'center')
                else
                    love.graphics.printf('upgrade\n' .. option.price .. '$', optionX - 96, optionY + 106
                        + (_ == self.selectedItem and 12 or 0), 192, 'center')
                end

                if option.value == 'income' then
                    love.graphics.print(self.grid.income, optionX - 62, optionY + 62)
                    love.graphics.print(self.grid.income + 1, optionX + 36, optionY + 62)
                    love.graphics.setFont(MED_WONDER)
                    love.graphics.print('$', optionX - 75, optionY + 66)
                    love.graphics.print('$', optionX + 23, optionY + 66) 
                else
                    love.graphics.print(self.grid.incomeRate, optionX - 62, optionY + 50)
                    love.graphics.print(self.grid.incomeRate - 1, optionX + 43, optionY + 50)
                    love.graphics.setFont(MED_WONDER)
                    love.graphics.print('sec           sec', optionX - 70, optionY + 70)
                end

                love.graphics.setFont(BIG_WONDER)
                love.graphics.printf(menus.bank.options[self.selectedItem].description, x + 100, y + 388, 520, 'center')
            end

            i = i + 300
        end
    elseif self.type == 'quarantine' then
        local capacity = self.grid.quarantine.level + 2
        local pages = menus.quarantine.options

        if self.selectedItem == 2 or self.state == 'turn' then
            love.graphics.setColor(0, 0, 0, self.scale / 3)
            love.graphics.setFont(HUGE_WONDER)
            love.graphics.print(pages[2].header, x + 200 * self.scale / 3, y + 263 * self.scale / 3)
            love.graphics.setColor(1, 1, 1, 1)

            love.graphics.draw(pages[2].beds[self.grid.quarantine.level],
                x + (self.grid.quarantine.level < 3 and 75 or 64) * self.scale, y + 124 * self.scale,
                    0, self.scale * 2/3, self.scale * 2/3, 25, 30)
            
            if self.grid.quarantine.level < 4 then
                love.graphics.draw(pages[2].beds[self.grid.quarantine.level + 1],
                    x + (self.grid.quarantine.level < 3 and 129 or 131) * self.scale,
                        y + 124 * self.scale, 0, self.scale * 2/3, self.scale * 2/3, 25, 30)
            else
                love.graphics.setFont(BIG_WONDER)
                love.graphics.setColor(0, 0, 0, self.scale / 3)
                love.graphics.printf('maxed\nout', x + 117 * self.scale, y + 118 * self.scale, 100, 'center')
            end

            if items[1].amount >= menus.quarantine.upgradePrice and self.grid.quarantine.level < 4 then
                love.graphics.setColor(0, 1, 0, 1)
            else
                love.graphics.setColor(1, 0, 0, 1)
            end
            love.graphics.draw(menus.button, x + 96 * self.scale, y + 159 * self.scale, 0, self.scale, self.scale, 32, 7)
            love.graphics.draw(pages[2].arrow, x + 95 * self.scale, y + 126 * self.scale, 0, self.scale, self.scale, 15, 7)

            if love.keyboard.isDown(controls.select) then
                love.graphics.setBlendMode('add')
                love.graphics.setColor(1, 1, 1, 0.3)
                love.graphics.draw(menus.button, x + 96 * self.scale, y + 159 * self.scale, 0, self.scale, self.scale, 32, 7)
                love.graphics.setBlendMode('alpha')
            end

            love.graphics.setFont(BIG_WONDER)
            love.graphics.setColor(0, 0, 0, self.scale / 3)
            if self.grid.quarantine.level < 4 then
                love.graphics.printf('upgrade\n$' .. menus.quarantine.upgradePrice, x + 64 * self.scale,
                    y + 154 * self.scale, 192, 'center')
            else
                love.graphics.printf('maxed\nout', x + 77 * self.scale, y + 154 * self.scale, 112, 'center')
            end

            textbox(x + 48 * self.scale, y + 178 * self.scale, 95, 32, self.scale)

            love.graphics.setColor(0, 0, 0, self.scale^2 / 9)
            love.graphics.printf('increase the quarantine\'s max capacity',
                x + 38 * self.scale, y + 183 * self.scale, 350, 'center')

            love.graphics.setColor(1, 1, 1, 1)

        end

        love.graphics.draw(menus['quarantine'].page, self.pgTurn:getCurrentFrame(),
            x + 276 * self.scale / 3, y + 393 * self.scale / 3, 0, self.scale, self.scale, 61, 87)

        if self.selectedItem == 1 or self.state == 'turn' then
            if self.pgTurn.currentFrame < 4 then
                love.graphics.setColor(0, 0, 0, self.scale / 3)
                love.graphics.setFont(HUGE_WONDER)
                love.graphics.print(pages[1].header, x + 200 * self.scale / 3, y + 240 * self.scale / 3)
            end
                love.graphics.setColor(1, 1, 1, 1)

            for i, person in pairs(self.grid.quarantine.people) do
                local personX = x + 160 * self.scale / 3
                local personY = y + (312 + math.floor((i - 1) * 372 / capacity)) * self.scale / 3

                if self.state == 'turn' and personY > y + 810 - (150 * self.pgTurn.currentFrame) then
                    break
                end

                love.graphics.draw(person.texture, person.animations['idle'][3]:getCurrentFrame(),
                    personX, personY, 0, self.scale, self.scale, 10, 10)

                love.graphics.setColor(0.01, 1, 0, 1)
                love.graphics.rectangle('fill', personX + 51 * self.scale / 3, personY - 15,
                    (66 * person.Qtimer / 123) * self.scale, 10 * self.scale)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(pages[1].bar, personX + 150 * self.scale / 3, personY, 0, self.scale, self.scale, 34, 6)
            end

            for i = #self.grid.quarantine.people + 1, capacity do
                local personX = x + 160 * self.scale / 3
                local personY = y + (312 + math.floor((i - 1) * 372 / capacity)) * self.scale / 3

                if self.state == 'turn' and personY > y + 810 - (150 * self.pgTurn.currentFrame) then
                    break
                end

                love.graphics.setColor(0, 0, 0, 0.7)
                love.graphics.draw(pages[1]["generic person"], personX, personY, 0, self.scale, self.scale, 10, 10)
                love.graphics.setColor(0.5, 0.5, 0.5, 1)
                love.graphics.rectangle('fill', personX + 51 * self.scale / 3,
                    personY - 15 * self.scale / 3, 66 * self.scale, 10 * self.scale)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(pages[1].bar, personX + 150 * self.scale / 3, personY, 0, self.scale, self.scale, 34, 6)
            end
        end
    elseif self.type == 'med lab' then
        textbox(x + 8 * self.scale, y + 165 * self.scale, 184, 36, self.scale)

        local option = menus[self.type].options[self.selectedItem]
        love.graphics.draw(option.icon, x + option.x * self.scale, y + option.y * self.scale, 0, self.scale, self.scale)

        if love.keyboard.isDown(controls.select) then
            love.graphics.setBlendMode('add')
            love.graphics.setColor(1, 1, 1, 0.3)
            love.graphics.draw(option.icon, x + option.x * self.scale, y + option.y * self.scale, 0, self.scale, self.scale)
            love.graphics.setBlendMode('alpha')
        end

        love.graphics.setColor(0, 0, 0, self.scale^2 / 9)
        love.graphics.setFont(BIG_WONDER)
        love.graphics.print(option.title .. '  --', math.floor(WINDOW_WIDTH / 2) - (#option.title + 7) * 8, y + 169 * self.scale)

        love.graphics.setFont(MED_WONDER)
        love.graphics.printf(option['C description'] .. option['V description'], x + 10 * self.scale,
            y + 180 * self.scale, 540, 'center')

        love.graphics.setFont(BIG_WONDER)
        if option.price ~= 'maxed out' and option.price < items[1].amount then
            love.graphics.setColor(0, 0.4, 0.1, self.scale / 3)
        else
            love.graphics.setColor(0.8, 0, 0, self.scale/ 3)
        end
        love.graphics.print((option.price ~= 'maxed out' and '$' or '') .. option.price, 
            math.floor(WINDOW_WIDTH / 2) + (#option.title - 3) * 12, y + 169 * self.scale)

        if self.state == 'census' then
            local cScale = self.census.scale * self.scale
            local cX = math.floor(WINDOW_WIDTH / 2) - (menus[self.type].censusWidth * cScale / 2)
            local cY = math.floor(WINDOW_HEIGHT / 2) - (menus[self.type].censusHeight * cScale / 2)

            love.graphics.setColor(0, 0, 0, 0.8)
            love.graphics.rectangle('fill', x, y, self.rWidth, self.rHeight)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(menus[self.type].census, cX, cY, 0, cScale, cScale)

            love.graphics.setColor(0, 0, 0, cScale / 3)
            love.graphics.setFont(HUGE_WONDER)

            for i, stat in pairs(self.census.stats) do
                love.graphics.printf(stat.name .. ': ' .. stat.num, cX + 32 * cScale,
                    cY + (48 + 22 * i) * cScale, (menus[self.type].censusWidth - 52) * cScale)
            end
        end

    elseif self.type == 'welcome sign' then
        local usable = Timer - menus[self.type].cooldownStart > menus[self.type].cooldown
        love.graphics.setFont(HUGE_WONDER)
        love.graphics.setColor(1, 0.925, 0.235, self.scale / 3)

        love.graphics.printf('let someone in?', x + 1 * self.scale, y + 81 * self.scale, self.rWidth, 'center')

        for i, option in pairs(menus[self.type].options) do

            love.graphics.setColor(1, 1, 1, 1)
            if self.selectedItem == i and usable then
                love.graphics.draw(menus['button highlight'], x + (i == 1 and 32 or 242) * self.scale / 3,
                    y + 102 * self.scale, 0, self.scale, self.scale)
            end
            
            love.graphics.rectangle('fill', x + (i == 1 and 16 or 86) * self.scale + 1, y + 106 * self.scale,
                60 * self.scale - 1, 16 * self.scale)

            love.graphics.setColor(1, 0.925, 0.235, self.scale / 3)
            love.graphics.draw(menus.button, x + (i == 1 and 15 or 85) * self.scale,
                y + 105 * self.scale, 0, self.scale, self.scale)

            love.graphics.setColor(0, 0, 0, self.scale / 3)
            love.graphics.print(option, x + (i == 1 and 35 or 108) * self.scale, y + 109 * self.scale)
        end

        if not usable then
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle('fill', x + 8 * self.scale - 1, y + 72 * self.scale, 146 * self.scale + 2,
                67 * self.scale, 38)
        end
    elseif self.type == 'main' then
        love.graphics.draw(menus.main.background(), x, y, 0, self.scale, self.scale)
        love.graphics.setColor(0, 0, 0, 1 - self.dim)
        love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(menus.main.viruses, x, y, 0, self.scale, self.scale)

        love.graphics.draw(menus.main.SDM, x + self.rWidth - 82 * self.scale,
            y + self.rHeight - 96 * self.scale, 0, self.scale, self.scale, 75, 85)

        love.graphics.draw(menus.main.title, x + math.floor(menus.main.width() / 2) * self.scale,
            y + 61 * self.scale, 0, self.scale, self.scale, 88, 53)
        
        love.graphics.setColor(0, 0, 0, self.scale / 6)
        local width = #menus.main.options[self.selectedItem] * 24 + 80
        love.graphics.draw(menus['button highlight'], math.floor(self.rWidth / 2) - math.floor(width / 2) - 5, 
            ((love.window.getFullscreen() and 119 or 107) + self.selectedItem * 21) * self.scale, 0, width / 70 * self.scale / 3, self.scale)

        love.graphics.setColor(1, 0.93, 0.1, self.scale / 3)
        love.graphics.setFont(HUGE_WONDER)
        for i, option in pairs(menus.main.options) do
            love.graphics.printf(option, 0, ((love.window.getFullscreen() and 126 or 114) + i * 21) * self.scale,
                self.rWidth, 'center')
        end

        love.graphics.setFont(BIG_WONDER)
        love.graphics.print('a game by rex demuro', x + self.rWidth - 119 * self.scale, y + self.rHeight - 10 * self.scale)
        love.graphics.setColor(0, 0, 0, self.scale / 3)
        love.graphics.print('use', x + 30 * self.scale, y + self.rHeight - 31 * self.scale)
        love.graphics.print('to select', 12 * self.scale, self.rHeight - 9 * self.scale) 
        drawKey(x + 17 * self.scale, self.rHeight - 27 * self.scale, controls.up, self.scale / 3)
        drawKey(x + 7 * self.scale, self.rHeight - 19 * self.scale, controls.left, self.scale / 3)
        drawKey(x + 17 * self.scale, self.rHeight - 19 * self.scale, controls.down, self.scale / 3)
        drawKey(x + 27 * self.scale, self.rHeight - 19 * self.scale, controls.right, self.scale / 3)
        drawKey(x + 39 * self.scale, self.rHeight - 22 * self.scale, controls.select, self.scale / 3)

        drawKey(80 * self.scale, self.rHeight - 18 * self.scale, controls.fullscreen, self.scale / 3)
        love.graphics.print('fullscreen', 72 * self.scale, self.rHeight - 9 * self.scale)

        if self.menu then self.menu:render() end
    elseif self.type == 'pause' then
        love.graphics.setFont(HUGE_WONDER)
        love.graphics.setColor(0, 0, 0, self.scale / 3)
        love.graphics.printf(self.pauseState, x, y + (self.pauseState == 'paused' and 6 or 3) * self.scale, 
            menus[self.type].width * self.scale, 'center')

        for i, option in pairs(menus[self.type].options[self.pauseState]) do
            love.graphics.setColor(1, 1, 1, 1)
            if self.selectedItem == i then
                love.graphics.draw(menus['button highlight'], x + (2 + 70 * (i - 1)) * self.scale, 
                    y + 25 * self.scale, 0, self.scale, self.scale)
            end
            love.graphics.setColor(self.selectedItem == i and 0.3 or 0.2, self.selectedItem == i and 0.6 or 0.5, 1, 1)

            love.graphics.draw(menus.button, x + (6 + 70 * (i - 1)) * self.scale, 
                y + 28 * self.scale, 0, self.scale, self.scale)

            love.graphics.setColor(1, 1, 1, self.scale^2 / 9)
            love.graphics.printf(option, x + (6 + 70 * (i - 1)) * self.scale, y + 32 * self.scale, 63 * self.scale, 'center')
        end

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(menus[self.type].zzz, x + 125 * self.scale, y + 27 * self.scale, 0, self.scale, self.scale)
    elseif self.type == 'game over' then

        love.graphics.draw(menus['button highlight'], x + (6 + 78 * (self.selectedItem - 1)) * self.scale,
            y + 29 * self.scale, 0, self.scale, self.scale)
        for i, option in pairs(menus[self.type].options) do
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle('fill', x + (11 + 78 * (i - 1)) * self.scale, y + 33 * self.scale, 120, 30)
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.draw(menus.button, x + (10 + 78 * (i - 1)) * self.scale, y + 32 * self.scale,
                0, self.scale, self.scale)

            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.setFont(HUGE_WONDER)
            love.graphics.printf(option, x + (10 + 78 * (i - 1)) * self.scale, y + 36 * self.scale, 62 * self.scale, 'center')
        end

        love.graphics.setColor(0, 0, 0, self.scale / 3)
        love.graphics.setFont(BIG_WONDER)
        if grid.score < highScore then
            love.graphics.printf('score: ' .. math.floor(grid.score) .. '\thigh score: ' .. highScore,
                x, y + 22 * self.scale, self.rWidth, 'center')
        else
            love.graphics.printf('new high score! ' .. math.floor(grid.score),
                x, y + 22 * self.scale, self.rWidth, 'center')
        end
    elseif self.type == 'options' then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(MED_WONDER)
        love.graphics.printf('select an action and hit the key you\'d like to remap it to', x, y + 28 * self.scale, self.rWidth, 'center')

        for i, option in pairs(menus[self.type].options) do
            if i < 16 then
                if self.selectedItem == i then
                    love.graphics.setColor(1, 1, 1, self.scale / 3)
                else
                    love.graphics.setColor(0, 0, 0, self.scale / 3)
                end

                love.graphics.setFont(MED_WONDER)
                love.graphics.printf(option .. ':', x + (i > 8 and 71 or 1) * self.scale,
                    y + ((i > 8 and -110 or 100) + i * (i > 8 and 26 or 23)) * self.scale / 3, 43 * self.scale, 'right')

                if not (self.selectedItem == i and self.state == 'input') then
                    drawKey(x + (i > 8 and 121 or 51) * self.scale, y + (i > 8 and -39 or 31) * self.scale
                        + i * (i > 8 and 26 or 23) * self.scale / 3, self.tempControls[i], self.scale / 3)
                end
            else
                love.graphics.setColor(1, 1, 1, self.scale / 3)
                if self.selectedItem == i then
                    love.graphics.draw(menus['button highlight'], x + 67 + (i - 16) * 135, y + 326, 0, self.scale * 2/3, self.scale * 3 / 4, 32, 10)
                end
                love.graphics.rectangle('fill', x + (4 + (i - 16) * 45) * self.scale, y + 104 * self.scale, 27 * self.scale, 10 * self.scale)
                love.graphics.setColor(0.7, 0.7, 0.7, self.scale / 3)
                love.graphics.draw(menus.button, x + (24 + (i - 16) * 45) * self.scale, y + 110 * self.scale,
                    0, self.scale * 2/3, self.scale * 3 / 4, 31, 9)

                love.graphics.setColor(0, 0, 0, self.scale / 3)
                love.graphics.printf(option, x + (4 + (i - 16) * 45) * self.scale, y + (i == 17 and 107 or 105) * self.scale, 124, 'center')
            end
        end
    end

    if self.state == 'fade out' then
        love.graphics.setColor(0, 0, 0, self.fade)
        love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    end
end