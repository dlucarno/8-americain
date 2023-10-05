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
local elapsed_time = 0
local mousePosX = 0
local mousePosY = 0
local playerTurn = true
local startMoveX = 0
local startMoveY = 0
local skipTurn = false
local drawTwo = false
local reverseOrder = false
local cardImages = {}

local centralCard = nil
local previousCentralCard = nil

for i, cardName in ipairs(imagePaths.cards) do
  cardImages[i] = {name = cardName, image = love.graphics.newImage("assets/img/cards-master/" .. cardName .. ".png")}
end

local cardYes = {}

for i, cardName in ipairs(imagePaths.cards) do
  cardYes[i] = {name = cardName, image = love.graphics.newImage("assets/img/cards-master/" .. cardName .. ".png")}
end

local function drawCard(card, x, y)
  love.graphics.draw(card.image, x, y, 0, cardWidth, cardHeight)
end

function playAgain()
  -- Donner un autre tour au joueur actuel
  currentPlayer = currentPlayer - 1
end


function skipTurn()
  -- Ajouter 1 au nombre de joueurs à sauter
  skipCount = skipCount + 1
end


function drawCards(n)
  for i = 1, n do
    -- Piocher une carte au hasard
    local randomIndex = math.random(1, #deck)
    local card = table.remove(deck, randomIndex)
    -- Ajouter la carte à la main du joueur suivant
    table.insert(nextPlayer.hand, card)
  end
end

function table.indexOf(t, object)
  for i, value in ipairs(t) do
      if value == object then
          return i
      end
  end
  return nil
end

function getCardIndexInGeneralList(card)
  local cardName = card.name -- Obtenez le nom de la carte
  -- Obtenez l'index de la carte dans la liste générale
  local cardIndexInGeneralList = table.indexOf(imagePaths.cards, cardName)
  return cardIndexInGeneralList
end

function jouerOrdinateur()
  -- Parcourir la main de l'ordinateur pour trouver une carte jouable
  for i, card in ipairs(opponentHand) do
    local cardIndexInGeneralList = getCardIndexInGeneralList(card)
    print("Carte Ordinateur : " .. imagePaths.cards[cardIndexInGeneralList])
    if jouerCarte(cardIndexInGeneralList) then
      -- L'ordinateur joue cette carte
      centralCard = card
      centralCardIndex = table.indexOf(imagePaths.cards, card.name)
      love.audio.play(cardPlayedSound)
      -- Supprimer la carte de la main de l'ordinateur
      table.remove(opponentHand, i)
      return
    end
  end
  -- Si aucune carte jouable n'a été trouvée, l'ordinateur pioche une carte
  local randomIndex = math.random(1, #cardImages)
  local card = cardImages[randomIndex]
  -- Ajouter la carte à la main de l'ordinateur
  table.insert(opponentHand, card)
  love.audio.play(cardAddSound)
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
  love.graphics.draw(cardImages[randomIndex].image, cardCenterX, cardCenterY, 0, 0.27, 0.27)
end


function jouerCarte(cardIndex)
  local cardName = imagePaths.cards[cardIndex]
  local cardValue = getValueFromCardName(cardName)
  local cardColor = getColorFromCardName(cardName)
  local centralCardName = imagePaths.cards[centralCardIndex]
  local centralCardValue = getValueFromCardName(centralCardName)
  local centralCardColor = getColorFromCardName(centralCardName)

  -- Si la carte est un 8, le joueur suivant saute son tour
  if cardValue == 8 then
    skipTurn = true
    return true
  -- Si la carte est un 2, le joueur suivant doit piocher 2 cartes
  elseif cardValue == 2 then
    drawTwo = true
    return true
  -- Si la carte est un valet, le joueur change la couleur de la pile de défausse
  
  -- Si la carte est un as, le sens du jeu est inversé
  elseif cardValue == 1 then
    reverseOrder = not reverseOrder
    return true
  -- Si la carte a la même couleur ou la même valeur que la carte du dessus de la pile de défausse, elle peut être jouée
  elseif cardColor == centralCardColor or cardValue == centralCardValue then
    return true
  else
    return false
  end
end


function love.load()
  love.window.setMode(1050,680, {resizable=false, vsync=false, minwidth=400, minheight=300})
  love.window.setTitle("Lucarno - Les 8 Américains")
  love.graphics.setBackgroundColor(255,255,255)
  centralCardIndex = love.math.random(1, #cardYes)
  centralCard = cardImages[centralCardIndex]
  playerHasPlayed = false
  canPlay = true
  cardAdd = false
  errorSound = love.audio.newSource("assets/sounds/error.wav", "static")
  cardPlayedSound = love.audio.newSource("assets/sounds/playcard.wav", "static")
  cardAddSound = love.audio.newSource("assets/sounds/draw.wav", "static")
  backCardImage = love.graphics.newImage("assets/img/cards-master/back.jpg")
  playerHand, indexCartesDistribuees = distribuerCartes(cardImages)


  cardCoords = {}
  for i, card in ipairs(playerHand) do
    local x = cartePX + (i-1) * cardSpacing
    local y = cartePY
    love.graphics.draw(card.image, x, y, 0, 0.27, 0.27)
    cardCoords[i] = {x = x, y = y, width = card.image:getWidth() * 0.27, height = card.image:getHeight() * 0.27}
  end

  
  opponentHand = {}
  for i = 1, 8 do
    local randomIndex = math.random(1, #cardImages)
    opponentHand[i] = cardImages[randomIndex]
  end
 

  resteCartes = {}
  for i = 1, 8 do
    resteCartes[i] = love.graphics.newImage("assets/img/cards-master/back.jpg")
  end
  
end

function drawLeftCard(card)
  love.graphics.draw(card.image, 800, 340, 0, 0.27, 0.27)
end

function love.draw()
  local bgPath= "assets/img/logo.png"
  bg = love.graphics.newImage(bgPath)
  love.graphics.draw(bg, 165, -48)
   
  if centralCard then
    love.graphics.draw(centralCard.image, cardCenterX, cardCenterY, 0, 0.27, 0.27)
  end
  
  for i = 1, #opponentHand do
    love.graphics.draw(backCardImage, 340 + (i-1) * 40 , 20, 0, 0.15, 0.15)
  end

   for i, card in ipairs(playerHand) do
     love.graphics.draw(card.image, cartePX + (i-1) * cardSpacing, cartePY, 0, 0.27, 0.27)
    end
 
   for i, card in ipairs(resteCartes) do
      love.graphics.draw(card, 5 + (i-1) * 2, 250, 0, 0.18, 0.18)
   end
-- carte précédente de l'adversaire
   love.graphics.draw(cardYes[1].image, 880 , 20, 0, 0.27, 0.27)
-- carte précédente du joueur
  if previousCentralCard then
     love.graphics.draw(centralCard.image, 880, cartePY - 20, 0, 0.27, 0.27)
   end
 
end

function love.update(dt)
  elapsed_time = elapsed_time + dt

  -- Si plus de 2 secondes se sont écoulées depuis le dernier tour du joueur
  if not playerTurn and elapsed_time >= 2 then
    jouerOrdinateur()
    playerTurn = true -- C'est maintenant le tour du joueur
    elapsed_time = 0 
  end
  
end
function love.mousepressed(x, y, button, istouch)
  if button == 1 and playerTurn then
    -- Vérifier si le clic a eu lieu sur la pile de cartes de dos
    if x >= 5 and x <= 180 and y >= 250 and y <= 480 then
      -- Ajouter une carte aléatoire à playerHand
      local randomIndex = math.random(1, #cardImages)
      table.insert(playerHand, cardImages[randomIndex])
      love.audio.play(cardAddSound)
      playerTurn = false -- C'est maintenant le tour de l'ordinateur
      elapsed_time = 0
    end

    -- Vérifier si le clic a eu lieu sur une carte de la main du joueur
    local cardLarg = 40 -- Largeur 
    for i, card in ipairs(playerHand) do
      local cardLeft = 340 + (i-1) * cardSpacing
      local cardRight = cardLeft + cardLarg
      local cardTop = cartePY
      local cardBottom = cardTop + card.image:getHeight() * 0.27
      if i == #playerHand then
        cardRight = cardLeft + card.image:getWidth() * 0.27
      end

      if x >= cardLeft and x <= cardRight and y >= cardTop and y <= cardBottom then
        local selectedCard = playerHand[i] -- Obtenez la carte sélectionnée de la main du joueur
        local cardIndexInGeneralList = getCardIndexInGeneralList(selectedCard)
        print("Carte sélectionnée : " .. imagePaths.cards[cardIndexInGeneralList])
        if jouerCarte(cardIndexInGeneralList) then
          -- Mettre à jour la carte centrale
          centralCard = playerHand[i]
          -- Supprimer la carte de la main du joueur
          table.remove(playerHand, i)
          -- Afficher la carte au centre
          centralCardIndex = i
          love.audio.play(cardPlayedSound)
          playerTurn = false -- C'est maintenant le tour de l'ordinateur
          elapsed_time = 0
          break
        else
          love.audio.play(errorSound)
        end
        
      end
    end
  else
    love.audio.play(errorSound)
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  if x >= 5 and x <= 180 and y >= 250 and y <= 480 then
    love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
  else
    love.mouse.setCursor()
  end
end