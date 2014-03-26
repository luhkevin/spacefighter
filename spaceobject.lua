local class = require 'middleclass'
local vector = require 'hump.vector'
local collision = require "collision"

SpaceObject = class('SpaceObject')

--Must give name, image
function SpaceObject:initialize(objectName, img, width, height, position, velocity, rotation, drift)
    self.objectName = name
    self.img = img
    self.wd = width
    self.ht = height
    self.position = position or {x=0, y=0}
    self.rotation = rotation or 0

    --Use hump's vector library for velocity
    self.velocity = velocity or vector(1, 1)
    
    self.driftFactor = driftFactor or 1
end

--TODO: change velocity vectors after rotation
function SpaceObject:rotate(direction)
    if direction == "cw" then
        self.rotation = (self.rotation + 5) % 360
    elseif direction == "ccw" then
        self.rotation = (self.rotation - 5) % 360
    end
end

function SpaceObject:move(direction, dt)
    x, y = self.position.x, self.position.y
    if direction ~= nil then
        --set velocity to (5, 5) if moving 
        if direction == "fwd" or direction == "bwd" then
            self.velocity = vector(5, 5)
            self.currentDir = direction
        end
        --print("VELOCITY: ", self.velocity)
        --print("POSITION: ", self.position.x, self.position.y)

        --set velocity to (0.5, 0.5) if drifting
        if direction == "dfwd" or direction == "dbwd" then
            self.velocity = vector(0.5, 0.5)
        end

        velX, velY = self.velocity:unpack()

        --TODO: actually change velocity (actually change the x,y values)
        if direction == "fwd" or direction == "dfwd" then
            --print("GOING FORWARD", velX, velY)
            self.position.x = (x + velX * math.sin(math.rad(self.rotation)))
            self.position.y = (y - velY * math.cos(math.rad(self.rotation)))
        elseif direction == "bwd" or direction == "dbwd" then
            --print("GOING BACKWARD", velX, velY)
            self.position.x = (x - velX * math.sin(math.rad(self.rotation)))
            self.position.y = (y + velY * math.cos(math.rad(self.rotation)))
        end

    else 
        self:drift(self.currentDir, dt)
    end
    --multiple dt by velocity to get total movement per unit of dt time
end

function SpaceObject:drift(direction, dt)
    if direction == "fwd" then
        self:move("dfwd", dt)
    elseif direction == "bwd" then
        self:move("dbwd", dt)
    end
end


function SpaceObject:collide(objB)
    return collision.BBcollide({x=self.position.x, y=self.position.y, w = self.wd, h = self.ht}, objB)
end

