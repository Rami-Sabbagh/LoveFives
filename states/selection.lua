love.graphics.setBackgroundColor(material.colors.background("dark"))

local gh = _Height/12 --Grid Height
local white = {material.colors.main("grey", "50")}

_tf = _tf or love.graphics.newFont("/o-ten-one/handy-andy.otf",gh) --TitleFont

local cbs = gh/2--CheckBoxSideSize
local cbt = cbs/8 --CheckBoxLineThickness
local cbp = cbs --CheckBoxPadding
_cbf = _cbf or love.graphics.newFont("/o-ten-one/handy-andy.otf", cbs) --CheckBoxFont

local colbt = "Color Blind Mode" --ColorBlindText
local colbw = _cbf:getWidth(colbt)+cbp+cbs --ColorBlindWidth
local colbx = _Width/2 - colbw/2 --ColorBlindXPos

local wtt = "White Theme" --WhiteThemeText
local wtw = _cbf:getWidth(wtt)+cbp+cbs --WhiteThemeWidth
local wtx = _Width/2 - wtw/2 --WhiteThemeXPos

local rlt = "Place Random Lines Initially" --RandomLinesText
local rlw = _cbf:getWidth(rlt)+cbp+cbs --RandomLinesWidth
local rlx = _Width/2 - rlw/2 --RandomLinesXPos

function love.draw()
  --Title
  love.graphics.setFont(_tf)
  love.graphics.setColor(white)
  love.graphics.printf("Dots And Boxes", 0, gh, _Width-1, "center")
  
  love.graphics.setFont(_cbf)
  love.graphics.setLineWidth(cbt)
  
  --==ColorBlind==--
  --CheckBox
  love.graphics.rectangle("line",colbx,gh*3, cbs,cbs)
  --Text
  love.graphics.print(colbt, colbx+cbp+cbs, gh*3)
  
  --==WhiteTheme==--
  --CheckBox
  love.graphics.rectangle("line",wtx,gh*4, cbs,cbs)
  --Text
  love.graphics.print(wtt, wtx+cbp+cbs, gh*4)
  
  --==RandomLines==--
  --CheckBox
  love.graphics.rectangle("line",rlx,gh*5, cbs,cbs)
  --Text
  love.graphics.print(rlt, rlx+cbp+cbs, gh*5)
  
end

function love.update(dt)
  
end

function love.mousepressed(x,y, b, istouch)
  if istouch then return end
  love.touchpressed(0, x,y, 0,0, 1)
end

function love.mousemoved(x,y, dx,dy, istouch)
  if istouch then return end
  love.touchmoved(0, x,y, dx,dy, 1)
end

function love.mousereleased(x,y, b, istouch)
  if istouch then return end
  love.touchreleased(0, x,y, 0,0, 1)
end