JokerDisplay.Definitions["j_bloons_boat"] = { --Monkey Buccaneer
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_grape"] = { --Grape Shot
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_destroyer"] = { --Destroyer
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.Xmult = card.ability.extra.active and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_flavored"] = { --Favored Trades
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        local my_pos = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then my_pos = i; break end
        end

        local text, _, _ = JokerDisplay.evaluate_hand()
        local one_card = nil
        if text ~= "Unknown" then
            one_card = #G.hand.highlighted == 1
        end

        local no_hands_played = G.GAME.current_round.hands_played == 0
        local joker_to_destroy = my_pos and G.jokers.cards[my_pos+1] and not G.jokers.cards[my_pos+1].ability.eternal

        card.joker_display_values.active = one_card and no_hands_played and joker_to_destroy and "Active!" or "Inactive"
    end
}

JokerDisplay.Definitions["j_bloons_plord"] = { --Pirate Lord
    text = {
        { text = "(", colour = G.C.GREEN, scale = 0.3 },
        { ref_table = "card.joker_display_values", ref_value = "odds2", colour = G.C.GREEN, scale = 0.3 },
        { text = ")", colour = G.C.GREEN, scale = 0.3 },
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds1", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator1 = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom1, 'plord')
        card.joker_display_values.odds1 = numerator .. " in " .. denominator1
        local numerator, denominator2 = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom2, 'plord')
        card.joker_display_values.odds2 = numerator .. " in " .. denominator2
    end
}