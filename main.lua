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
    "jack_of_clubs", "jack_of_diamonds", "jack_of_hearts", "jack_of_spades",
    "king_of_clubs", "king_of_diamonds", "king_of_hearts", "king_of_spades",
    "queen_of_clubs", "queen_of_diamonds", "queen_of_hearts", "queen_of_spades",
    "red_joker", "black_joker"
  },
  back = "assets/img/cards-master/back.jpg"
}
local cardDrawn = false
local asPlayed = false
local extraTurns = 0
local showRules = false
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
local hasPlayerPlayedFirstCard = false
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


function resetGame()
  -- Réinitialiser cardImages
  cardImages = {}
  for i, cardName in ipairs(imagePaths.cards) do
    cardImages[i] = {name = cardName, image = love.graphics.newImage("assets/img/cards-master/" .. cardName .. ".png")}
  end

  -- Redistribuer les cartes
  playerHand, _ = distribuerCartes(cardImages)
  opponentHand, _ = distribuerCartes(cardImages)

  -- Générer aléatoirement la carte centrale
  centralCardIndex = math.random(#cardImages)
  centralCard = cardImages[centralCardIndex]

  -- Supprimer la carte centrale de cardImages
  table.remove(cardImages, centralCardIndex)

  cartePioche = cardImages
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
  for i = #opponentHand, 1, -1 do
    local selectedCard = opponentHand[i]
    local cardIndexInGeneralList = getCardIndexInGeneralList(selectedCard)
    print("Carte Ordinateur : " .. imagePaths.cards[cardIndexInGeneralList])
    if jouerCarte(cardIndexInGeneralList) then
      -- L'ordinateur joue cette carte
      centralCard = selectedCard
      centralCardIndex = cardIndexInGeneralList
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
  table.remove(cardImages, randomIndex)
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

  for _, index in ipairs(indexCartesDistribuees) do
    table.remove(cardImages, index)
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
 
 if asPlayed and not cardDrawn then
    if cardValue ~= 1 then
      return false
    else
      -- Si un as est joué, le tour continue normalement et on réinitialise asPlayed
      asPlayed = false
      return true
    end
  end

  -- Si la carte jouée est un as
  if cardValue == 1 then
    asPlayed = true
  end

  -- Réinitialisez cardDrawn à false car une carte a été jouée
  cardDrawn = false

  
  if cardName == "red_joker" and (centralCardColor == "hearts" or centralCardColor == "diamonds") then
    return true
  elseif cardName == "black_joker" and (centralCardColor == "clubs" or centralCardColor == "spades") then
    return true
  elseif (cardColor == "hearts" or cardColor == "diamonds") and centralCardName == "red_joker" then
    return true
  elseif (cardColor == "clubs" or cardColor == "spades") and centralCardName == "black_joker" then
    return true
  end

  if cardValue == centralCardValue or cardColor == centralCardColor then
    if cardValue == 10 or cardName:match("^jack") or cardValue == 2 then
      extraTurns = extraTurns + 1
      elapsed_time = 0
      if cardValue == 2 then
        local recipient = playerTurn and "opponent" or "player"
        ajouterCartes(2, recipient)
      end
    end
    return true
  end

  -- Si la règle ci-dessus n'est pas respectée, la carte ne peut pas être jouée
  return false
end

function ajouterCartes(n, recipient)
  -- Vérifiez qui est le destinataire des cartes
  local hand = recipient == "player" and playerHand or opponentHand

  for i = 1, n do
    -- Sélectionner une carte aléatoire
    local randomIndex = math.random(1, #cardImages)
    local card = cardImages[randomIndex]
    -- Ajouter la carte à la main du destinataire
    table.insert(hand, card)
    -- Supprimer la carte de la liste des cartes disponibles
    table.remove(cardImages, randomIndex)
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
  cardDistributionSound = love.audio.newSource("assets/sounds/shuffle.wav", "static")
  errorSound = love.audio.newSource("assets/sounds/error.wav", "static")
  cardPlayedSound = love.audio.newSource("assets/sounds/playcard.wav", "static")
  cardAddSound = love.audio.newSource("assets/sounds/draw.wav", "static")
  backCardImage = love.graphics.newImage("assets/img/cards-master/back.jpg")
  playerHand, indexCartesDistribuees = distribuerCartes(cardImages)
  victoryFont = love.graphics.newFont(14)
  gameOver = false
  cardCoords = {}
  for i, card in ipairs(playerHand) do
    local x = cartePX + (i-1) * cardSpacing
    local y = cartePY
    love.graphics.draw(card.image, x, y, 0, 0.27, 0.27)
    cardCoords[i] = {x = x, y = y, width = card.image:getWidth() * 0.27, height = card.image:getHeight() * 0.27}
  end

  
  opponentHand = {}
  opponentHand = distribuerCartes(cardImages, 8)
 

  resteCartes = {}
  for i = 1, 8 do
    resteCartes[i] = love.graphics.newImage("assets/img/cards-master/back.jpg")
  end
  resetGame()
end

function drawVictoryPopup(message)
  -- Dessinez le fond de la fenêtre contextuelle
  love.graphics.setColor(0, 0, 0, 0.5) -- semi-transparent
  love.graphics.rectangle('fill', 100, 100, 680, 480)
  
  -- Dessinez le texte de victoire
  love.graphics.setColor(1, 1, 1) -- blanc
  love.graphics.setFont(victoryFont)
  love.graphics.printf(message, 120, 180, 580)
  love.graphics.setFont(victoryFont)
  
  -- Dessinez le bouton de fermeture
  love.graphics.rectangle('line', 650, 110, 50, 20)
  love.graphics.printf('Fermer', 655, 110, 40, 'center')
  gameOver = true
end

function love.draw()
  local bgPath= "assets/img/logo.png"
  bg = love.graphics.newImage(bgPath)
  love.graphics.draw(bg, 165, -48)
   
  if centralCard then
    love.graphics.draw(centralCard.image, cardCenterX, cardCenterY, 0, 0.27, 0.27)
  end
  
  for i = 1, #opponentHand do
    -- Si l'ordinateur n'a plus qu'une carte, la mettre en surbrillance et jouer un son
    if #opponentHand == 1 then
      love.graphics.setColor(1, 1, 0) -- couleur jaune
     
    else
      love.graphics.setColor(1, 1, 1) -- couleur blanche
    end
    love.graphics.draw(backCardImage, 340 + (i-1) * 40 , 20, 0, 0.15, 0.15)
  end

   -- Vérifier si le joueur a gagné
   if #playerHand == 0 then
    drawVictoryPopup("Félicitations, vous avez gagné !")
  end

  -- Vérifier si l'ordinateur a gagné
  if #opponentHand == 0 then
    drawVictoryPopup("Désolé, l'ordinateur a gagné !")
  end


   -- Dessiner la bulle d'information pour le joueur
   
   love.graphics.setColor(0, 0, 0) -- noir
   
    love.graphics.setColor(1, 1, 1) -- blanc
    for i, card in ipairs(playerHand) do
      -- Si le joueur n'a plus qu'une carte, la mettre en surbrillance et jouer un son
      if #playerHand == 1 then
        love.graphics.setColor(1, 1, 0) -- couleur jaune
        
      else
        love.graphics.setColor(1, 1, 1) -- couleur blanche
      end
      love.graphics.draw(card.image, cartePX + (i-1) * cardSpacing, cartePY, 0, 0.27, 0.27)
    end

     -- Dessiner la bulle d'information pour l'adversaire
  love.graphics.setColor(0, 0, 0) -- noir
  love.graphics.print("Ordinateur: " .. #opponentHand, 340, 20 + backCardImage:getHeight() * 0.15 + 10)
  love.graphics.setColor(1, 1, 1) -- blanc
  
   for i, card in ipairs(resteCartes) do
      love.graphics.draw(card, 5 + (i-1) * 2, 250, 0, 0.18, 0.18)
   end

-- carte précédente du joueur
  if previousCentralCard then
     love.graphics.draw(centralCard.image, 880, cartePY - 20, 0, 0.27, 0.27)
   end
 

 

   
  -- Bouton pour afficher les règles du jeu
  if love.mouse.getX() > 0 and love.mouse.getX() < 100 and love.mouse.getY() > 0 and love.mouse.getY() < 30 then
    love.graphics.setColor(1, 0, 0)
  else
    love.graphics.setColor(1, 1, 1)
  end
  local text = "Règle du jeu"
  local font = love.graphics.getFont()
  local textWidth = font:getWidth(text) * 1.7
  love.graphics.rectangle("fill", 0, 0, textWidth, 30)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Règle du jeu", 10, 10, 0, 1.5)
  love.graphics.setColor(1, 1, 1)
  -- Bouton pour redistribuer
  if love.mouse.getX() > 0 and love.mouse.getX() < 100 and love.mouse.getY() > 40 and love.mouse.getY() < 70 then
    love.graphics.setColor(1, 0, 0)
  else
    love.graphics.setColor(1, 1, 1)
  end
  local text = "Redistribuer"
  local font = love.graphics.getFont()
  local textWidth = font:getWidth(text) * 1.7
  love.graphics.rectangle("fill", 0, 40, textWidth, 30)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Redistribuer", 10, 50, 0, 1.5)
  love.graphics.setColor(1, 1, 1)
  -- Bouton pour quitter
  if love.mouse.getX() > 0 and love.mouse.getX() < 100 and love.mouse.getY() > 80 and love.mouse.getY() < 110 then
    love.graphics.setColor(1, 0, 0)
  else
    love.graphics.setColor(1, 1, 1)
  end
  local text = "Quitter"
  local font = love.graphics.getFont()
  local textWidth = font:getWidth(text) * 1.7
  love.graphics.rectangle("fill", 0, 80, textWidth, 30)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Quitter", 10, 90, 0, 1.5)
  love.graphics.setColor(1, 1, 1)



  if showRules then
    -- Dessinez le fond de la fenêtre contextuelle
    love.graphics.setColor(0, 0, 0, 0.5) -- semi-transparent
    love.graphics.rectangle('fill', 100, 100, 680, 480)
    
    -- Dessinez le texte des règles
    love.graphics.setColor(1, 1, 1) -- blanc
    local rules = [[
    Règles du jeu "8 américain" :
    1. Le jeu se joue avec un jeu de 52 cartes.
    2. Chaque joueur commence avec 7 cartes.
    3. Le but du jeu est de se débarrasser de toutes ses cartes.
    4. Les cartes spéciales sont :
       - 8 : Le joueur suivant saute son tour.
       - 2 : Le joueur suivant doit piocher 2 cartes.
       - Valet : Le joueur qui joue cette carte change la couleur de la pile de défausse.
       - As : Le sens du jeu est inversé.
    5. Si un joueur ne peut pas jouer une carte, il doit piocher une carte de la pioche.
    6. Le premier joueur qui se débarrasse de toutes ses cartes est le gagnant.
    ]]
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.printf(rules, 120, 180, 580)
    love.graphics.setFont(font)
    
    -- Dessinez le bouton de fermeture
    love.graphics.rectangle('line', 650, 110, 50, 20)
    love.graphics.printf('Fermer', 655, 110, 40, 'center')
  end

end

function love.update(dt)
  elapsed_time = elapsed_time + dt

  if (playerTurn or not playerTurn) and extraTurns > 0 then
    extraTurns = extraTurns - 1
  end

  -- Si plus de 2 secondes se sont écoulées depuis le dernier tour du joueur
  if not playerTurn and elapsed_time >= 2 and not gameOver and extraTurns == 0 then
    jouerOrdinateur()
    if extraTurns == 0 then
      playerTurn = true
    end
    elapsed_time = 0 
  end
  
end
function love.mousepressed(x, y, button, istouch)
  -- Vérifier si le clic a eu lieu sur le bouton "Règle du jeu"
  if x >= 0 and x <= 100 and y >= 0 and y <= 30 then
    showRules = not showRules -- bascule l'affichage des règles
  end

  if gameOver and x >= 650 and x <= 700 and y >= 110 and y <= 130 then
    gameOver = false
  end

  
  if button == 1 and playerTurn and not gameOver then
    -- Vérifier si le clic a eu lieu sur la pile de cartes de dos
    if x >= 5 and x <= 180 and y >= 250 and y <= 480 then
      -- Ajouter une carte aléatoire à playerHand
      local randomIndex = math.random(1, #cartePioche)
      table.insert(playerHand, cartePioche[randomIndex])
      table.remove(cartePioche, randomIndex)
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
        print("Carte centrale : " .. imagePaths.cards[centralCardIndex])
        if jouerCarte(cardIndexInGeneralList) then
          -- Mettre à jour la carte centrale
          centralCard = selectedCard
          -- Supprimer la carte de la main du joueur
          table.remove(playerHand, i)
          -- Afficher la carte au centre
          centralCardIndex = cardIndexInGeneralList
          love.audio.play(cardPlayedSound)
          if extraTurns == 0 then
            playerTurn = false -- C'est maintenant le tour de l'ordinateur
          end
          elapsed_time = 0
          hasPlayerPlayedFirstCard = true
          break
        else
          love.audio.play(errorSound)
        end
        
      end
    end
  else
    love.audio.play(errorSound)
  end
  if showRules and x >= 650 and x <= 690 and y >= 110 and y <= 130 then
    showRules = false
  end
  if x >= 0 and x <= 100 and y >= 40 and y <= 70 then
    if not hasPlayerPlayedFirstCard then
      resetGame()
      love.audio.play(cardDistributionSound)
    else
     love.audio.play(errorSound)
    end
  end
  if x >= 0 and x <= 100 and y >= 80 and y <= 110 then
    love.event.quit()
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  if x >= 5 and x <= 180 and y >= 250 and y <= 480 then
    love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
  else
    love.mouse.setCursor()
  end
end