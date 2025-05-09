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
    local y = height

    while y >= 1 do
        local fullRow = true
        for x = 1, width do
            if cells[y][x] == 0 then
                fullRow = false
                break
            end
        end

        if fullRow then
            -- Shift 
            for row = y, 2, -1 do
                for x = 1, width do
                    cells[row][x] = cells[row - 1][x]
                end
            end
            -- Clear 
            for x = 1, width do
                cells[1][x] = 0
            end

            linesCleared = linesCleared + 1
            
        else
            y = y - 1
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

   
    love.graphics.setColor(0.2, 0.2, 0.2)
    for y = 0, height do
        love.graphics.line(0, y * cellSize, width * cellSize, y * cellSize)
    end
    for x = 0, width do
        love.graphics.line(x * cellSize, 0, x * cellSize, height * cellSize)
    end

    
end





return grid
