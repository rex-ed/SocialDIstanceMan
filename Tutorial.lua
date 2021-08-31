Tutorial = Class()

function Tutorial:init()
    grid = Grid(16, 10, 60)

    self.popups = {
        {text = 'oh, social distance man!'},
        {text = 'welcome to petri park, you\'re right on time!'},
        {text = 'we\'ve just gotten word of a viral outbeak in the area, and just before peak visiting hours no less!'},
        {text = 'pretty soon there will be visitors flooding the park, and we knew that you are just the person to help keep them safe.'},
        {text = 'first, let\'s get you aquainted with the area.\n use ' .. controls.up .. ' ' .. controls.left .. ' ' .. controls.down .. ' ' .. controls.right .. ' to move around',
            trigger = function() return self.keyPressed == controls.up or self.keyPressed == controls.left or self.keyPressed == controls.down or self.keyPressed == controls.right end},
        {text = 'once you\'re comfortable, we\'ll let in a practice visitor just to let you get warmed up.'},
        {text = 'okay, here they come!',
            event = function() self.person = Person(grid, 1) table.insert(grid.things, self.person) self.person.carrier = false end},
        {text = 'once the park is fully open, there will be a bunch of visitors walking around all over the place, so there are a few things you should know about them.'},
        {text = 'each vsitor walking around the park adds points to your overall score, and as part of their park fee pays you $' .. grid.income .. ' every ' .. grid.incomeRate .. ' seconds.',
            arrows = {{125, 40, 0}, {function() return WINDOW_WIDTH / 2 - 60 end, function() return 60 end, math.pi/2}}},
        {text = 'because of this crazy new virus that\'s going around, anyone that visits today has a chance to be infected!'},
        {text = 'anyone carrying the virus can transmit it to other visitors in the park, and so it\'s your job to make sure this crisis stays under control.'},
        {text = 'if every visitor in the park has the virus, we\'ve got to shut down for the day, and we can\'t have that now can we?'},
        {text = 'so, how do you know if someone is infected? well, normally after a few seconds anyone who has the virus will get sick. when that happens they start flashing red like this.',
            arrows = {{function() return math.floor(self.person.x - 20) end, function() return math.floor(self.person.y - 60) end, math.pi}},
            event = function() self.person.sick = true end},
        {text = 'but, in rare cases, they can be silent carriers, which means that they can still pass along the virus, but they won\'t flash red.',
            event = function() self.person.sick = false end},
        {text = 'so you should always be wary of everyone in the park.'},
        {text = 'now that you know how the virus effects the visitors, lets see how you can help prevent it!'},
        {text = 'walk up to a visitor and hit enter to select them.',
            trigger = function() return self.person.selected end},
        {text = 'great! see those highlighted tiles that appear around the selected visitor? that is their \'infection range\'.'},
        {text = 'an infected person can pass the virus to any other visitor who steps into their infection range.'},
        {text = 'this means that the easiest way to keep the virus from spreading is to keep them away from each other!'},
        {text = 'by hitting enter while you have a visitor selected, you can turn them around and have them face in the opposite direction.'},
        {text = 'that\'s it! now to stop selecting them you simply walk away, and they will keep going in the direction you turned them.',
            trigger = function() return not self.person.selected end},
        {text = 'now, keeping the visitors separated might be the simplest way to keep the virus from spreading, but it is far from the only way.'},
        {text = 'when you\'ve got a person selected, you can either turn them around, give them an item you bought from the shop, or send them to the quarantine.'},
        {text = 'how about we try buying and using an item? first, walk up to the shop and select it.',
            event = function() self.freezeMenu = false end,
            trigger = function() return grid.menu and grid.menu.type == 'shop' end},
        {text = 'now that you\'re in the shop, you can use the money you get from visitors to purchase items that will protect them.'},
        {text = 'why don\'t you buy a mask. navigate over to the mask icon and hit enter to buy it.',
            arrows = {{function() return WINDOW_WIDTH / 2 - 141 end, function() return WINDOW_HEIGHT / 2 + 73 end, 0}},
            event = function() self.freezeMenu = false end,
            trigger = function() return items[5].amount > 0 end},
        {text = 'ok, now hit shift to exit the menu and then go select the practice visitor.',
            event = function() self.freezeMenu = false end,
            trigger = function() return self.person.selected end},
        {text = 'now, see how up next to the mask icon that just showed up there is a computer key? hit that key on your keyboard to give the visitor the mask.',
            arrows = {{100, 90, 0}},
            trigger = function() return self.person:isWearing('mask') end},
        {text = 'nice! see how their infection range got smaller, just like the shop description said? now it will be harder for this visitor to infect others.'},
        {text = 'so, now you know how to turn people around and give them items, the last thing you\'ll need to know about visitors is how to quarantine them.'},
        {text = 'when a person is selected, a similar key icon will appear on the quarantine. hit that key and the selected visitor will be sent there.',
            arrows = {{function() return WINDOW_WIDTH / 2 - 425 end, function() return WINDOW_HEIGHT / 2 + 66 end, 0}},
            trigger = function() return self.person.state == 'quarantine' end},
        {text = 'when a visitor is in quarantine, they are not able to infect anyone else, but they don\'t count towards your score or income.'},
        {text = 'they will stay in quarantine for two minutes and then be let out the back and asked to leave the park.'},
        {text = 'be aware though, no one wants to be in quarantine, so some visitors might try to escape like this.'},
        {text = 'when this happens there is a short period of time during which you can send them back to resume their quarantine. if you miss this window, however, they will have to start their two minutes over.',
            event = function() self.person.Qstate = 'exiting' end, trigger = function() return self.person.state == 'quarantine' end},
        {text = 'at its base level, the quarantine can only hold three patients at once, but by selecting the quarantine itself you will find a menu in which you can upgrade that.'},
        {text = 'on that note, why don\'t you spend some time getting aquanted with all of the buildings surrounding the park.'},
        {text = '',
            event = function() self.popups[self.position].text = self.buildingsVisited == 1 and
                    'selecting any of them will bring up a menu in which you can make some useful purchases and upgrades.'
                    or 'why don\'t you check out the rest of the buildings?'
                if self.buildingsVisited % 2 == 0 and self.buildingsVisited % 3 == 0 and self.buildingsVisited % 5 == 0 then
                    self.position = self.position + 5 end self.freezeMenu = false end,
            trigger = function()
                if grid.menu then
                    if grid.menu.type == 'shop' then
                        return true
                    elseif grid.menu.type == 'bank' then
                        self.buildingsVisited = self.buildingsVisited * 2
                        self.position = self.position + 1
                        return true
                    elseif grid.menu.type == 'quarantine' then
                        self.buildingsVisited = self.buildingsVisited * 3
                        self.position = self.position + 2
                        return true
                    elseif grid.menu.type == 'med lab' then
                        self.buildingsVisited = self.buildingsVisited * 5
                        self.position = self.position + 3
                        return true
                    else
                        return false
                    end
                end
            end},
        {text = 'this is the shop! here you can buy items for the visitors that can reduce their infection range or push away other visitors.',
            event = function() self.freezeMenu = false end,
            trigger = function() if not grid.menu then self.position = self.position - 2 return true else return false end end},
        {text = 'this is the bank! here you can upgrade the amount of money each person gives you, and how often they do so.',
            event = function() self.freezeMenu = false end,
            trigger = function() if not grid.menu then self.position = self.position - 3 return true else return false end end},
        {text = 'this is the quarantine! here you can see how much time each patient has left in their stay, and upgrade the quarantine\'s capacity.',
            event = function() self.freezeMenu = false end,
            trigger = function() if not grid.menu then self.position = self.position - 4 return true else return false end end},
        {text = 'this is the med lab! here you can purchase tests to see if visitors are silent carriers.',
            event = function() self.freezeMenu = false end,
            trigger = function() if not grid.menu then self.position = self.position - 5 return true else return false end end},
        {text = 'wonderful! now that you have visited all of petri park\'s fine establishments, you are just about ready to go!'},
        {text = 'but there is one more thing you should know. . .'},
        {text = 'i trust that you are here solely to protect the safety of our visitors, but if you were just looking to make a quick buck. . .'},
        {text = 'if you walk up to the edge of the park and hit enter you can let another visitor into the park. of course, more visitors means higher risk of spread, but it will rake in the points quicker.',
            event = function() self.freezeMenu = false end,
            trigger = function() return grid.menu and grid.menu.type == 'welcome sign' end},
        {text = 'just don\'t tell the boss that i told you about this.',
            event = function() self.freezeMenu = false end,
            trigger = function() return not grid.menu end},
        {text = 'well, peak visiting hours are coming up and that\'s just about everything i\'ve got to tell you!'},
        {text = 'good luck out there social distance man!'},
        {text = '',
            event = function() self.fadeOut = 0 end}
    }

    self.position = 1
    self.keyPressed = nil
    self.textLength = 0
    self.textTime = 0
    self.textSpeed = 0.075
    items[1].amount = 1000
    self.buildingsVisited = 1
    self.fadeOut = nil
    self.freezeMenu = true
    self.arrow = love.graphics.newImage('objects/tilted arrow.png')
    self.person = {y = 500}
