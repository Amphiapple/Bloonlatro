JokerDisplay.Definitions["j_bloons_farm"] = { --Banana Farm
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_iproduct"] = { --BIncreased Production
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_gproduct"] = { --Greater Production
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_plantation"] = { --Banana Plantation
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "min", colour = G.C.MONEY },
        { text = "-", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "max", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_brf"] = { --Banana Research Facility
    text = {
        { text = "0-" },
        { ref_table = "card.ability.extra", ref_value = "crates" },
        { text = "x" },
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_central"] = { --Banana Central
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_longlife"] = { --Long Life Bananas
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

JokerDisplay.Definitions["j_bloons_bank"] = { --Monkey Bank
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.MONEY }
    }
}

JokerDisplay.Definitions["j_bloons_imf"] = { --IMF Loan
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.MONEY }
    }
}

JokerDisplay.Definitions["j_bloons_nomics"] = { --Monkey-Nomics
}

JokerDisplay.Definitions["j_bloons_central"] = { --Banana Central
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_salvage"] = { --Banana Salvage
}

JokerDisplay.Definitions["j_bloons_market"] = { --Marketplace
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_cmarket"] = { --Central Market
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_wallstreet"] = { --Monkey Wall Street
}