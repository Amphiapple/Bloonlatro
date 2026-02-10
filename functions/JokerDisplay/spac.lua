JokerDisplay.Definitions["j_bloons_spac"] = { --Spike Factory
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
    },
}

JokerDisplay.Definitions["j_bloons_stacks"] = { --Bigger Stacks
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
    },
}

JokerDisplay.Definitions["j_bloons_smart"] = { --Smart Spikes
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
    }
}

JokerDisplay.Definitions["j_bloons_lls"] = { --Long Life Spikes
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT },
    },
}

JokerDisplay.Definitions["j_bloons_sporm"] = { --Spike Storm
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x",                              scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local count = 0
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
            card.joker_display_values.count = count
            card.joker_display_values.active = "Active!"
            card.joker_display_values.Xmult = card.ability.extra.Xmult
        else
            card.joker_display_values.count = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.Xmult = 1
        end
    end
}

JokerDisplay.Definitions["j_bloons_pspike"] = { --Perma Spike
    text = {
        { text = "+", colour = G.C.BLUE },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.BLUE }
    }
}