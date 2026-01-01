JokerDisplay.Definitions["j_bloons_ice"] = { --Ice Monkey
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_played == 0 and
            "Active!" or "Inactive"
        card.joker_display_values.chips = G.GAME and G.GAME.current_round.hands_played == 0 and
            card.ability.extra.chips or 0
    end,
}

JokerDisplay.Definitions["j_bloons_pfrost"] = { --Permafrost
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(" },
        { text = "Frozen", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local money = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability.name == 'Frozen Card' then
                    money = money + card.ability.extra.money * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.money = money
    end
}

JokerDisplay.Definitions["j_bloons_refreeze"] = { --Refreeze
    reminder_text = {
        { text = "(" },
        { text = "Frozen", colour = G.C.ORANGE },
        { text = ")" }
    },
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local held_cards = {}

        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end

        for _, card in ipairs(held_cards) do
            if card == playing_card and card.ability and card.ability.name == 'Frozen Card' then
                return joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card)
            end
        end

        return 0
    end
}

JokerDisplay.Definitions["j_bloons_shards"] = { --Ice Shards
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { text = "Frozen", colour = G.C.ORANGE },
        { text = ")" }
    },
}

JokerDisplay.Definitions["j_bloons_icicles"] = { --Icicles
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability and playing_card.ability.name == 'Frozen Card' then
                    count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end
}

JokerDisplay.Definitions["j_bloons_az"] = { --Absolute Zero
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Spectral },
        { ref_table = "card.joker_display_values", ref_value = "spectrals", colour = G.C.SECONDARY_SET.Spectral }
    },
    calc_function = function(card)
        local cards_needed = false
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()

        if text ~= 'Unknown' then
            cards_needed = #scoring_hand == card.ability.extra.number
        end

        local first_hand = G.GAME and G.GAME.current_round.hands_played == 0

        card.joker_display_values.spectrals = first_hand and cards_needed and 1 or 0
    end
}