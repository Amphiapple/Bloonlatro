JokerDisplay.Definitions["j_bloons_desp"] = { --Desperado
    --[[
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "(First " },
        { ref_table = "card.ability.extra", ref_value = "number" },
        { text = " cards)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for i = 1, math.min(card.ability.extra.number, #scoring_hand) do
                local scoring_card = scoring_hand[i]
                if scoring_card then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
    end
    ]]
}

JokerDisplay.Definitions["j_bloons_nomad"] = { --Nomad
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.poker_hand = card.ability.extra.poker_hand ~= "" and card.ability.extra.poker_hand or "None"
    end
}

JokerDisplay.Definitions["j_bloons_enforcer"] = { --Enforcer
}

JokerDisplay.Definitions["j_bloons_twix"] = { --Twin Sixes
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "number", colour = G.C.ORANGE },
        { text = " 6s", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 6 and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end

        card.joker_display_values.Xmult = count >= card.ability.extra.number and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_gustice"] = { --Golden Justice
}