io.stdout:setvbuf('no')

love.graphics.setDefaultFilter("nearest")

if arg[#arg] == "-debug" then 
  require("mobdebug").start() 
end

local imagePaths = {
  bg = "assets/img/logo.png",
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

local images = {}
local cards = {}
local playerHand = {}
local opponentHand = {}

local cardWidth = 0.30
local cardHeight = 0.30
local cardSpacing = 40
local cardCenterX = 490
local cardCenterY = 240
local cartePY = 460
local cartePX = 340

local function loadImages()
  for key, path in pairs(imagePaths) do
    if type(path) == "string" then
      images[key] = love.graphics.newImage(path)
    elseif type(path) == "table" then
      images[key] = {}
      for i, card in ipairs(path) do
        images[key][i] = love.graphics.newImage("assets/img/cards-master/" .. card .. ".png")
      end
    end
  end
end

local function createDeck()
  for i, card in ipairs(images.cards) do
    cards[i] = images.cards[i]
  end
end

local function drawCard(card, x, y)
  love.graphics.draw(card, x, y, 0, cardWidth, cardHeight)
end

function love.load()
  love.window.setMode(1050, 680, {resizable=true, vsync=false, minwidth=400, minheight=300})
  love.window.setTitle("Lucarno - Les 8 Américains")
  love.graphics.setBackgroundColor(255, 255, 255)
  loadImages()
  createDeck()

  -- Distribuer les cartes
  for i = 1, 8 do
    local randomIndex = math.random(1, #cards)
    playerHand[i] = table.remove(cards, randomIndex)

    randomIndex = math.random(1, #cards)
    opponentHand[i] = table.remove(cards, randomIndex)
  end

end

function love.draw()
  love.graphics.draw(images.bg, 165, -48)

  for i, card in ipairs(playerHand) do
    drawCard(card, cartePX + (i-1) * cardSpacing, cartePY)
  end

  drawCard(cards[1], cardCenterX, cardCenterY)

  for i, card in ipairs(opponentHand) do
    drawCard(card, cardCenterX + (i-1) * cardSpacing, cardCenterY - 100)
  end
end

function catchMousePosBeforeMove()
  startMoveX = mousePosX
  startMoveY = mousePosY
end

function love.update()
  mousePosX = love.mouse.getX()
  mousePosY = love.mouse.getY()
  
  if love.mouse.isDown(1) then
    offsetX = offsetX + (mousePosX - startMoveX)
    offsetY = offsetY + (mousePosY - startMoveY) 
    startMoveX = mousePosX
    startMoveY = mousePosY
  end
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    catchMousePosBeforeMove()
  end
end
