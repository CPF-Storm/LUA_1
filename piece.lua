local pieces = require("pieces")

local piece = {}

function piece.newRandom()
    local keys = {}
    for k in pairs(pieces) do table.insert(keys, k) end
    local key = keys[love.math.random(#keys)]
    local data = pieces[key]
    return {
        x = 4,
        y = 1,
        shape = piece.copyShape(data.shape),
        color = data.color
    }
end

function piece.tryRotate(p)
    local rotated = piece.rotate(p.shape)
    local test = { x = p.x, y = p.y, shape = rotated }
    local grid = require("grid")
    if not grid.checkCollision(test) then
        p.shape = rotated
    end
end

function piece.rotate(shape)
    local new = {}
    for x = 1, #shape[1] do
        new[x] = {}
        for y = #shape, 1, -1 do
            new[x][#shape - y + 1] = shape[y][x]
        end
    end
    return new
end

function piece.copyShape(shape)
    local copy = {}
    for y = 1, #shape do
        copy[y] = {}
        for x = 1, #shape[y] do
            copy[y][x] = shape[y][x]
        end
    end
    return copy
end

function piece.draw(p, cellSize, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    love.graphics.setColor(p.color or {1, 1, 1})
    for y = 1, #p.shape do
        for x = 1, #p.shape[y] do
            if p.shape[y][x] ~= 0 then
                love.graphics.rectangle(
                    "fill",
                    offsetX + (p.x + x - 2) * cellSize,
                    offsetY + (p.y + y - 2) * cellSize,
                    cellSize,
                    cellSize
                )
            end
        end
    end
end


return piece
