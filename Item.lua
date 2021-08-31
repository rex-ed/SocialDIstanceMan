Item = Class{}

for _, item in pairs(items) do
    if item.type ~= 'money' then
        item.texture = love.graphics.newImage('objects/' .. item.type .. '.png')
    end

    if item.type == 'mask' then
        item.animations = {
            Animation ({
                texture = item.texture,

                frames = {love.graphics.newQuad(7, 0, 7, 4, item.texture:getDimensions())}
            }),
            Animation ({
                texture = item.texture,

                frames = {love.graphics.newQuad(14, 0, 7, 4, item.texture:getDimensions())}
            }),
            Animation ({
                texture = item.texture,

                frames = {love.graphics.newQuad(0, 0, 7, 4, item.texture:getDimensions())}
            }),
            Animation ({
                texture = item.texture,

                frames = {love.graphics.newQuad(21, 0, 7, 4, item.texture:getDimensions())}
            })
        }
    elseif item.type == 'rod' then
        item.animations = {
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(58, 0, 5, 41, item.texture:getDimensions()),
                    love.graphics.newQuad(49, 0, 5, 41, item.texture:getDimensions()),
                    love.graphics.newQuad(54, 0, 4, 41, item.texture:getDimensions()),
                    love.graphics.newQuad(49, 0, 5, 41, item.texture:getDimensions())
                }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(0, 4, 44, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 0, 44, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 8, 44, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 0, 44, 4, item.texture:getDimensions()),
                }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(44, 0, 5, 41, item.texture:getDimensions()),
                    love.graphics.newQuad(44, 0, 5, 41, item.texture:getDimensions()),
                    love.graphics.newQuad(44, 0, 5, 41, item.texture:getDimensions()),
                    love.graphics.newQuad(44, 0, 5, 41, item.texture:getDimensions()),

            }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(0, 16, 44, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 12, 44, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 20, 44, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 12, 44, 4, item.texture:getDimensions()),
                }
            })
        }
    elseif item.type == 'sheild' then
        item.animations = {
            Animation ({
                texture = item.texture,

                frames = {love.graphics.newQuad(1, 7, 8, 6, item.texture:getDimensions())}
            }),
            Animation ({
                texture = item.texture,

                frames = {love.graphics.newQuad(0, 12, 9, 6, item.texture:getDimensions())}
            }),
            Animation ({
                texture = item.texture,

                frames = {love.graphics.newQuad(1, 0, 8, 6, item.texture:getDimensions())}
            }),
            Animation ({
                texture = item.texture,

                frames = {love.graphics.newQuad(0, 19, 9, 6, item.texture:getDimensions())}
            })
        }
    elseif item.type == 'tube' then
        item.animations = {
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(31, 12, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 12, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(62, 12, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 12, 31, 12, item.texture:getDimensions()),
                }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(31, 24, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 24, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(62, 24, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 24, 31, 12, item.texture:getDimensions()),
                }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(31, 0, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 0, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(31, 0, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 0, 31, 12, item.texture:getDimensions()),
                }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(31, 36, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 36, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(62, 36, 31, 12, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 36, 31, 12, item.texture:getDimensions()),
                }
            })
        }
    elseif item.type == 'gloves' then
        item.animations = {
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(20, 3, 20, 3, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 3, 20, 3, item.texture:getDimensions()),
                    love.graphics.newQuad(40, 3, 20, 3, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 3, 20, 3, item.texture:getDimensions()),
                }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(20, 7, 20, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 7, 20, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(40, 7, 20, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 7, 20, 4, item.texture:getDimensions()),
                }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(20, 0, 20, 3, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 0, 20, 3, item.texture:getDimensions()),
                    love.graphics.newQuad(40, 0, 20, 3, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 0, 20, 3, item.texture:getDimensions()),
                }
            }),
            Animation ({
                texture = item.texture,

                frames = {
                    love.graphics.newQuad(20, 12, 20, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 12, 20, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(40, 12, 20, 4, item.texture:getDimensions()),
                    love.graphics.newQuad(0, 12, 20, 4, item.texture:getDimensions()),
                }
            })
        }
    end
end



function Item:init(type, person)
    self.type = type
    self.typeName = items[self.type].type
    self.person = person

    if self.typeName == 'sanitizer' or self.typeName == 'test' then
        self.start = Timer

        if self.typeName == 'test' then
            self.effect = false
        end
    else
        self.animation = items[self.type].animations[self.person.direction]

        if self.typeName == 'rod' then
            self:update()
        end
    end
end

