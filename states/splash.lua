local lovesplashes = require("o-ten-one")
local tween = require("tween") --linear 230

local splash = lovesplashes( { background = {material.colors.background("dark")} } )

local startfade = false
local fade = {0}
local fadeTween = tween.new(1,fade,{255},"linear")

function love.draw()
  splash:draw()
  
  if startfade then
    local r, g, b = material.colors.background("dark")
    love.graphics.setColor(r,g,b,fade[1])
    love.graphics.rectangle("fill",0,0,_Width,_Height)
  end
end

function love.update(dt)
  splash:update(dt)
  
  if startfade then
    if fadeTween:update(dt) then
      clearlove()
      assert(love.filesystem.load("/states/game.lua"))()--selection.lua"))()
    end
  end
end

function love.keypressed()
  splash:skip()
end

love.mousepressed = love.keypressed

function splash.onDone()
  startfade = true
end