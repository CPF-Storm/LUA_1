local grid = {}

local width, height
local cells = {}

function grid.init(w, h)
    width = w
    height = h
    for y = 1, height do
        cells[y] = {}
        for x = 1, width do
            cells[y][x] = 0
        end
    end
end

function grid.tryMove(p, dx, dy)
    local newPiece = {
        x = p.x + dx,
        y = p.y + dy,
        shape = p.shape
    }

    if not grid.checkCollision(newPiece) then
        p.x = newPiece.x
        p.y = newPiece.y
        return true
    end
    return false
end


function grid.checkCollision(p)
    for y = 1, #p.shape do
        for x = 1, #p.shape[y] do
            if p.shape[y][x] ~= 0 then
                local gx = p.x + x - 1
                local gy = p.y + y - 1
                if gx < 1 or gx > width or gy > height or (gy > 0 and cells[gy][gx] ~= 0) then
                    return true
                end
            end
        end
    end
    return false
end

function grid.lockPiece(p)
    for y = 1, #p.shape do
        for x = 1, #p.shape[y] do
            if p.shape[y][x] ~= 0 then
                local gx = p.x + x - 1
                local gy = p.y + y - 1
                if gy >= 1 and gy <= height then
                    cells[gy][gx] = p.color
                end
            end
        end
    end
end

function grid.clearLines()
    local linesCleared = 0
    for y = height, 1, -1 do
        local full = true
        for x = 1, width do
            if cells[y][x] == 0 then
                full = false
                break
            end
        end
        if full then
            for row = y, 2, -1 do
                cells[row] = table.move(cells[row - 1], 1, width, 1, {})
            end
            cells[1] = {}
            for x = 1, width do
                cells[1][x] = 0
            end
            linesCleared = linesCleared + 1
            y = y + 1
        end
    end
    return linesCleared
end

function grid.draw(cellSize)
    for y = 1, height do
        for x = 1, width do
            local cell = cells[y][x]
            if cell ~= 0 then
                love.graphics.setColor(cell)
                love.graphics.rectangle("fill", (x - 1) * cellSize, (y - 1) * cellSize, cellSize, cellSize)
            end
        end
    end

    
end





return grid
