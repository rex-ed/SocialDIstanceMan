-- Social Distance Man!

Class = require 'class'

WINDOW_WIDTH = 1281
WINDOW_HEIGHT = 693

DIRECTIONS = {['up'] = 1, ['right'] = 2, ['down'] = 3, ['left'] = 4}

love.graphics.setDefaultFilter('nearest', 'nearest')

items = {
    { --money
        ['type'] = 'money',
        ['icon'] = love.graphics.newImage('objects/money icon.png'),
        ['width'] = 32,
        ['height'] = 23,
    },
    { -- sanitizer
        ['type'] = 'sanitizer',
        ['icon'] = love.graphics.newImage('objects/sanitizer icon.png'),
        ['width'] = 16,
        ['height'] = 27,
        ['price'] = 75,
        ['name'] = 'Hand Sanitizer',
        ['description'] = 'kills 99.99 percent of germs! (don\'t ask what happens to the other 0.01 percent!) removes your current tile from your infection range. each bottle comes with three uses, but the effect only lasts 30 seconds.',
        ['key'] = '[',
    },
    { -- gloves
        ['type'] = 'gloves',
        ['icon'] = love.graphics.newImage('objects/gloves icon.png'),
        ['width'] = 20,
        ['height'] = 26,
        ['price'] = 100,
        ['name'] = 'Latex Gloves',
        ['description'] = 'disposable gloves that, when donned, remove your current tile from your infection range. Unlike hand sanitizer, the effect never wears off, but boy are these tight!',
        ['key'] = ']',
    },
    { -- sheild
        ['type'] = 'sheild',
        ['icon'] = love.graphics.newImage('objects/sheild icon.png'),
        ['width'] = 32,
        ['height'] = 22,
        ['price'] = 200,
        ['name'] = 'Face Sheild',
        ['description'] = 'a clear sheet of plastic that hangs infront of your face and redirects the air you exhale, reducing your infection range to just the two tiles beside you. just don\'t breath too hard or you might fog it up!',
        ['shadow'] = love.graphics.newImage('objects/sheild shadow.png'),
        ['key'] = ';',
    },
    { -- mask
        ['type'] = 'mask',
        ['icon'] = love.graphics.newImage('objects/mask icon.png'),
        ['width'] = 32,
        ['height'] = 21,
        ['price'] = 300,
        ['name'] = 'Face Mask',
        ['description'] = 'the classic personal protection device! drastically slows the air you exhale, limiting your infection range to just the tile in front of you. The only downside is that no one can see you smile.',
        ['key'] = '\'',
    },
    { -- rod
        ['type'] = 'rod',
        ['icon'] = love.graphics.newImage('objects/rod icon.png'),
        ['width'] = 36,
        ['height'] = 19,
        ['price'] = 300,
        ['name'] = 'Social Distance Rod',
        ['description'] = 'this new device is perfect for making sure the people in front of you keep their distance. it\'s the absolute cutting edge of disease prevention technology! (by that we mean it\'s just a belt with a pole attatched)',
        ['shadow'] = love.graphics.newImage('objects/rod shadow.png'),
        ['key'] = '.',
    },
    { --tube
        ['type'] = 'tube',
        ['icon'] = love.graphics.newImage('objects/tube icon.png'),
        ['width'] = 33,
        ['height'] = 15,
        ['price'] = 450,
        ['name'] = 'Social Distance Tube',
        ['description'] = 'we\'re not even going to kid you with this one, it\'s just an inner tube. either way, it\'s great at keeping people at a distance on all sides!',
        ['key'] = '/',
    },
    { -- test
        ['type'] = 'test',
        ['icon'] = love.graphics.newImage('objects/test icon.png'),
        ['width'] = 29,
        ['height'] = 29,
        ['speed'] = 20,
        ['key'] = ','
    }
}

defaultControls = {
    ['up'] = 'w',
    ['left'] = 'a',
    ['down'] = 's',
    ['right'] = 'd',
    ['select'] = 'return',
    ['back'] = 'rshift',
    ['fullscreen'] = 'lctrl',
    ['pause'] = 'escape',
    ['quarantine'] = '\\',
    ['items'] = {
        '',
        '[',
        ']',
        ';',
        '\'',
        '.',
        '/',
        ',',
    }
}

