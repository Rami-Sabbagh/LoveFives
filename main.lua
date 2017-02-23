material = require("material-love")
_Width, _Height = love.graphics.getDimensions()

local cb = {
'update', 'draw', 'keypressed', 'keyreleased', 'mousepressed', 'mousemoved', 'mousereleased',
'touchpressed', 'touchmoved', 'touchreleased', 'resize'
}

function clearlove() --Clears love callbacks
  for k, c in ipairs(cb) do
    love[c] = function() end
  end
end

function love.load()
  clearlove()
  assert(love.filesystem.load("/states/game.lua"))()--splash.lua"))()
end