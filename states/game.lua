love.graphics.setBackgroundColor(material.colors.background("dark"))

local tween = require("tween") --linear 230

local winMsg
local fade = {0}
local fadeTween = tween.new(1,fade,{175},"linear")

local pnum = 2 --Number Of Players
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
pcolors[1] = {39, 170, 225, 255} --Blue
pcolors[2] = {231,  74, 153, 255} --Pink
pcolors[3] = {material.colors.main("orange")} --Orange
pcolors[4] = {material.colors.main("grey")} --Grey

local dbw, dbh = 7, 7 --Dots Board Size

local maxlines = (dbw-1)*(dbh-1)*2 + (dbh-1) + (dbw-1)
local linesNum = 0
local pscores = {} for i=1, pnum do table.insert(pscores,0) end
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
local dotsize = gh/8
local dotnewsize = gh/14
local dotWidth = gh/24
local dotLineSize = gh/12
local dotCLineSize = gh/10
local dotsgrid = {dgx - dgs/2, dgy - dgs/2, dgw+dgs,dgh+dgs, dbw, dbh}  --The grid table

local ripples = {}

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
  dotnewsize = gh/14
  dotWidth = gh/24
  dotLineSize = gh/12
  dotCLineSize = gh/10
  dotsgrid = {dgx - dgs/2, dgy - dgs/2, dgw+dgs,dgh+dgs, dbw, dbh}  --The grid table
end

local dl --Drawing Line

local function isInRect(x,y,rect)
  if x >= rect[1] and y >= rect[2] and x <= rect[1]+rect[3]-1 and y <= rect[2]+rect[4]-1 then return true end return false
end

local function whereInGrid(x,y, grid) --Grid X, Grid Y, Grid Width, Grid Height, NumOfCells in width, NumOfCells in height
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
  love.graphics.setLineWidth(dotWidth)
  for x=0, dbw -1 do
    for y=0, dbh -1 do
      love.graphics.circle("line", dgx + dgs*x, dgy + dgs*y, dotsize)
    end
  end
  
  for x=0, dbw -1 do
    for y=0, dbh -1 do
      if dgdata[x+1][y+1].v and dgdata[x+1][y+1].h then
        love.graphics.setLineWidth(dotCLineSize)
        love.graphics.setColor(pcolors[dgdata[x+1][y+1].h])
        love.graphics.line(dgx + dgs*x, dgy + dgs*y, dgx + dgs*x + dgs, dgy + dgs*y)
        
        love.graphics.circle("fill", dgx + dgs*x + dgs, dgy + dgs*y, dotsize)
        
        love.graphics.setLineWidth(dotCLineSize)
        love.graphics.setColor(pcolors[dgdata[x+1][y+1].v])
        love.graphics.line(dgx + dgs*x, dgy + dgs*y, dgx + dgs*x, dgy + dgs*y + dgs)
        
        love.graphics.circle("fill", dgx + dgs*x, dgy + dgs*y + dgs, dotsize)
        
        love.graphics.setColor(dgcolor)
        love.graphics.circle("fill", dgx + dgs*x, dgy + dgs*y, dotsize)
        
      elseif dgdata[x+1][y+1].h then
        love.graphics.setColor(pcolors[dgdata[x+1][y+1].h])
        love.graphics.setLineWidth(dotCLineSize)
        love.graphics.line(dgx + dgs*x, dgy + dgs*y, dgx + dgs*x + dgs, dgy + dgs*y)
        
        love.graphics.circle("fill", dgx + dgs*x + dgs, dgy + dgs*y, dotsize)
        love.graphics.circle("fill", dgx + dgs*x, dgy + dgs*y, dotsize)
        
      elseif dgdata[x+1][y+1].v then
        love.graphics.setColor(pcolors[dgdata[x+1][y+1].v])
        love.graphics.setLineWidth(dotCLineSize)
        love.graphics.line(dgx + dgs*x, dgy + dgs*y, dgx + dgs*x, dgy + dgs*y + dgs)
        
        love.graphics.circle("fill", dgx + dgs*x, dgy + dgs*y + dgs, dotsize)
        love.graphics.circle("fill", dgx + dgs*x, dgy + dgs*y, dotsize)
        
      end
    end
  end
  
  --Draw the ripples
  for k, r in ipairs(ripples) do
    r:draw()
  end
  
  --Draw the current under creation line
  if dl then
    love.graphics.setColor(dl.col)
    love.graphics.setLineWidth(dotLineSize)
    love.graphics.line(dl.x1,dl.y1, dl.x2,dl.y2)
    love.graphics.circle("fill",dl.x1,dl.y1,dotnewsize)
    love.graphics.circle("fill",dl.x2,dl.y2,dotnewsize)
  end
  
  if pscores[1] then
    love.graphics.setColor(pcolors[1])
    love.graphics.printf(pletters[1]..pscores[1], 0, 0, _Width, "left")
  end
  
  if pscores[2] then
    love.graphics.setColor(pcolors[2])
    love.graphics.printf(pletters[2]..pscores[2], 0, 0, _Width, "right")
  end
  
  if pscores[3] then
    love.graphics.setColor(pcolors[3])
    love.graphics.printf(pletters[3]..pscores[3], 0, _Height - gh, _Width, "left")
  end
  
  if pscores[4] then
    love.graphics.setColor(pcolors[4])
    love.graphics.printf(pletters[4]..pscores[4], 0, _Height - gh, _Width, "right")
  end
