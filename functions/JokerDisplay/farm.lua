JokerDisplay.Definitions["j_bloons_banana_farm"] = { --Banana Farm
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_increased_production"] = { --Increased Production
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_greater_production"] = { --Greater Production
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_banana_plantation"] = { --Banana Plantation
    text = {
        { text = "+$", colour = G.C.MONEY },
        {
            dynatext = {
                string = (
                    function()
                        local card = SMODS.Centers["j_bloons_banana_plantation"]
                        local r_money = {}
                        for i = card.config.extra.min, card.config.extra.max do
                            r_money[#r_money + 1] = tostring(i)
                        end
                        return r_money
                    end
                )(),
                colours = { G.C.MONEY },
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.5,
                scale = 0.4,
                min_cycle_time = 0
            }
        }
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_banana_research_facility"] = { --Banana Research Facility
    text = {
        {
            dynatext = {
                string = (
                    function()
                        local card = SMODS.Centers["j_bloons_banana_research_facility"]
                        local r_crates = {}
                        for i = card.config.extra.min, card.config.extra.max do
                            r_crates[#r_crates + 1] = tostring(i)
                        end
                        return r_crates
                    end
                )(),
                colours = { G.C.FILTER },
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.5,
                scale = 0.4,
                min_cycle_time = 0
            }
        },
        { text = "x" },
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_banana_central"] = { --Banana Central
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_long_life_bananas"] = { --Long Life Bananas
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

JokerDisplay.Definitions["j_bloons_valuable_bananas"] = { --Valuable Bananas
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

JokerDisplay.Definitions["j_bloons_monkey_bank"] = { --Monkey Bank
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.MONEY }
    }
}

JokerDisplay.Definitions["j_bloons_imf_loan"] = { --IMF Loan
    text = {
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.MONEY }
    }
}

JokerDisplay.Definitions["j_bloons_monkey_nomics"] = { --Monkey-Nomics
}

JokerDisplay.Definitions["j_bloons_ez_collect"] = { --EZ Collect
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_banana_salvage"] = { --Banana Salvage
}

JokerDisplay.Definitions["j_bloons_marketplace"] = { --Marketplace
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_central_market"] = { --Central Market
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_monkey_wall_street"] = { --Monkey Wall Street
}