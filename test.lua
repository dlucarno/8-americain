io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

bg = love.graphics.newImage("assets/img/logo.png")
local icon = love.graphics.newImage("assets/img/cards.png")
local card1 = love.graphics.newImage("assets/img/cards-master/2_of_clubs.png")
local card2 = love.graphics.newImage("assets/img/cards-master/2_of_diamonds.png")
local card3 = love.graphics.newImage("assets/img/cards-master/2_of_hearts.png")
local card4 = love.graphics.newImage("assets/img/cards-master/2_of_spades.png")
local card5 = love.graphics.newImage("assets/img/cards-master/3_of_clubs.png")
local card6 = love.graphics.newImage("assets/img/cards-master/3_of_diamonds.png")
local card7 = love.graphics.newImage("assets/img/cards-master/3_of_hearts.png")
local card8 = love.graphics.newImage("assets/img/cards-master/3_of_spades.png")
local card9 = love.graphics.newImage("assets/img/cards-master/4_of_clubs.png")
local card10 = love.graphics.newImage("assets/img/cards-master/4_of_diamonds.png")
local card11 = love.graphics.newImage("assets/img/cards-master/4_of_hearts.png")
local card12 = love.graphics.newImage("assets/img/cards-master/4_of_spades.png")
local card13 = love.graphics.newImage("assets/img/cards-master/5_of_clubs.png")
local card14 = love.graphics.newImage("assets/img/cards-master/5_of_diamonds.png")
local card15 = love.graphics.newImage("assets/img/cards-master/5_of_hearts.png")
local card16 = love.graphics.newImage("assets/img/cards-master/5_of_spades.png")
local card17 = love.graphics.newImage("assets/img/cards-master/6_of_clubs.png")
local card18 = love.graphics.newImage("assets/img/cards-master/6_of_diamonds.png")
local card19 = love.graphics.newImage("assets/img/cards-master/6_of_hearts.png")
local card20 = love.graphics.newImage("assets/img/cards-master/6_of_spades.png")
local card21 = love.graphics.newImage("assets/img/cards-master/7_of_clubs.png")
local card22 = love.graphics.newImage("assets/img/cards-master/7_of_diamonds.png")
local card23 = love.graphics.newImage("assets/img/cards-master/7_of_hearts.png")
local card24 = love.graphics.newImage("assets/img/cards-master/7_of_spades.png")
local card25 = love.graphics.newImage("assets/img/cards-master/8_of_clubs.png")
local card26 = love.graphics.newImage("assets/img/cards-master/8_of_diamonds.png")
local card27 = love.graphics.newImage("assets/img/cards-master/8_of_hearts.png")
local card28 = love.graphics.newImage("assets/img/cards-master/8_of_spades.png")
local card29 = love.graphics.newImage("assets/img/cards-master/9_of_clubs.png")
local card30 = love.graphics.newImage("assets/img/cards-master/9_of_diamonds.png")
local card31 = love.graphics.newImage("assets/img/cards-master/9_of_hearts.png")
local card32 = love.graphics.newImage("assets/img/cards-master/9_of_spades.png")
local card33 = love.graphics.newImage("assets/img/cards-master/10_of_clubs.png")
local card34 = love.graphics.newImage("assets/img/cards-master/10_of_diamonds.png")
local card35 = love.graphics.newImage("assets/img/cards-master/10_of_hearts.png")
local card36 = love.graphics.newImage("assets/img/cards-master/10_of_spades.png")
local card37 = love.graphics.newImage("assets/img/cards-master/ace_of_clubs.png")
local card38 = love.graphics.newImage("assets/img/cards-master/ace_of_diamonds.png")
local card39 = love.graphics.newImage("assets/img/cards-master/ace_of_hearts.png")
local card40 = love.graphics.newImage("assets/img/cards-master/ace_of_spades2.png")
local card41 = love.graphics.newImage("assets/img/cards-master/jack_of_clubs2.png")
local card42 = love.graphics.newImage("assets/img/cards-master/jack_of_diamonds2.png")
local card43 = love.graphics.newImage("assets/img/cards-master/jack_of_hearts2.png")
local card44 = love.graphics.newImage("assets/img/cards-master/jack_of_spades2.png")
local card45 = love.graphics.newImage("assets/img/cards-master/king_of_clubs2.png")
local card46 = love.graphics.newImage("assets/img/cards-master/king_of_diamonds2.png")
local card47 = love.graphics.newImage("assets/img/cards-master/king_of_hearts2.png")
local card48 = love.graphics.newImage("assets/img/cards-master/king_of_spades2.png")
local card49 = love.graphics.newImage("assets/img/cards-master/queen_of_clubs2.png")
local card50 = love.graphics.newImage("assets/img/cards-master/queen_of_diamonds2.png")
local card51 = love.graphics.newImage("assets/img/cards-master/queen_of_hearts2.png")
local card52 = love.graphics.newImage("assets/img/cards-master/queen_of_spades2.png")
local card53 = love.graphics.newImage("assets/img/cards-master/red_joker.png")
local card54 = love.graphics.newImage("assets/img/cards-master/black_joker.png")
local arriereCarte = love.graphics.newImage("assets/img/cards-master/back.jpg")


