--[[
--
--Galaga clone
--
]]--

HC = require 'hardoncollider'

local text = {}
local shapes = {}
local bullets = {}

local ship = {x = 300, y = 300, width = 48, height = 48, velocity = {x = 0, y = 0}, image = ""}

function on_collision(dt, shape_a, shape_b, mtv_x, mtv_y)
    text[#text + 1] = string.format("Colliding. mtv = (%s, %s)", mtv_x, mtv_y)
end

function collision_stop(dt, shape_a, shape_b)
    text[#text + 1] = "Stopped colliding"
end

function love.load()
    mouseX, mouseY = love.mouse.getPosition()
    Collider = HC(100, on_collision, collision_stop)
    rect = Collider:addRectangle(200, 400, 400, 20)
    ship.rect = Collider:addRectangle(ship.x, ship.y, ship.width, ship.height)
    ship.image = love.graphics.newImage("ship.png") 

    mouse = Collider:addCircle(400, 300, 20)
    mouse:moveTo(love.mouse.getPosition())
end


function love.draw()    
    for i = 1, #text do
        love.graphics.setColor(255, 255, 255, 255 - (i - 1) * 6)
        love.graphics.print(text[#text - (i - 1)], 10, i * 15)
    end

    love.graphics.print(love.mouse.getPosition(), 200, 200)

    love.graphics.draw(ship.image, ship.x - ship.width/2, ship.y - ship.height/2, ship.rect:rotation())
    love.graphics.setColor(255, 255, 255)
    rect:draw('fill')
    ship.rect:draw('fill')
    mouse:draw('fill')

end

function love.update(dt)
    --mouse:moveTo(love.mouse.getPosition())
    ship.rect:moveTo(ship.x, ship.y)
    --rect:rotate(dt)

    Collider:update(dt)

    while #text > 40 do
        table.remove(text, 1)
    end

    if love.keyboard.isDown('a') then
        ship.rect:setRotation(ship.rect:rotation() + dt, ship.rect:center())
    elseif love.keyboard.isDown('d') then
        ship.rect:setRotation(ship.rect:rotation() - dt, ship.rect:center())
    elseif love.keyboard.isDown('w') then
        ship.y = ship.y - 5
    elseif love.keyboard.isDown('s') then
        ship.y = ship.y + 5
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mouse.isDown(key)
    if key == 'l' then
        mouseX, mouseY = love.mouse.getPosition()
    end
end

