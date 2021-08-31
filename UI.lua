UI = Class()

function UI:init(grid)
    self.grid = grid

    for _, item in pairs(items) do
        item.amount = 0
    end
    self:BuildingFlag(self.grid.quarantine, #self.grid.quarantine.people .. ' / ' .. self.grid.quarantine.level + 2)
end

function UI:update()
    for _, item in pairs(items) do
        if item.purchaseEffect then
            item.purchaseEffectX = item.purchaseEffectX + 1

            if item.purchaseEffectX > 120 then
                item.purchaseEffectAlpha = item.purchaseEffectAlpha - 0.02
            else
                item.purchaseEffectAlpha = item.purchaseEffectAlpha + 0.06
            end

            if item.purchaseEffectAlpha < 0 then
                item.purchaseEffect = false
            end
        end

        local i = item.usedEffect
        if i then
            i.x = i.x + i.pX / 20
            i.a = (i.pX * i.mY - i.pY) / ((i.mX^2 * i.pX) - (i.pX^2 * i.mX))
            i.b = (i.pY - (i.a * i.pX^2)) / i.pX
            i.y = (i.a * i.x^2) + (i.b * i.x)

            if math.abs(i.x - i.pX) < 2 then
                table.insert(i.person.items, _, Item(_, i.person))
                item.usedEffect = nil
            end
        end
    end

    if self.buildingFlag then
        local flag = self.buildingFlag
        if flag.state == 'fall' then
            flag.y = flag.y + 10
            flag.Ssize = flag.Ssize + 0.1

            if flag.alpha < 1 then
                flag.alpha = flag.alpha + 0.2
            end

            if flag.y > flag.building.y - (flag.building.height) + 8 * math.sin(Timer * 2.5) then
                flag.state = 'bob'
            end
        elseif flag.state == 'bob' then
            flag.y = flag.building.y - (flag.building.height) + 8 * math.sin(Timer * 2.5)

            flag.Ssize = 1 / 5 * math.sin(Timer * 2.5) + 1
        end
    end
end

function UI:purchase(item, amount)
    item.purchaseEffect = amount
    item.purchaseEffectX = 100
    item.purchaseEffectAlpha = 0
end

function UI:itemUsed(item, x, y, person)
    item.usedEffect = {}
    item.usedEffect.startX = x + (x == person.x and 2 or 0)
    item.usedEffect.startY = y - 30
    item.usedEffect.pX = person.x - x
    item.usedEffect.pY = person.y - y
    item.usedEffect.mX = (item.usedEffect.pX / 2)
    item.usedEffect.mY = item.usedEffect.pY > 0 and -20 or item.usedEffect.pY - 20
    item.usedEffect.person = person
    item.usedEffect.x = 0
    item.usedEffect.y = 0
end


function UI:BuildingFlag(building, text)
    self.buildingFlag = {}
    local flag = self.buildingFlag
    flag.texture = love.graphics.newImage('objects/flag.png')

    flag.edge = love.graphics.newQuad(0, 0, 2, 7, flag.texture:getDimensions())
    flag.body = love.graphics.newQuad(3, 0, 15, 8, flag.texture:getDimensions())
    flag.point = love.graphics.newQuad(19, 2, 5, 4, flag.texture:getDimensions())

    flag.shadow = love.graphics.newImage('objects/shadow.png')
    flag.building = building

    flag.text = text or flag.building.type
    flag.x = math.floor(flag.building.x + flag.building.width / 2)
    flag.y = flag.building.y - (flag.building.height) - 100
    flag.alpha = 0

    flag.boxWidth = #flag.text * 12 + 4
    flag.Ssize = 0

    flag.state = 'fall'
end

function UI:render()
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.rectangle('fill', WINDOW_WIDTH / 2 - 85, -10, 170, 95, 10)

    love.graphics.setFont(BIG_WONDER)
    love.graphics.setColor(1, 0.925, 0.235, 1)
    love.graphics.printf('score\n' .. math.floor(self.grid.score), 0, 5, WINDOW_WIDTH, 'center')
    love.graphics.setFont(MED_WONDER)
    love.graphics.printf("high score\n" .. highScore, 0, 50, WINDOW_WIDTH, 'center')

    love.graphics.print('pause', WINDOW_WIDTH - 68, WINDOW_HEIGHT - 20)
    love.graphics.print('fullscreen', 6, WINDOW_HEIGHT - 20)
    drawKey(WINDOW_WIDTH - 67, WINDOW_HEIGHT - 47, controls.pause)
    drawKey(28, WINDOW_HEIGHT - 47, controls.fullscreen)



    local height = 0
    for _, item in pairs(items) do
        if item.amount > 0 or item.type == 'money' or item.purchaseEffect then
            height = height + item.height * 2 + 6
        end
    end

    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle('fill', -10, 0, 150, height + 10, 10, 10)

    local y = 0
    for id, item in pairs(items) do
        if item.amount > 0 or item.type == 'money' or item.purchaseEffect then
            love.graphics.setFont(MED_WONDER)
            love.graphics.setColor(1, 1, 1, (item.amount == 0 and item.type ~= 'money') and item.purchaseEffectAlpha or 1)

            y = y + 6
            love.graphics.draw(item.icon, 44, y, 0, 2, 2, item.width / 2, 0)

            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.printf(item.amount, 84, y + item.height / 2, 60, 'center')

            if item.purchaseEffect then
                love.graphics.setFont(BIG_WONDER)
                love.graphics.setColor(item.purchaseEffect >= 0 and 0 or 1, item.purchaseEffect >= 0 and 1 or 0, 0, item.purchaseEffectAlpha)
                love.graphics.print((item.purchaseEffect > 0 and '+' or '') .. item.purchaseEffect,
                    item.purchaseEffectX, y + item.height / 2 - 4)
            end

            if item.usedEffect then
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(item.icon, item.usedEffect.x + item.usedEffect.startX,
                    item.usedEffect.y + item.usedEffect.startY, 0, 2, 2, item.width / 2, item.height / 2)
            end

            if self.grid.player.selectedPerson and item.type ~= "money" then
                if self.grid.player.selectedPerson:isWearing(item.type) or (item.type ~= "test" and 
                    self.grid.player.selectedPerson:isWearing(items[id + (id % 2 == 0 and 1 or -1)].type)) then
                    drawKey(72, y - 3, controls.items[id], 0.2)
                else
                    drawKey(72, y - 3, controls.items[id])
                end
            end

            y = y + item.height * 2
        end
    end

    if self.grid.player.selectedPerson then
        textbox(self.grid.quarantine.x + 40, self.grid.quarantine.ry + 9, 22, 7, 3)
 
        if #self.grid.quarantine.people < self.grid.quarantine.level + 2 then
            drawKey(self.grid.quarantine.x + 112, self.grid.quarantine.ry + 9, controls.quarantine)
            love.graphics.setColor(0, 0, 0, 1)
        else
            drawKey(self.grid.quarantine.x + 112, self.grid.quarantine.ry + 9, controls.quarantine, 0.2)
            love.graphics.setColor(1, 0, 0, 1)
        end

        love.graphics.printf(#self.grid.quarantine.people .. ' / ' .. self.grid.quarantine.level + 2, 
            self.grid.quarantine.x + 40, self.grid.quarantine.ry + 14, 70, 'center')
    end

    if self.buildingFlag then
        local flag = self.buildingFlag
        love.graphics.setColor(1, 1, 1, flag.alpha)
        love.graphics.draw(flag.shadow, flag.x, flag.building.y - flag.building.height + (flag.text ~= 'bank' and 45 or 30),
            0, flag.Ssize * 1.5, flag.Ssize * 1.5, 12)
        love.graphics.draw(flag.texture, flag.body, flag.x - math.floor(flag.boxWidth / 2), math.floor(flag.y), 
            0, flag.boxWidth / 15, 3)
        love.graphics.draw(flag.texture, flag.edge, flag.x - math.floor(flag.boxWidth / 2 + 6), math.floor(flag.y), 0, 3, 3)
        love.graphics.draw(flag.texture, flag.edge, flag.x + math.floor(flag.boxWidth / 2 + 6), math.floor(flag.y), 0, -3, 3)
        love.graphics.draw(flag.texture, flag.point, flag.x - 9, math.floor(flag.y) + 18, 0, 3, 3)

        love.graphics.setFont(MED_WONDER)
        love.graphics.setColor(0, 0, 0, flag.alpha)
        love.graphics.printf(flag.text, flag.x - math.floor(flag.boxWidth / 2), math.floor(flag.y) + 5, flag.boxWidth, "center")
    end
end