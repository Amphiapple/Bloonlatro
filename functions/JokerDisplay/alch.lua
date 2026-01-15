JokerDisplay.Definitions["j_bloons_alch"] = { --Alchemist
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_left <= 1 and "Active!" or "Inactive"
    end
}

JokerDisplay.Definitions["j_bloons_amd"] = { --Acidic Mixture Dip
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'amd')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_brew"] = { --Berserker Brew
}

JokerDisplay.Definitions["j_bloons_r2g"] = { --Rubber to Gold
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()

        local only_card = text ~= "Unknown" and #G.hand.highlighted == 1

        card.joker_display_values.active = G.GAME and G.GAME.current_round.discards_left == 1 and only_card and "Active!" or "Inactive"
    end
}

JokerDisplay.Definitions["j_bloons_tt5"] = { --Total Transformation
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = card.ability.extra.current >= card.ability.extra.rounds and
            "Active!" or
            (card.ability.extra.current .. "/" .. card.ability.extra.rounds)
    end
}