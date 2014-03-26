--[[
--
--Space opera type game
--
]]--

local class = require "middleclass"
local SO = require "spaceobject"

--subclassing
local Ship = class('Ship', SpaceObject)

--Layer1 should move twice as fast as Layer2
local starsLayer1 = {}
local starsLayer2 = {}

function love.load()
    shipImg = love.graphics.newImage("ship.png")
    ship = Ship:new('hero', shipImg, {x=100, y=100}, nil, nil, 0.5)

    --TODO: way to do this get off 
    shipWd, shipHt = shipImg:getWidth(), shipImg:getHeight()

    love.window.setMode(640, 480)
end


function love.draw() 
    love.graphics.setColor(255, 255, 255)

    --debug
    debug()

    --offset origin to image's center
    love.graphics.draw(ship.img, ship.position.x, ship.position.y, math.rad(ship.rotation), nil, nil, shipWd/2, shipHt/2)
end

function love.update(dt)
    --love2D is CW positive for some reason...
    if love.keyboard.isDown("a") then
        ship:rotate("ccw")
    elseif love.keyboard.isDown("d") then
        ship:rotate("cw")
    elseif love.keyboard.isDown("w") then
        ship:move("fwd", dt)
    elseif love.keyboard.isDown("s") then
        ship:move("bwd", dt)
    else
        ship:drift(dt)
        --microdrift
        --ship.x, ship.y = drift(ship.x, ship.y)
    end
end 

function love.keypressed(k)
    if k == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button) 

end

function debug()
    love.graphics.print(ship.rotation .. " " .. ship.position.x .. " " ..  " " .. ship.position.y, 300, 75)
end

