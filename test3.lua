local function shuffleWithEffect(cards, iterations, delay)
    local numCards = #cards

    for i = 1, iterations do
        for j = 1, numCards do
            local randomIndex = math.random(1, numCards)
            cards[j], cards[randomIndex] = cards[randomIndex], cards[j]

            -- Afficher les cartes pendant un court instant pour créer l'effet de mélange
            love.graphics.clear()
            for k, card in ipairs(cards) do
                drawCard(card, cartePX + (k-1) * cardSpacing, cartePY, 0, 0.27, 0.27)
            end
            love.graphics.present()

            love.timer.sleep(delay) -- Délai entre chaque itération (en millisecondes)
        end
    end
end


function love.load()
    -- Créer les cartes
    local cards = {}
    for i, cardName in ipairs(imagePaths.cards) do
        cards[i] = love.graphics.newImage("assets/img/cards-master/" .. cardName .. ".png")
    end

    -- Mélanger les cartes
    shuffleWithEffect(cards, 10, 100)

    -- Afficher les cartes
    love.graphics.clear()
    for i, card in ipairs(cards) do
        drawCard(card, cartePX + (i-1) * cardSpacing, cartePY, 0, 0.27, 0.27)
    end
    love.graphics.present()
end


function playCard(selected)
    local topCard = discard[#discard]

    if playersTurn then
        -- Vérifier si la carte sélectionnée peut être jouée
        if selected.suit == suit or selected.value == topCard.value or selected.value == "8" then
            -- Mettre à jour la main du joueur
            local updatedHand = {}
            for _, card in ipairs(playerHand) do
                if card.code ~= selected.code then
                    table.insert(updatedHand, card)
                end
            end
            setPlayerHand(updatedHand)

            -- Mettre à jour la pile de défausse
            local updatedDiscard = {unpack(discard)}
            table.insert(updatedDiscard, selected)
            setDiscard(updatedDiscard)

            -- Mettre à jour la couleur actuelle et le tour du joueur
            if selected.value == "8" then
                setSuitSelectOpen(true)
            else
                setSuit(selected.suit)
                setPlayersTurn(false)
                setTimeout(compPlay(selected, selected.suit), 1000)
            end

            -- Vérifier si le joueur a gagné
            if #updatedHand == 0 then
                setTimeout(function() setWinner("player") end, 1000)
            end
        end
    end
end

function compPlay(topCard, currentSuit)
    topCard = topCard or discard[#discard]
    currentSuit = currentSuit or suit

    local selected

    for _, card in ipairs(compHand) do
        if card.suit == currentSuit or card.value == topCard.value or card.value == "8" then
            selected = card
            break
        end
    end

    if selected then
        local updatedHand = {}
        for _, card in ipairs(compHand) do
            if card.code ~= selected.code then
                table.insert(updatedHand, card)
            end
        end

        if selected.value == "8" then
            setSuit(compHand[1].suit)
        else
            setSuit(selected.suit)
        end

        local updatedDiscard = {unpack(discard)}
        table.insert(updatedDiscard, selected)

        setCompHand(updatedHand)
        setDiscard(updatedDiscard)

        if #updatedHand == 0 then
            setTimeout(function() setWinner("comp") end, 1000)
        end
    else
        draw("comp")
    end

    setPlayed(false)
    setPlayersTurn(true)
end


function draw(player)
    local topCard = deck[#deck]

    if player == "comp" then
        local updatedCompHand = {unpack(compHand)}
        table.insert(updatedCompHand, topCard)
        setCompHand(updatedCompHand)
    else
        if playersTurn then
            local updatedPlayerHand = {unpack(playerHand)}
            table.insert(updatedPlayerHand, topCard)
            setPlayerHand(updatedPlayerHand)
            setPlayed(true)
        end
    end

    if #deck == 1 then
        if #discard <= 1 then
            setWinner(player == "comp" and "player" or "comp")
        end

        local updatedDeck = shuffle({unpack(discard, 1, #discard-1)})
        setDeck(updatedDeck)
        setDiscard({discard[#discard]})
    else
        setDeck({unpack(deck, 1, #deck-1)})
    end
end
function passTurn()
    setPlayersTurn(false)
    setTimeout(function()
        compPlay()
    end, 1000)
end

function selectSuit(selectedSuit)
    setSuit(selectedSuit)
    setPlayersTurn(false)
    setSuitSelectOpen(false)
    setTimeout(function()
        compPlay(discard[#discard], selectedSuit)
    end, 1000)
end


function setTimeout(callback, delay)
    local timer = love.timer.getTime() + delay
    return function()
        if love.timer.getTime() >= timer then
            callback()
        end
    end
end




if centralCardIndex >= 1 and centralCardIndex <= #cardImages then
    love.graphics.draw(cardImages[centralCardIndex], cardCenterX, cardCenterY, 0, 0.27, 0.27)
  elseif centralCardIndex == 0 or centralCardIndex == nil then
    centralCardIndex = 26
    love.graphics.draw(cardImages[centralCardIndex], cardCenterX, cardCenterY, 0, 0.27, 0.27)
  else
    centralCardIndex = 17
    love.graphics.draw(cardImages[centralCardIndex], cardCenterX, cardCenterY, 0, 0.27, 0.27)
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
-- carte preécedente opponent
   love.graphics.draw(cardImages[34], 880 , 20, 0, 0.27, 0.27)
-- carte prédente
   love.graphics.draw(cardImages[3], 880, cartePY - 20, 0, 0.27, 0.27)
