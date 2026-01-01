JokerDisplay.Definitions["j_bloons_farm"] = { --Banana Farm
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_valuable"] = { --Valuable Bananas
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "bananas" },
        { text = " remaining)" }
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'valuable')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_salvage"] = { --Banana Salvage
}

JokerDisplay.Definitions["j_bloons_plantation"] = { --Dartling Gunner
    text = {
        { text = "+$??", colour = G.C.MONEY },
    }
}

JokerDisplay.Definitions["j_bloons_bank"] = { --Monkey Bank
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.MONEY }
    }
}

JokerDisplay.Definitions["j_bloons_brf"] = { --Banana Research Facility
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_wallstreet"] = { --Monkey Wall Street
}