end

function love.update(dt)
  --Update the ripples
  for k, r in ipairs(ripples) do
    r:update(dt)
  end
end

local tid --TouchID

--Single touch to mouse connection
function love.touchpressed(id,x,y,dx,dy,p)
  if not tid then
    tid = id
    love.mousepressed(x,y, 1, false)
  end
end

function love.touchmoved(id,x,y,dx,dy,p)
  if tid and tid == id then
    love.mousemoved(x,y,dx,dy)
  end
end

function love.touchreleased(id,x,y,dx,dy,p)
  if tid and tid == id then
    love.mousereleased(x,y, 1, false)
    tid = nil
  end
end

--Mouse Code
function love.mousepressed(x,y, b, istouch)
  if istouch then return end
  
  local cx, cy = whereInGrid(x,y, dotsgrid)
  if cx then
    local cpx, cpy = dgx + (cx-1)*dgs, dgy + (cy-1)*dgs --Cell Pos
    dl = { x1=cpx, y1=cpy, x2=cpx, y2=cpy, cx=cx, cy=cy, col = pcolors[pturns[curturn]]}
  end
end

function love.mousemoved(x,y, dx,dy, istouch)
  if istouch then return end
  local cx, cy = whereInGrid(x,y, dotsgrid)
  if cx and dl then
    cx = math.min(math.max(dl.cx-1,cx),dl.cx+1)
    cy = math.min(math.max(dl.cy-1,cy),dl.cy+1)
    if math.abs(dl.cx-cx) == math.abs(dl.cy-cy) then cy = dl.cy end
    local cpx, cpy = dgx + (cx-1)*dgs, dgy + (cy-1)*dgs --Cell Pos
    dl.x2 = cpx
    dl.y2 = cpy
  elseif dl then
    --Hide
    dl.x2, dl.y2 = dl.x1, dl.y1
  end
end

