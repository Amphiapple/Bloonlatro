JokerDisplay.Definitions["j_bloons_alch"] = { --Alchemist
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    calc_function = function(card)
        card.joker_display_values.count = G.GAME and G.GAME.current_round.hands_left <= 1 and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_largerpots"] = { --Larger Potions
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    calc_function = function(card)
        card.joker_display_values.count = G.GAME and G.GAME.current_round.hands_left <= 1 and 2 or 0
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
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'amd')
        card.joker_display_values.odds = n .. " in " .. d
    end
}

JokerDisplay.Definitions["j_bloons_brew"] = { --Berserker Brew
}

JokerDisplay.Definitions["j_bloons_stim"] = { --Stronger Stimulant
}

JokerDisplay.Definitions["j_bloons_acid"] = { --Stronger Acid
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.count = G.GAME and G.GAME.current_round.hands_left <= 1 and 1 or 0
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'acid')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_perishing"] = { --Perishing Potions
}

JokerDisplay.Definitions["j_bloons_conc"] = { --Unstable Concoction
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

JokerDisplay.Definitions["j_bloons_tt4"] = { --Transforming Tonic
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_played == 0 and "Active!" or "Inactive"
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

JokerDisplay.Definitions["j_bloons_fastalch"] = { --Faster Throwing
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    calc_function = function(card)
        card.joker_display_values.count = G.GAME and G.GAME.current_round.hands_left == 2 and 1 or 0
    end
}
JokerDisplay.Definitions["j_bloons_pools"] = { --Acid Pools
}

JokerDisplay.Definitions["j_bloons_l2g"] = { --Lead to Gold
    reminder_text = {
        { text = "(" },
        { text = "Steel", colour = G.C.ORANGE },
        { text = ")" }
    },
}

JokerDisplay.Definitions["j_bloons_r2g"] = { --Rubber to Gold
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = G.GAME and G.GAME.current_round.discards_left == 1 and "Active!" or "Inactive"
    end
}

JokerDisplay.Definitions["j_bloons_bma"] = { --Lead to Gold
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_left <= 1 and "Active!" or "Inactive"
    end
}
