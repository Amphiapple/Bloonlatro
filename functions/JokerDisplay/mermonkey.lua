JokerDisplay.Definitions["j_bloons_merm"] = { --Mermonkey
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(Bonus card)" }
    },
    calc_function = function(card)
        local mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Bonus' then
                    mult = card.ability.extra.mult
                    break
                end
            end
        end
        card.joker_display_values.mult = mult
    end
}

JokerDisplay.Definitions["j_bloons_network"] = { --Echosense Network
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Planet },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Planet }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "number", colour = G.C.ORANGE},
        { text = " Bonus", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local bonus_cards = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Bonus' then
                    bonus_cards = bonus_cards + 1
                end
            end
        end
        card.joker_display_values.tarots = bonus_cards >= 2 and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_melody"] = { --Alluring Melody
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "(" },
        { text = "Bonus", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Bonus' then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
    end,
}

JokerDisplay.Definitions["j_bloons_arknight"] = { --Arctic Knight
    reminder_text = {
        { text = "(" },
        { text = "Bonus", colour = G.C.ORANGE },
        { text = ")" }
    },
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end

        local retrigger = false
        local idx

        for i, card in ipairs(scoring_hand) do
            if card == playing_card then
                idx = i
                break
            end
        end

        if idx then
            local left  = scoring_hand[idx-1]
            local right = scoring_hand[idx+1]

            retrigger =
                (left  and left.ability  and left.ability.name  == "Bonus") or
                (right and right.ability and right.ability.name == "Bonus")
        end

        return retrigger and joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_lota"] = { --Lord of the Abyss
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "number" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "limit" },
        { text = ")" },
    },
    calc_function = function(card)
        if not G.playing_cards then return end

        local count = 0
        for _, deck_card in pairs(G.playing_cards) do
            if deck_card.ability.name == 'Bonus' then
                count = count + 1
            end
        end

        card.joker_display_values.mult = count >= card.ability.extra.limit and card.ability.extra.mult or 0
    end
}