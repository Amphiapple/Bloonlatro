JokerDisplay.Definitions["j_bloons_dart"] = { --Dart Monkey
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_eyesight"] = { --Enhanced Eyesight
}

JokerDisplay.Definitions["j_bloons_quick"] = { --Quick Shots
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card) 
        if G.GAME.current_round.hands_played > 0 then 
            card.joker_display_values.chips = card.ability.extra.chips
            card.joker_display_values.mult = card.ability.extra.mult
        else
            card.joker_display_values.chips = 0
            card.joker_display_values.mult = 0
        end
    end
}

JokerDisplay.Definitions["j_bloons_tripshot"] = { --Triple shot
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Tarot },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)

        if card.ability.extra.counter == 1 then
            card.joker_display_values.active = "Next!"
            card.joker_display_values.tarots = card.ability.extra.tarots
        else
            card.joker_display_values.active = card.ability.extra.counter .. " remaining"
            card.joker_display_values.tarots = 0
        end
    end
}

JokerDisplay.Definitions["j_bloons_jugg"] = { --Juggernaut
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                count = count +
                    JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * (count * (count + 1)) / 2
    end
}

JokerDisplay.Definitions["j_bloons_xbm"] = { --Crossbow Master
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "counter" },
        { text = ")" }
    },
    calc_function = function(card)
        local limit = card.ability.extra.limit
        local counter = card.ability.extra.counter

        if G.STATE and G.STATE == G.STATES.HAND_PLAYED then
            card.joker_display_values.Xmult = card.joker_display_values and card.joker_display_values.Xmult or 1
            card.joker_display_values.counter = counter <= limit - 1 and limit - counter % limit .. " remaining" or "Next!"
            return
        end

        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()

        if text ~= "Unknown" and type(scoring_hand) == "table" then
            for _, scoring_card in pairs(scoring_hand) do
                count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end

        local activations = (count + counter - 1 >= limit) and 1 + math.floor((count + counter - 1 - limit) / limit) or 0

        card.joker_display_values.Xmult = (activations > 0 and (card.ability.extra.Xmult ^ activations) or 1)

        card.joker_display_values.counter =
            counter <= limit - 1 and limit - counter % limit .. " remaining" or "Next!"
    end
}