require 'Animation'
require 'Grid'
require 'Person'
require 'Player'
require 'Item'
require 'Building'
require 'Menu'
require 'UI'
require 'Tutorial'

function love.load()
    -- set up screen
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Social Distance Man')
    HUGE_WONDER = love.graphics.newFont("8BITWONDERNominal.pfb", 24)
    BIG_WONDER = love.graphics.newFont("8BITWONDERNominal.pfb", 18)
    MED_WONDER = love.graphics.newFont("8BITWONDERNominal.pfb", 12)
    SMALL_WONDER = love.graphics.newFont("8BITWONDERNominal.pfb", 6)
    love.graphics.setFont(SMALL_WONDER)

    if not love.filesystem.getInfo("SaveData.lua") then
        love.filesystem.newFile("SaveData.lua")
    end

    local chunk = love.filesystem.load("SaveData.lua")

    if chunk then
        chunk()
    end

    if not highScore then highScore = 0 end
    if not controls then controls = defaultControls end

    keyMenu = Menu(nil ,'main')
    end

function love.update(dt)
    if keyMenu then
        keyMenu:update(dt)
    elseif grid then
        grid:update(dt)
    end

    if tutorial then
        tutorial:update(dt)
    end
end

function love.keypressed(key)
    if tutorial then
        tutorial.keyPressed = key
    end

    if keyMenu then
        if keyMenu.menu then
            keyMenu.menu:keyPressed(key)
        else
            keyMenu:keyPressed(key)
        end
    elseif grid then
        if grid.player.selectedPerson then
            grid.player:action(key)
        elseif grid.menu and not (tutorial and tutorial.freezeMenu) then
            grid.menu:keyPressed(key)
        elseif key == controls.select and grid.player.state ~= 'selecting' then
            grid.player:select()
            return
        elseif key == controls.pause and not keyMenu then
            grid.player.state = 'selecting'
            keyMenu = Menu(grid, 'pause')
        end
    end

    if key == controls.fullscreen then
        local xChange
        local yChange
        if not love.window.getFullscreen() then
            love.window.setFullscreen(true)
            xChange = math.ceil((love.graphics.getWidth() - WINDOW_WIDTH) / 2)
            yChange = math.ceil((love.graphics.getHeight() - WINDOW_HEIGHT) / 2)
            WINDOW_WIDTH = love.graphics.getWidth()
            WINDOW_HEIGHT = love.graphics.getHeight()
        else
            xChange = math.floor((1281 - love.graphics.getWidth()) / 2)
            yChange = math.floor((693 - love.graphics.getHeight()) / 2)
            love.window.setFullscreen(false)
            WINDOW_WIDTH = 1281
            WINDOW_HEIGHT = 693
        end

        if grid then
            grid.gridX = grid.gridX + xChange
            grid.gridY = grid.gridY + yChange
            for _, tile in pairs(grid.tiles) do
                tile.tileX = tile.tileX + xChange
                tile.tileY = tile.tileY + yChange
            end
            for _, thing in pairs(grid.things) do
                thing.x = thing.x + xChange
                thing.y = thing.y + yChange

                if thing.ry then thing.ry = thing.ry + yChange end
            end

            grid.quarantine:loadBeds()
        end
    end
end

function save()
    local saveString = 'highScore = ' .. highScore .. ' controls = '

    saveString = saveString .. '{'
    for key, value in pairs(controls) do
        if value == '\\' then value = '\\\\' end
        if type(value) == 'table' then
            saveString = saveString .. '["' .. key .. '"] = {'
            for _, button in pairs(value) do
                saveString = saveString .. '"' .. button .. '", '
            end
            saveString = saveString .. '},'
        else
            saveString = saveString .. '["' .. key .. '"] = "' .. value .. '",'
        end
    end
    saveString = saveString .. '}'

    love.filesystem.write("SaveData.lua", saveString)
end


function love.draw()
    if grid then
        grid:render()
    end

    if keyMenu then
        keyMenu:render()
    end

    if tutorial then
        tutorial:render()
    end
end