end

function Tutorial:update(dt)
    if self.textLength < #self.popups[self.position].text then
        self.textTime = self.textTime + dt
        if love.keyboard.isDown(controls.back) then self.textSpeed = self.textSpeed / 3 end
        if self.textTime > self.textSpeed then
            self.textTime = 0
            if string.sub(self.popups[self.position].text, self.textLength + 1, self.textLength + 1) == ' ' then
                self.textLength = self.textLength + 2
            else
                self.textLength = self.textLength + 1
            end

            if string.match(string.sub(self.popups[self.position].text, self.textLength, self.textLength), '[!.?]') then
                self.textSpeed = 0.75
            elseif string.match(string.sub(self.popups[self.position].text, self.textLength, self.textLength), ',') then
                self.textSpeed = 0.4
            else
                self.textSpeed = 0.075
            end
        end
    elseif (self.popups[self.position].trigger and self.popups[self.position].trigger()) or
        (not self.popups[self.position].trigger and self.keyPressed == controls.select) then

        if self.popups[self.position + 1] then
            self.position = self.position + 1
            self.freezeMenu = true
        
            self.textLength = 0

            if self.popups[self.position].event then
                self.popups[self.position].event()
            end
        end
    end

    if self.fadeOut then
        self.fadeOut = self.fadeOut + 0.02

        if self.fadeOut > 1 then
            grid = nil
            tutorial = nil
            keyMenu = Menu(nil, 'main')
        end
    end
    
    self.keyPressed = nil
