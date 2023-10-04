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

            -- Mettre à jour la carte centrale
            centralCardIndex = selected.code

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
