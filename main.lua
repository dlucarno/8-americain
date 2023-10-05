io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")

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
    "ace_of_clubs", "ace_of_diamonds", "ace_of_hearts", "ace_of_spades",
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
local tourJoueur = true
local offsetX = 0
local offsetY = 0

local mousePosX = 0
local mousePosY = 0

local startMoveX = 0
local startMoveY = 0

local cardImages = {}

local centralCard = nil

for i, cardName in ipairs(imagePaths.cards) do
  cardImages[i] = love.graphics.newImage("assets/img/cards-master/" .. cardName .. ".png")
end

local cardYes = {}

for i, cardName in ipairs(imagePaths.cards) do
  cardYes[i] = love.graphics.newImage("assets/img/cards-master/" .. cardName .. ".png")
end

local function drawCard(card, x, y)
  love.graphics.draw(card, x, y, 0, cardWidth, cardHeight)
end

function jouerOrdinateur()
  for i, card in ipairs(opponentHand) do
    local cardName = imagePaths.cards[i]
    local cardColor = getColorFromCardName(cardName)
    local cardValue = getValueFromCardName(cardName)

    local centralCardName = imagePaths.cards[centralCardIndex]
    local centralCardColor = getColorFromCardName(centralCardName)
    local centralCardValue = getValueFromCardName(centralCardName)

    if cardColor == centralCardColor or cardValue == centralCardValue then
      -- L'ordinateur joue cette carte
      centralCard = opponentHand[i]
      table.remove(opponentHand, i)
      centralCardIndex = i
      return
    end
  end

  -- Si l'ordinateur ne peut pas jouer, il pioche une carte
  local randomIndex = math.random(1, #cardImages)
  table.insert(opponentHand, cardImages[randomIndex])
end


function changeColor()
  -- Demander à l'utilisateur de choisir une couleur
  print("Choisissez une couleur : clubs, diamonds, hearts, spades")
  local newColor = io.read()

  -- Vérifier que la couleur choisie est valide
  if newColor == "clubs" or newColor == "diamonds" or newColor == "hearts" or newColor == "spades" then
    -- Changer la couleur de la carte centrale
    local centralCardName = imagePaths.cards[centralCardIndex]
    local value = getValueFromCardName(centralCardName)
    centralCardName = value .. "_of_" .. newColor
    centralCardIndex = table.indexOf(imagePaths.cards, centralCardName)
    centralCard = cardImages[centralCardIndex]
  else
    print("Couleur invalide. Veuillez choisir parmi : clubs, diamonds, hearts, spades")
    changeColor()
  end
end
function distribuerCartes(lesCartes)
  math.randomseed(os.time())
  math.random(); math.random(); math.random()

  local function retirerCarte(index)
      local carte = table.remove(lesCartes, index)
      return carte
  end

  local cartesDistribuees = {}
  local indexCartesDistribuees = {}

  for i = 1, 8 do
      local index = math.random(1, #lesCartes)
      cartesDistribuees[i] = retirerCarte(index)
      indexCartesDistribuees[i] = index
  end

  return cartesDistribuees, indexCartesDistribuees
end

function getPlayerCardIndex(cardIndex, cardList)
  for i, index in ipairs(cardList) do
      if cardIndex == index then
          return i
      end
  end
  return nil
end

function getColorFromCardName(cardName)
  return cardName:match("of_(%w+)")
end

function getValueFromCardName(cardName)
  local value = cardName:match("(%w+)_of_")
  if value == "jack" then
    return 11
  elseif value == "queen" then
    return 12
  elseif value == "king" then
    return 13
  elseif value == "ace" then
    return 1
  else
    return tonumber(value)
  end
end

function drawCentralCard()
  math.random()
  math.random(); math.random(); math.random()
  local randomIndex = math.random(1, #cardImages)
  love.graphics.draw(cardImages[randomIndex], cardCenterX, cardCenterY, 0, 0.27, 0.27)
end

function love.load()
  love.window.setMode(1050,680, {resizable=false, vsync=false, minwidth=400, minheight=300})
  love.window.setTitle("Lucarno - Les 8 Américains")
  love.graphics.setBackgroundColor(255,255,255)
  centralCardIndex = love.math.random(1, #cardYes)
  centralCard = cardImages[centralCardIndex]

  playerHand, indexCartesDistribuees = distribuerCartes(cardImages)

  opponentHand = {}
  for i = 1, 8 do
    opponentHand[i] = love.graphics.newImage("assets/img/cards-master/back.jpg")
  end
 

  resteCartes = {}
  for i = 1, 8 do
    resteCartes[i] = love.graphics.newImage("assets/img/cards-master/back.jpg")
  end
  
end

function drawLeftCard(card)
  love.graphics.draw(card, 800, 340, 0, 0.27, 0.27)
end

function love.draw()
  local bgPath= "assets/img/logo.png"
  bg = love.graphics.newImage(bgPath)
  love.graphics.draw(bg, 165, -48)
   
  if centralCard then
    love.graphics.draw(centralCard, cardCenterX, cardCenterY, 0, 0.27, 0.27)
  end
  
  for i, card in ipairs(opponentHand) do
    love.graphics.draw(card, 340 + (i-1) * 40 , 20, 0, 0.15, 0.15)
  end

   for i, card in ipairs(playerHand) do
     love.graphics.draw(card, cartePX + (i-1) * cardSpacing, cartePY, 0, 0.27, 0.27)
    end
 
   for i, card in ipairs(resteCartes) do
      love.graphics.draw(card, 5 + (i-1) * 2, 250, 0, 0.18, 0.18)
   end
-- carte précédente de l'adversaire
   love.graphics.draw(cardYes[1], 880 , 20, 0, 0.27, 0.27)
-- carte précédente du joueur
  if centralCard then
     love.graphics.draw(centralCard, 880, cartePY - 20, 0, 0.27, 0.27)
   end
 
end

function love.update(dt)
  function love.mousepressed(x, y, button, istouch)
    if button == 1 and tourJoueur then
      -- Vérifier si le clic a eu lieu sur la pile de cartes de dos
      if x >= 5 and x <= 180 and y >= 250 and y <= 480 then
        -- Ajouter une carte aléatoire à playerHand
        local randomIndex = math.random(1, #cardImages)
        table.insert(playerHand, cardImages[randomIndex])
      end

      -- Vérifier si le clic a eu lieu sur une carte de la main du joueur
      local cardLarg = 40 -- Largeur 
      for i, card in ipairs(playerHand) do
        local cardLeft = 340 + (i-1) * cardSpacing
        local cardRight = cardLeft + cardLarg
        local cardTop = cartePY
        local cardBottom = cardTop + card:getHeight() * 0.27
        if i == #playerHand then
          cardRight = cardLeft + card:getWidth() * 0.27
        end

        if x >= cardLeft and x <= cardRight and y >= cardTop and y <= cardBottom then
          local cardName = imagePaths.cards[i]
          local cardColor = getColorFromCardName(cardName)
          local cardValue = getValueFromCardName(cardName)

          local centralCardName = imagePaths.cards[centralCardIndex]
          local centralCardColor = getColorFromCardName(centralCardName)
          local centralCardValue = getValueFromCardName(centralCardName)

          -- Vérifier si la carte sélectionnée peut être jouée
          if cardColor == centralCardColor or cardValue == centralCardValue then
            -- Gérer les effets spéciaux des cartes
            if cardValue == 8 then
             
            elseif cardValue == 2 then
             
            elseif cardValue == "jack" then
              changeColor() -- Vous devez définir cette fonction
            elseif cardValue == 7 then
             
            end

            -- Mettre à jour la carte centrale
            centralCard = playerHand[i]
            -- Supprimer la carte de la main du joueur
            table.remove(playerHand, i)
            -- Afficher la carte au centre
            centralCardIndex = i
            break
          else
            -- Afficher un message d'erreur
            print("Vous ne pouvez pas jouer cette carte.")
          end
        end
      end
    end
  end
  
  function love.mousemoved(x, y, dx, dy, istouch)
    if x >= 5 and x <= 180 and y >= 250 and y <= 480 then
      love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
    else
      love.mouse.setCursor()
    end
  end
end