JokerDisplay.Definitions["j_bloons_glue_gunner"] = { --Glue Monkey
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },

    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local first_card

        if text ~= "Unknown" then
            first_card = JokerDisplay.calculate_leftmost_card(scoring_hand)
        end
        card.joker_display_values.mult = first_card and
            (card.ability.extra.mult * JokerDisplay.calculate_card_triggers(first_card, scoring_hand)) or 0
    end
}

JokerDisplay.Definitions["j_bloons_corrosive_glue"] = { --Corrosive Glue
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "(" },
        { text = "Glued", colour = G.C.ORANGE },
        { text = ")" }
    }
}

JokerDisplay.Definitions["j_bloons_the_bloon_solver"] = { --The Bloon Solver
}

JokerDisplay.Definitions["j_bloons_glue_hose"] = { --Glue Hose
}

JokerDisplay.Definitions["j_bloons_moab_glue"] = { --Moab Glue
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
        { text = "Face Cards", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local Xmult = 1
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() then
                    Xmult = card.ability.extra.Xmult
                    break
                end
            end
        end
        card.joker_display_values.Xmult = Xmult
    end
}

JokerDisplay.Definitions["j_bloons_relentless_glue"] = { --Relentless Glue
}
