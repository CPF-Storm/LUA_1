local grid = require("grid")
local piece = require("piece")


local game = {}

local cellSize = 30
local fallTimer = 0
local fallInterval = 0.5
local score = 0
local font
local paused = true

local currentPiece
local nextPiece

function game.load()
    grid.init(10, 20)
    nextPiece = piece.newRandom()
    spawnNewPiece()
    font = love.graphics.newFont(18)
love.graphics.setFont(font)
score = 0
end

function spawnNewPiece()
    currentPiece = nextPiece
    currentPiece.x = 4
    currentPiece.y = 1
    nextPiece = piece.newRandom()

    if grid.checkCollision(currentPiece) then
        print("Game Over")
        love.event.quit()
    end
end

function game.update(dt)

    if paused then return end

    fallTimer = fallTimer + dt
    if fallTimer >= fallInterval then
        fallTimer = 0
        if not grid.tryMove(currentPiece, 0, 1) then
            grid.lockPiece(currentPiece)
        
            local lines = grid.clearLines() 
            if lines > 0 then
                score = score + (lines == 1 and 100 or lines == 2 and 300 or lines == 3 and 500 or 800)
            end
        
            spawnNewPiece()
        end
end
end
    


function game.draw()
    grid.draw(cellSize)
    piece.draw(currentPiece, cellSize)


    
love.graphics.setColor(1, 1, 1)
love.graphics.print("Next:", 330, 10)
piece.draw(nextPiece, 20, 330, 40)


love.graphics.setColor(1, 1, 1)
love.graphics.print("Score: " .. score, 330, 140)



    love.graphics.print("Controls:", 330, 250)
    
    love.graphics.print("Left or right  Move", 330, 270)
    
    love.graphics.print("Down           Soft Drop", 330, 290)
    
    love.graphics.print("Space           Pause", 330, 310)
    
    love.graphics.print("Up                Rotate", 330, 330)

    


if paused then
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("PAUSED", 330, 180)
end

   
end

function game.keypressed(key)

    if key == "space" then
        paused = not paused
        return
    end

    if paused then return end 

    if key == "left" then
        grid.tryMove(currentPiece, -1, 0)
    elseif key == "right" then
        grid.tryMove(currentPiece, 1, 0)
    elseif key == "down" then
        grid.tryMove(currentPiece, 0, 1)
    elseif key == "z" or key == "up" then
        piece.tryRotate(currentPiece)
    end
end

return game
