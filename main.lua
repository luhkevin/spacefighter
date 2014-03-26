--[[
--
--Space opera type game
--
]]--

local ship = {}
local asteroid = {}
local enemies = {}

function love.load()
    --TODO: put this all in ship.lua file later
    ship.img = love.graphics.newImage("ship.png")
    ship.theta = 0
    ship.x, ship.y = 100, 100
    ship.width, ship.height = ship.img:getWidth(), ship.img:getHeight()
    ship.speed = 10
    ship.drift = 0.5

    --TODO: make this have components of ship...inherit from ship?
    asteroid.img = love.graphics.newImage("enemy.png")

    love.window.setMode(640, 480)
end


function love.draw() 
    love.graphics.setColor(255, 255, 255)

    --debug
    debug()

    --offset origin to image's center
    love.graphics.draw(ship.img, ship.x, ship.y, math.rad(ship.theta), nil, nil, ship.width/2, ship.height/2)
end

function love.update(dt)
    --love2D is CW positive for some reason...
    if love.keyboard.isDown("a") then
        ship.theta = (ship.theta - 10) % 360
    elseif love.keyboard.isDown("d") then
        ship.theta = (ship.theta + 10) % 360
    elseif love.keyboard.isDown("w") then
        ship.x = ship.x + ship.speed * math.cos(math.rad(90 - ship.theta))
        ship.y = ship.y - ship.speed * math.sin(math.rad(90 - ship.theta))
    elseif love.keyboard.isDown("s") then
        ship.x = ship.x - ship.speed * math.cos(math.rad(90 - ship.theta))
        ship.y = ship.y + ship.speed * math.sin(math.rad(90 - ship.theta))
    else
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

function drift(x, y) 
    --TODO: vectorize physics before actually implementing drift
    --ugh this code is stupid. refactor later

    --[[
    if ship.theta < 180 then a = -1 elseif 
        ship.theta > 180 then a = 1 else a = 0 end

    if ship.theta < 90 or ship.theta > 270 then b = -1 elseif 
        ship.theta > 90 or ship.theta < 270 then b = 1
        ]]--


    --return x + a * ship.drift, y + b * ship.drift
    --Something like: ship.velocity = ship.velocity + vector(0.05, 0.05)
end

function asteroidGen(seed)
    
end

function debug()
    love.graphics.print("ship angle: " .. ship.theta, 0, 50)
    love.graphics.print("ship x: " .. ship.x .. " ship y: " .. ship.y, 0, 75)
    --[[
    love.graphics.print(math.cos(math.rad(90 - ship.theta)), 0, 25)
    love.graphics.print(math.sin(math.rad(90 - ship.theta)), 0, 50)
    ]]--
end

