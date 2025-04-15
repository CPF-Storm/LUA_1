if arg[2] == "debug" then
    require("lldebugger").start()
end


-- sit at the bottom of the script
local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end