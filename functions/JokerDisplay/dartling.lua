JokerDisplay.Definitions["j_bloons_dartling"] = { --Dartling Gunner
    text = {
        { text = "+???", colour = G.C.CHIPS },
    }
}

JokerDisplay.Definitions["j_bloons_lshock"] = { --Laser Shock
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
    }
}

JokerDisplay.Definitions["j_bloons_buckshot"] = { --Buckshot
    text = {
        {
            border_nodes = {
                { text = "X?.?" },
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_rorm"] = { --Rocket Storm
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { text = "Pair", colour = G.C.ORANGE },
        { text = ")" }
    }
}

JokerDisplay.Definitions["j_bloons_rod"] = { --Ray of Doom
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x",                              scale = 0.35 },
        {
            border_nodes = {
                { text = "X?.?" }
            }
        }
    },
    calc_function = function(card)
        local count = 0
        local ids = {}
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()

        if text ~= "Unknown" then
            for _, scoring_card in pairs(scoring_hand) do
                local id = scoring_card:get_id()
                local triggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand) or 0

                if ids[id] then
                    count = count + triggers
                elseif triggers >= 2 then
                    ids[id] = true
                    count = count + (triggers - 1)
                else
                    ids[id] = true
                end
            end
        end

        card.joker_display_values.count = count
    end
}