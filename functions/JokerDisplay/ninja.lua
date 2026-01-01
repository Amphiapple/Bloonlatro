JokerDisplay.Definitions["j_bloons_ninja"] = { --Ninja Monkey
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_espionage"] = { --Counter Espionage
}

JokerDisplay.Definitions["j_bloons_flash"] = { --Flash Bomb
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.active = "Next!"
        else
            card.joker_display_values.mult = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_shinobi"] = { --Shinobi Tactics
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
        { text = "x" },
        { text = "Ninjas", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.ability.base and joker_card.ability.base == 'ninja' then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (card.ability.base and card.ability.base == 'ninja' and mod_joker.ability.extra.Xmult * JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

JokerDisplay.Definitions["j_bloons_sabo"] = { --Bloon Sabotage
    reminder_text = {
        { text = "(" },
        { text = "Heart", colour = lighten(G.C.SUITS["Hearts"], 0.35) },
        { text = ")" },
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'sabo')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_gmn"] = { --Grandmaster Ninja
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local total_Xmult = 1
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_suit('Diamonds', true) and not scoring_card.debuff then
                    total_Xmult = total_Xmult + card.ability.extra.Xmult
                end
            end
        end
        card.joker_display_values.Xmult = total_Xmult
    end
}