end

function Tutorial:render()
    local y = ((grid.menu and not love.window.getFullscreen()) and 50 or WINDOW_HEIGHT - 96)
    local lines = math.floor(self.textLength * 17.5 / 830)
    
    textbox(WINDOW_WIDTH / 2 - 411, y - 20 - math.floor(lines * 10.5), 274, lines * 7 + 20, 3, 
        (((self.person.y > y - 20 - math.floor(lines * 10.5) and self.person.state ~= 'quarantine')
            or grid.player.y > y - 20 - math.floor(lines * 10.5))
            and not grid.menu) and 0.4 or 0.9)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(BIG_WONDER)

    love.graphics.printf(string.sub(self.popups[self.position].text, 1, self.textLength), WINDOW_WIDTH / 2 - 390, y - (lines * 8.5), 782, 'center')
    if not self.popups[self.position].trigger and self.textLength >= #self.popups[self.position].text then
        drawKey(WINDOW_WIDTH / 2 + 417, y + 18 + lines * 7, controls.select)
    end

    love.graphics.setColor(1, 1, 1, 1)
    if self.popups[self.position].arrows then
        for _, arrow in pairs(self.popups[self.position].arrows) do
            if type(arrow[1]) == 'function' then
                love.graphics.draw(self.arrow, arrow[1](), arrow[2](), arrow[3], 3, 3)
            else
                love.graphics.draw(self.arrow, arrow[1], arrow[2], arrow[3], 3, 3)
            end
        end
    end

    if self.fadeOut then
        love.graphics.setColor(0, 0, 0, self.fadeOut)
        love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    end
end