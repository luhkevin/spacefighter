local collision = {} 

function collision.BBcollide(objA, objB)
    return objA.x < objB.x + objB.w and
           objB.x < objA.x + objA.w and
           objA.y < objB.y + objB.h and
           objB.y < objA.y + objA.h
end

return collision

