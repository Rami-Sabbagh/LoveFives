love.graphics.setBackgroundColor(material.colors.background("dark"))

local pnum = 4 --Number Of Players
local pturns = {} --The turns order of players
local players = {} for i=1,pnum do table.insert(players,i) end
for i=1, pnum do --Assign the random turns
  love.math.setRandomSeed(os.time() * 10^5 + os.clock())
  local p = math.min(math.floor(love.math.random(1, #players)+0.5), #players)
  local pid = players[p]
  newPlayers = {}
  for k,v in ipairs(players) do if k ~= p then table.insert(newPlayers,v) end end
  players = newPlayers
  table.insert(pturns,pid)
end players = nil
local curturn = 1 --Current turn

local pnames = { "Blue", "Pink", "Orange", "Grey" }
local pletters = { "B", "P", "O", "G" }
local pcolors = {}
pcolors[1] = {39, 170, 225} --Blue
pcolors[2] = {231,  74, 153} --Pink
pcolors[3] = {material.colors.main("orange")} --Orange
pcolors[4] = {material.colors.main("grey")} --Grey

local dbw, dbh = 10, 10 --Dots Board Size

local gh = _Height/16
_gtf = _gtf or love.graphics.newFont("/o-ten-one/handy-andy.otf",gh) --GameTurnFont

--Game Turn Text--
local gtt = pnames[pturns[curturn]].."'s Turn" --TurnText
local gty = gh --TurnTextYPos

--DotsGrid--
local dgw = _Width - gh*2
local dgh = _Height - gh*4
local dgs = 0 --The length of a line
if dgw/(dbw-1) > dgh/(dbh-1) then
  dgs = dgh/(dbh-1)
  dgw = dgh
else
  dgs = dgw/(dbw-1)
  dgh = dgw 
end
local dgx, dgy = _Width/2 - dgw/2, gty + gh*2
local dgdata = {} --DotsGridData
for x=1,dbw do dgdata[x] = {} for y=1, dbh do dgdata[x][y] = {} end end --Build the data table
local dgcolor = {material.colors.main("blue-grey")}
local dotsize = gh/16
local dotsgrid = {dgx - dgs/2, dgy - dgs/2, dgw+dgs,dgh+dgs, dbw, dbh}  --The grid table

function love.resize(w,h)
  _Width, _Height = w,h
  
  --Recalculate
  gh = _Height/16
  _gtf = love.graphics.newFont("/o-ten-one/handy-andy.otf",gh)
  
  gty = gh
  
  dgw = _Width - gh*2
  dgh = _Height - gh*4
  dgs = 0
  if dgw/(dbw-1) > dgh/(dbh-1) then
    dgs = dgh/(dbh-1)
    dgw = dgh
  else
    dgs = dgw/(dbw-1)
    dgh = dgw
  end
  dgx, dgy = _Width/2 - dgw/2, gty + gh*2
  dotsize = gh/16
  dotsgrid = {dgx - dgs/2, dgy - dgs/2, dgw+dgs,dgh+dgs, dbw, dbh}  --The grid table
end

local dl = {} --Drawing Line

function whereInGrid(x,y, grid) --Grid X, Grid Y, Grid Width, Grid Height, NumOfCells in width, NumOfCells in height
  local gx,gy,gw,gh,cw,ch = unpack(grid)
  
  if isInRect(x,y,{gx,gy,gw,gh}) then
    local clw, clh = math.floor(gw/cw), math.floor(gh/ch)
    local x, y = x-gx, y-gy
    local hx = math.floor(x/clw)+1 hx = hx <= cw and hx or hx-1
    local hy = math.floor(y/clh)+1 hy = hy <= ch and hy or hy-1
    return hx,hy
  end
  return false, false
end


function love.draw()
  --Draw Game Turn Text--
  love.graphics.setFont(_gtf)
  love.graphics.setColor(pcolors[pturns[curturn]])
  love.graphics.printf(gtt, 0,gty, _Width, "center")
  
  --Draw the dots grid--
  love.graphics.setColor(dgcolor)
  love.graphics.setPointSize(dotsize)
  for x=0, dbw -1 do
    for y=0, dbh -1 do
      love.graphics.circle("line", dgx + dgs*x, dgy + dgs*y, dotsize)
    end
  end
end

function love.update(dt)
  
end

function love.touchpressed(id,x,y,dx,dy,p)

end

function love.touchmoved(id,x,y,dx,dy,p)

end

function love.touchreleased(id,x,y,dx,dy,p)

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