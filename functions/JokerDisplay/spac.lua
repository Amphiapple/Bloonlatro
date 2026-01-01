JokerDisplay.Definitions["j_bloons_spac"] = { --Spike Factory
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
    },
}

JokerDisplay.Definitions["j_bloons_stacks"] = { --Bigger Stacks
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    calc_function = function(card)
        card.joker_display_values.money = (G.GAME.current_round.hands_left > 0 and card.ability.extra.money * G.GAME.current_round.hands_left) or 0
    end
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
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_pspike"] = { --Perma Spike
    text = {
        { text = "+", colour = G.C.BLUE },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.BLUE }
    }
}