function Item:update(dt)
    if self.typeName ~= 'sanitizer' and self.typeName ~= 'test' then
        self.animation = items[self.type].animations[self.person.direction]
    end

    if self.typeName == 'rod' then
        if self.person.direction == 1 then
            self.x = self.person.x - 9
            self.y = self.person.y - 141

            self.cX = self.x - 20
            self.cY = self.y - 27

            self.cWidth = 60
            self.cHeight = 120
        elseif self.person.direction == 2 then
            self.x = self.person.x - 9
            self.y = self.person.y - 27

            self.cX = self.x + 43
            self.cY = self.y - 18

            self.cWidth = 120
            self.cHeight = 60
        elseif self.person.direction == 3 then
            self.x = self.person.x - 9
            self.y = self.person.y - 24

            self.cX = self.x - 21
            self.cY = self.y + 39

            self.cWidth = 60
            self.cHeight = 120
        else
            self.x = self.person.x - 126
            self.y = self.person.y - 27

            self.cX = self.x - 27
            self.cY = self.y - 18

            self.cWidth = 120
            self.cHeight = 60
        end

        for _, person in pairs(self.person.grid.things) do
            if person.type == 'person' and person.id ~= self.person.id and
                person.x < self.cX + self.cWidth and person.x > self.cX and
                    person.y < self.cY + self.cHeight and person.y > self.cY then

                person:push(self.person.direction)
            end
        end
    end

    if self.typeName == 'tube' then
        for _, person in pairs(self.person.grid.things) do
            if person.type == 'person' and person.id ~= self.person.id and person.state ~= 'pushing' and
                ((person.x > self.person.x - 30 and person.x < self.person.x + 30 and
                    person.y > self.person.y - 105 and person.y < self.person.y + 75) or
                        (person.x > self.person.x - 90 and person.x < self.person.x + 90 and
                            person.y > self.person.y - 45 and person.y < self.person.y + 15)) then

                person:push(self.person.direction)
            end
        end
    end

    if self.typeName == 'sanitizer' then
        if Timer > self.start + 30 then
            table.remove(self.person.items, 1)
        end
    elseif self.typeName == 'test' then
        if self.effect then
            if self.effect.y < 90 then
                self.effect.y = self.effect.y + 1
            end

            if self.effect.alpha > 0 then
                self.effect.alpha = self.effect.alpha - 0.005
            else
                table.remove(self.person.items, self.type)
            end
        elseif Timer > self.start + items[self.type].speed then
            self.effect = {
                ['y'] = 50,
                ['alpha'] = 4,
                ['result'] = self.person.carrier and '+' or '-',
            }
            if self.person.carrier then self.person.sick = true end
        end
            
    end
end

function Item:render(frame)
    frame = self.person.animation == self.person.animations['moving'][self.person.direction] and frame or 2
    if self.typeName == 'mask' then
        love.graphics.draw(items[self.type].texture, self.animation:getCurrentFrame(),
            math.floor(self.person.x - 12), math.floor(self.person.y - 45), 0, 3, 3)
    elseif self.typeName == 'rod' then
        love.graphics.draw(items[self.type].texture, self.animation.frames[frame],
            math.floor(self.x), math.floor(self.y), 0, 3, 3)
    elseif self.typeName == 'sheild' then
        love.graphics.draw(items[self.type].texture, self.animation:getCurrentFrame(),
            math.floor(self.person.x - 15), math.floor(self.person.y - 50), 0, 3, 3)
    elseif self.typeName == 'tube' then
        love.graphics.draw(items[self.type].texture, self.animation.frames[frame],
            math.floor(self.person.x - 48), math.floor(self.person.y - 33), 0, 3, 3)
    elseif self.typeName == 'gloves' then
        love.graphics.draw(items[self.type].texture, self.animation.frames[frame],
            math.floor(self.person.x - 30), math.floor(self.person.y - 27), 0, 3, 3)
    elseif self.typeName == 'sanitizer' then
        love.graphics.setColor(0, 0, 1, 1)
            local fillHeight = 12 - math.floor(12 * (Timer - self.start) / 30)
            love.graphics.rectangle('fill', math.floor(self.person.x + 18),
                math.floor(self.person.y - 48 - fillHeight), 12, fillHeight)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(items[self.type].texture, math.floor(self.person.x + 15),
                math.floor(self.person.y - 69), 0, 3, 3)
    elseif self.typeName == 'test' then
        if self.effect then
            love.graphics.setFont(HUGE_WONDER)
            love.graphics.setColor(self.effect.result == '+' and 1 or 0, 0,
                self.effect.result == '-' and 1 or 0, self.effect.alpha)
            love.graphics.print(self.effect.result, self.person.x - 12, math.floor(self.person.y - self.effect.y))
        else
            love.graphics.setColor(0, 1, 0, 1)
            local fillHeight = math.floor(18 * (Timer - self.start) / items[self.type].speed)
            love.graphics.rectangle('fill', math.floor(self.person.x + 18),
                math.floor(self.person.y - 48 - fillHeight), 12, fillHeight)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(items[self.type].texture, math.floor(self.person.x + 15),
                math.floor(self.person.y - 69), 0, 3, 3)
        end
    end
end