local cartePX = 340
local cartePY = 480


local offsetX = 0 -- screen to world offset
local offsetY = 0

local mousePosX = 0
local mousePosY = 0

local startMoveX = 0
local startMoveY = 0




lesCartes = {card1, card2, card3, card4, card5, card6, card7, card8, card9, card10, card11, card12, card13, card14, card15, card16, card17, card18, card19, card20, card21, card22, card23, card24, card25, card26, card27, card28, card29, card30, card31, card32, card33, cars34, card35, card36, card37, card38, card39, card40, card41, card42, card43, card4, card45, card46, card47, card48, card49, card50, card51, card52, card53, card54}

math.randomseed(os.time())
math.random(); math.random(); math.random()
local x = math.random(1,54)
local y = math.random(1,53)
local z = math.random(1,52)
local t = math.random(1,51)
local w = math.random(1,50)
local k = math.random(1,49)
local l = math.random(1,48)
local m = math.random(1,47)
local n = math.random(1,46)

local lacarte1 = lesCartes[x]
table.remove(lesCartes, x)
local lacarte2 = lesCartes[y]
table.remove(lesCartes, x, y)
local lacarte3 = lesCartes[z]
table.remove(lesCartes, x, y, z)
local lacarte4 = lesCartes[t]
table.remove(lesCartes, x, y, z, t)
local lacarte5 = lesCartes[w]
table.remove(lesCartes, x, y, z, t, w)
local lacarte6 = lesCartes[k]
table.remove(lesCartes, x, y, z, t, w, k)
local lacarte7 = lesCartes[l]
table.remove(lesCartes, x, y, z, t, w, k, l)
local lacarte8 = lesCartes[m]
table.remove(lesCartes, x, y, z, t, w, k, l, m)
local lacarte9 = lesCartes[n]





function love.load()
  
  love.window.setMode(1050,680, {resizable=true, vsync=false, minwidth=400, minheight=300})
  love.window.setTitle("Lucarno - Les 8 Américains")
  love.graphics.setBackgroundColor(255,255,255)
  
end


function love.draw()
  
  love.graphics.draw (bg, 165, -48)
  love.graphics.draw (arriereCarte, 340, 0, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 380, 0, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 420, 0, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 460, 0, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 500, 0, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 540, 0, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 580, 0, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 620, 0, 0, 0.18, 0.18)
  
 
 local lamainJoueur = {love.graphics.draw (lacarte1, cartePX, cartePY, 0, 0.27, 0.27),
  love.graphics.draw (lacarte2, cartePX + 40, cartePY, 0, 0.27, 0.27),
  love.graphics.draw (lacarte3, cartePX + 80, cartePY, 0, 0.27, 0.27),
  love.graphics.draw (lacarte4, cartePX + 120, cartePY, 0, 0.27, 0.27),
  love.graphics.draw (lacarte5, cartePX + 160, cartePY, 0, 0.27, 0.27),
  love.graphics.draw (lacarte6, cartePX + 200, cartePY, 0, 0.27, 0.27),
  love.graphics.draw (lacarte7, cartePX + 240, cartePY, 0, 0.27, 0.27),
  love.graphics.draw (lacarte8, cartePX + 280, cartePY, 0, 0.27, 0.27)}
 
  love.graphics.draw (lacarte9, 490 + offsetX, 240 + offsetY, 0, 0.27, 0.27)
  



  love.graphics.draw (arriereCarte, 5, 250, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 10, 250, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 15, 250, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 20, 250, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 25, 250, 0, 0.18, 0.18)
  love.graphics.draw (arriereCarte, 30, 250, 0, 0.18, 0.18)
end


 function catchMousePosBeforeMove() --happens only once when btn is pressed
  startMoveX = mousePosX -- capture mouse pos when clicking before moving
  startMoveY = mousePosY
end 

function love.update()
  mousePosX = love.mouse.getX()
  mousePosY = love.mouse.getY()
  
  if love.mouse.isDown(1) then
    offsetX = offsetX + (mousePosX - startMoveX) -- modify the offset while moving
    offsetY = offsetY + (mousePosY - startMoveY) 
    startMoveX = mousePosX -- capture the mouse until the end of moving
    startMoveY = mousePosY
  end
  
end
  
  function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    catchMousePosBeforeMove() --happens only once when btn is pressed
  end
end
  

 
 