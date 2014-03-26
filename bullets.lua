--[[
--
--Space opera type game
--
]]--

local text = {}
local shapes = {}
local bullets = {}
local firedbullets = {}

local enemies = {}

HC = require 'hardoncollider'
GC = require 'hump/gamestate'

function on_collision() end
function collision_stop() end

function c_enemy() end
function cs_enemy() end

function love.load()
    Collider = HC(100, on_collision, collision_stop)
    mouse = Collider:addCircle(400, 300, 20)
    mouse:moveTo(love.mouse.getPosition())

    EnCollider = HC(100, c_enemy, cs_enemy)

    enemy = love.graphics.newImage("enemy.png")
    particle = love.graphics.newImage("particle.png")
    particles = love.graphics.newParticleSystem(particle, 200)
    particles:setImage(particle)
    
    particles:setEmissionRate          (20)
    particles:setEmitterLifetime              (0.1)
    particles:setParticleLifetime          (3)
    particles:setPosition              (love.mouse.getX(), love.mouse.getY())
    particles:setDirection             (0)
    particles:setSpread                (2)
    particles:setSpeed                 (20, 90)
    particles:setLinearAcceleration    (-50, 50)
    particles:setRadialAcceleration    (10)
    particles:setTangentialAcceleration(0)
    particles:setSizes                  (1.5)
    particles:setSizeVariation         (0.7)
    particles:setRotation              (0)
    particles:setSpin                  (0)
    particles:setSpinVariation         (0)
    particles:setColors                 (200, 200, 255, 240, 255, 255, 255, 10)
    particles:stop();--this stop is to prevent any glitch that could happen after the particle system is created
    for i = 1, 5 do
        bullet = {love.graphics.newImage("bullet.png"), ['x']=0, ['y']=0}
        bullets[i] = bullet
    end

    enemyY = 10
end


function love.draw() 
    love.graphics.setColor(255, 255, 255)
    mouse:draw('fill')

    for i = 1, #firedbullets do
        if firedbullets[i] ~= nil then
            love.graphics.draw(firedbullets[i][1], firedbullets[i].x, firedbullets[i].y)
        end
    end

    love.graphics.draw(enemy, love.mouse.getX(), enemyY)
    love.graphics.draw(particles, 20, 20)
end

function love.update(dt)
    mouse:moveTo(love.mouse.getPosition())
    Collider:update(dt)

    --update yPosition of fired bullets and push back onto bullet stack
    for i = 1, #firedbullets do
        if firedbullets[i].y <= 0 then 
            push(bullets, firedbullets[i])
            table.remove(firedbullets, i)
            break
        else
            firedbullets[i].y = firedbullets[i].y - 10
        end

        if intersects(firedbullets[i], i) then enemyY = 10 end
    end

    enemyY = enemyY + 5
    if enemyY >= love.mouse.getY() then enemyY = 10 end

    particles:start()
    particles:update(dt)
end 

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button) 
    --pop bullets and push onto firedbullets
    if love.mouse.isDown("l") and #bullets > 0 then
        push(firedbullets, pop(bullets))
        firedbullets[#firedbullets].x, 
        firedbullets[#firedbullets].y = 
            love.mouse.getX(), 
            love.mouse.getY() - 40
    end

end

function push(s, el)
    s[#s + 1] = el
end

function pop(s)
    top = s[#s]
    s[#s] = nil
    return top
end

function intersects(shapeA, index)
    if enemyY < shapeA.y + 10 and enemyY > shapeA.y - 10 then
        push(bullets, shapeA)
        table.remove(firedbullets, index)
        return true
    end
    
    return false
end

