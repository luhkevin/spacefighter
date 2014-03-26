--[[
--
--Space opera type game
--
]]--

local class = require "middleclass"
local SO = require "spaceobject"
local SF = require "starfield"

--subclassing
local Ship = class('Ship', SpaceObject)
local Enemy = class('Enemy', SpaceObject)

--Layer1 should move twice as fast as Layer2
local starsLayer1 = {50, 10, 50, 30, 50, 50}
local starsLayer2 = {200, 10, 200, 30, 200, 50}

function love.load()
    background = love.graphics.newImage("background.png")
    shipImg = love.graphics.newImage("ship.png")
    enemyImg = love.graphics.newImage("enemy.png")

    shipWd, shipHt = shipImg:getWidth(), shipImg:getHeight()
    ship = Ship:new('hero', shipImg, shipWd, shipHt, {x=100, y=100}, nil, nil, 0.5)

    enemyWd, enemyHt= enemyImg:getWidth(), enemyImg:getHeight()
    enemy = Enemy:new('enemy', enemyImg, enemyWd, enemyHt, {x=400, y=300}, nil, nil, 0)

    --TODO: way to do this w/o shipImg

    love.window.setMode(640, 480)
    parOff1, parOff2 = 0, 0
end


function love.draw() 
    --love.graphics.setBackgroundColor(0, 0, 0)
    
    --draw background
    love.graphics.draw(background, 0, 0, 0, 1, 1, 0, 0)

    --debug
    debug()

    --draw parallax
    love.graphics.setColor(255, 0, 0)
    for i = 1, #starsLayer1, 2 do
        love.graphics.point(starsLayer1[i], (starsLayer1[i + 1] + parOff1) % love.window.getHeight())
        love.graphics.point(starsLayer1[i] + 1 , (starsLayer1[i + 1] + parOff1) % love.window.getHeight())
        love.graphics.point(starsLayer1[i], (starsLayer1[i + 1] + parOff1 - 1) % love.window.getHeight())
        love.graphics.point(starsLayer1[i] + 1, (starsLayer1[i + 1] + parOff1 - 1) % love.window.getHeight())
    end

    for i = 1, #starsLayer2, 2 do
        love.graphics.point(starsLayer2[i], (starsLayer2[i + 1] + parOff2) % love.window.getHeight())
        love.graphics.point(starsLayer2[i] + 1 , (starsLayer2[i + 1] + parOff2) % love.window.getHeight())
        love.graphics.point(starsLayer2[i], (starsLayer2[i + 1] + parOff2 - 1) % love.window.getHeight())
        love.graphics.point(starsLayer2[i] + 1, (starsLayer2[i + 1] + parOff2 - 1) % love.window.getHeight())
    end

    --offset origin to ship's center
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(ship.img, ship.position.x, ship.position.y, math.rad(ship.rotation), nil, nil, shipWd/2, shipHt/2)

    --draw enemy
    love.graphics.draw(enemy.img, enemy.position.x, enemy.position.y)

end

function love.update(dt)
    --For starfield parallax
    parOff1 = parOff1 + (20 * dt) % love.window.getHeight()
    parOff2 = parOff2 + (10 * dt) % love.window.getHeight()

    --love2D is CW positive for some reason...
    local dir = nil
    if love.keyboard.isDown("a") then
        dir = "ccw"
    elseif love.keyboard.isDown("d") then
        dir = "cw"
    elseif love.keyboard.isDown("w") then
        dir = "fwd"
    elseif love.keyboard.isDown("s") then
        dir = "bwd"
    end
    ship:rotate(dir)
    ship:move(dir, dt)

    --collisions
    --if ship:collide({x=enemy.position.x, y=enemy.position.y, w=enemy.wd, h=enemy.ht}) then

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

