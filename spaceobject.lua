local class = require 'middleclass'
local vector = require 'hump.vector'

SpaceObject = class('SpaceObject')

--Must give name, image
function SpaceObject:initialize(objectName, img, position, velocity, rotation, drift)
    self.objectName = name
    self.img = img
    self.position = position or {x=0, y=0}
    self.rotation = rotation or 0

    --Use hump's vector library for velocity
    self.velocity = velocity or vector(0, 0)
    
    self.driftFactor = driftFactor or 1
end

--TODO: change velocity vectors after rotation
function SpaceObject:rotate(direction)
    if direction == "cw" then
        self.rotation = (self.rotation + 10) % 360
    elseif direction == "ccw" then
        self.rotation = (self.rotation - 10) % 360
    else
        print("Invalid direction of rotation")
    end
end

function SpaceObject:move(direction, dt)
    self.velocity = vector(5, 5)
    velX, velY = self.velocity:unpack()
    x, y = self.position.x, self.position.y
    if direction == "fwd" then
        self.position.x = (x + velX * math.sin(math.rad(self.rotation)))
        self.position.y = (y - velY * math.cos(math.rad(self.rotation)))
    elseif direction == "bwd" then
        self.position.x = (x - velX * math.sin(math.rad(self.rotation)))
        self.position.y = (y + velY * math.cos(math.rad(self.rotation)))
    else 
        self.drift(dt)
    end
    --multiple dt by velocity to get total movement per unit of dt time
end

function SpaceObject:drift(dt)
    return 5
end


function SpaceObject:collide(collection)

end


