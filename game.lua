local grid = require("grid")
local piece = require("piece")
local pieces = require("pieces")

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
            grid.clearLines()
            spawnNewPiece()
        end
    end

    local lines = grid.clearLines()
    local lineScores = { [1] = 100, [2] = 300, [3] = 500, [4] = 800 }
    if lines > 0 then
        score = score + (lineScores[lines] or lines * 100)
    end


end

function game.draw()
    grid.draw(cellSize)
    piece.draw(currentPiece, cellSize)



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