local function checkNewBox(horiz,x,y)
  local flag = false
  if horiz then
    --State 1
    --[[
    O--O
    |  | <--
    X==O
    .  .
    O..O
    ]]
    if y > 1 and dgdata[x][y-1].h and dgdata[x][y-1].v and x < dbw and dgdata[x+1][y-1].v then
      local pid = dgdata[x][y].h
      pscores[pid] = pscores[pid] + 1 --Count the score !!
      local dotsize = dotsize/2
      local nr = material.ripple.box( dgx+(x-1)*dgs + dotsize*3,dgy+(y-2)*dgs + dotsize*3, dgs - dotsize*6,dgs - dotsize*6, 0.25)
      nr:start(dgx+(x-1)*dgs + dgs/2,dgy+(y-2)*dgs + dgs/2, unpack(pcolors[pid]))
      table.insert(ripples,nr)
      flag = true
    end
    
    --State 2
    --[[
    O..O
    .  .
    X==O
    |  | <--
    O--O
    ]]
    if y < dbh and dgdata[x][y+1].h and dgdata[x][y].v and x < dbw and dgdata[x+1][y].v then
      local pid = dgdata[x][y].h
      pscores[pid] = pscores[pid] + 1 --Count the score !!
      local dotsize = dotsize/2
      local nr = material.ripple.box( dgx+(x-1)*dgs + dotsize*3,dgy+(y-1)*dgs + dotsize*3, dgs - dotsize*6,dgs - dotsize*6, 0.25)
      nr:start(dgx+(x-1)*dgs + dgs/2,dgy+(y-1)*dgs + dgs/2, unpack(pcolors[pid]))
      table.insert(ripples,nr)
      flag = true
    end
  else
    --State 1
    --[[
    O..X--O
    .  :  | <--
    O..O--O
    ]]
    if dgdata[x][y].h and x < dbw and dgdata[x+1][y].v and y < dbh and dgdata[x][y+1].h then
      local pid = dgdata[x][y].v
      pscores[pid] = pscores[pid] + 1 --Count the score !!
      local dotsize = dotsize/2
      local nr = material.ripple.box( dgx+(x-1)*dgs + dotsize*3,dgy+(y-1)*dgs + dotsize*3, dgs - dotsize*6,dgs - dotsize*6, 0.25)
      nr:start(dgx+(x-1)*dgs + dgs/2,dgy+(y-1)*dgs + dgs/2, unpack(pcolors[pid]))
      table.insert(ripples,nr)
      flag = true
    end
    
    --State 2
    --[[
        O--X..O
    --> |  :  .
        O--O..O
    ]]
    if x > 1 and dgdata[x-1][y].v and dgdata[x-1][y].h and y < dbh and dgdata[x-1][y+1].h then
      local pid = dgdata[x][y].v
      pscores[pid] = pscores[pid] + 1 --Count the score !!
      local dotsize = dotsize/2
      local nr = material.ripple.box( dgx+(x-2)*dgs + dotsize*3,dgy+(y-1)*dgs + dotsize*3, dgs - dotsize*6,dgs - dotsize*6, 0.25)
      nr:start(dgx+(x-2)*dgs + dgs/2,dgy+(y-1)*dgs + dgs/2, unpack(pcolors[pid]))
      table.insert(ripples,nr)
      flag = true
    end
  end
  return flag
end

function love.mousereleased(x,y, b, istouch)
  if istouch then return end
  local cx, cy = whereInGrid(x,y, dotsgrid)
  if cx and dl then
    cx = math.min(math.max(dl.cx-1,cx),dl.cx+1)
    cy = math.min(math.max(dl.cy-1,cy),dl.cy+1)
    if math.abs(dl.cx-cx) == math.abs(dl.cy-cy) then cy = dl.cy end
    local cpx, cpy = dgx + (cx-1)*dgs, dgy + (cy-1)*dgs --Cell Pos
    dl.x2 = cpx
    dl.y2 = cpy
    if dl.cx == cx and dl.cy == cy then dl = nil return end --It's on the same dot
    --Do new game line here !
    local flag = false
    if dl.cy-cy == 0 then --It's horizental
    
      if dl.cx-cx > 0 then --To Left
        if dgdata[cx][cy].h then dl = nil return end --Trying to override an existing line
        dgdata[cx][cy].h = pturns[curturn] linesNum = linesNum + 1
        flag = flag or checkNewBox(true,cx,cy)
      else --To Right
        if dgdata[dl.cx][cy].h then dl = nil return end --Trying to override an existing line
        dgdata[dl.cx][cy].h = pturns[curturn] linesNum = linesNum + 1
        flag = flag or checkNewBox(true,dl.cx,cy)
      end
      
    else --It's vertical
    
      if dl.cy-cy > 0 then --To Top
        if dgdata[cx][cy].v then dl = nil return end --Trying to override an existing line
        dgdata[cx][cy].v = pturns[curturn] linesNum = linesNum + 1
        flag = flag or checkNewBox(false,cx,cy)
      else --To Bottom
        if dgdata[cx][dl.cy].v then dl = nil return end --Trying to override an existing line
        dgdata[cx][dl.cy].v = pturns[curturn] linesNum = linesNum + 1
        flag = flag or checkNewBox(false,cx,dl.cy)
      end
      
    end
    
    if not flag then
      curturn = curturn+1
      if curturn > #pturns then curturn = 1 end
      gtt = pnames[pturns[curturn]].."'s Turn"
    end
    
    dl = nil
  elseif dl then
    dl = nil --Cancel
  end
end