JokerDisplay.Definitions["j_bloons_beast"] = { --Beast Handler
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "(Mult card)" }
    },
    calc_function = function(card)
        local chips = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Mult' then
                    chips = card.ability.extra.chips
                    break
                end
            end
        end
        card.joker_display_values.chips = chips
    end
}

JokerDisplay.Definitions["j_bloons_owl"] = { --Horned Owl
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Tarot },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "number", colour = G.C.ORANGE},
        { text = " Mult", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local mult_cards = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Mult' then
                    mult_cards = mult_cards + 1
                end
            end
        end
        card.joker_display_values.tarots = mult_cards >= 2 and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_velo"] = { --Velociraptor
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(" },
        { text = "Mult", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Mult' then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end,
}

JokerDisplay.Definitions["j_bloons_condor"] = { --Giant Condor
    reminder_text = {
        { text = "(" },
        { text = "Mult", colour = G.C.ORANGE }, 
        { text = ")" }
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'condor')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_meg"] = { --Megalodon
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current_chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current_mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(" },
        { text = "Bonus", colour = G.C.ORANGE },
        { text = ", " },
        { text = "Mult", colour = G.C.ORANGE },
        { text = ")" }
    }
}