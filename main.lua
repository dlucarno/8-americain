io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local imagePaths = {
  
  icon = "assets/img/cards.png",
  cards =  {
    "2_of_clubs", "2_of_diamonds", "2_of_hearts", "2_of_spades",
    "3_of_clubs", "3_of_diamonds", "3_of_hearts", "3_of_spades",
    "4_of_clubs", "4_of_diamonds", "4_of_hearts", "4_of_spades",
    "5_of_clubs", "5_of_diamonds", "5_of_hearts", "5_of_spades",
    "6_of_clubs", "6_of_diamonds", "6_of_hearts", "6_of_spades",
    "7_of_clubs", "7_of_diamonds", "7_of_hearts", "7_of_spades",
    "8_of_clubs", "8_of_diamonds", "8_of_hearts", "8_of_spades",
    "9_of_clubs", "9_of_diamonds", "9_of_hearts", "9_of_spades",
    "10_of_clubs", "10_of_diamonds", "10_of_hearts", "10_of_spades",
    "ace_of_clubs", "ace_of_diamonds", "ace_of_hearts", "ace_of_spades2",
    "jack_of_clubs2", "jack_of_diamonds2", "jack_of_hearts2", "jack_of_spades2",
    "king_of_clubs2", "king_of_diamonds2", "king_of_hearts2", "king_of_spades2",
    "queen_of_clubs2", "queen_of_diamonds2", "queen_of_hearts2", "queen_of_spades2",
    "red_joker", "black_joker"
  },
  back = "assets/img/cards-master/back.jpg"
}



local cartePX = 340
local cartePY = 480
local cardWidth = 0.30
local cardHeight = 0.30
local cardSpacing = 40
local cardCenterX = 490
local cardCenterY = 240
local cartePY = 470
local cartePX = 340

local offsetX = 0 -- screen to world offset
local offsetY = 0

local mousePosX = 0
local mousePosY = 0

local startMoveX = 0
local startMoveY = 0



local cardImages = {}

for i, cardName in ipairs(imagePaths.cards) do
  cardImages[i] = love.graphics.newImage("assets/img/cards-master/" .. cardName .. ".png")
end



local function drawCard(card, x, y)
  love.graphics.draw(card, x, y, 0, cardWidth, cardHeight)
end




function distribuerCartes(lesCartes)
  math.randomseed(os.time())
  math.random(); math.random(); math.random()

  local function retirerCarte(index)
      local carte = table.remove(lesCartes, index)
      return carte
  end

  local cartesDistribuees = {}

  for i = 1, 8 do
      local index = math.random(1, #lesCartes)
      cartesDistribuees[i] = retirerCarte(index)
  end

  return cartesDistribuees
end





function love.load()
  
  love.window.setMode(1050,680, {resizable=true, vsync=false, minwidth=400, minheight=300})
  love.window.setTitle("Lucarno - Les 8 Américains")
  love.graphics.setBackgroundColor(255,255,255)

  playerHand = distribuerCartes(cardImages)
  opponentHand = {}
  for i = 1, 8 do
    opponentHand[i] = love.graphics.newImage("assets/img/cards-master/back.jpg")
  end
 

  resteCartes = {}
  for i = 1, 8 do
    resteCartes[i] = love.graphics.newImage("assets/img/cards-master/back.jpg")
  end
  
end


function love.draw()
  local bgPath= "assets/img/logo.png"
  bg = love.graphics.newImage(bgPath)
  love.graphics.draw(bg, 165, -48)

  local randomIndex = math.random(1, 32)
  love.graphics.draw(cardImages[randomIndex], cardCenterX, cardCenterY, 0, 0.27, 0.27)

  for i, card in ipairs(opponentHand) do
    love.graphics.draw(card, 340 + (i-1) * 40 , 20, 0, 0.15, 0.15)
  end

  
   for i, card in ipairs(playerHand) do
     love.graphics.draw(card, cartePX + (i-1) * cardSpacing, cartePY, 0, 0.27, 0.27)
   end
 
 
   for i, card in ipairs(resteCartes) do
    love.graphics.draw(card, 5 + (i-1) * 2, 250, 0, 0.18, 0.18)
   end

  
 
 
end


 
  

 
 