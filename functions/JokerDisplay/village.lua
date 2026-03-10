JokerDisplay.Definitions["j_bloons_monkey_village"] = { --Monkey Village
}

JokerDisplay.Definitions["j_bloons_jungle_drums"] = { --Jungle Drums
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
        { text = "x" },
        { text = "Jokers", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card ~= card then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (card ~= mod_joker and mod_joker.ability.extra.Xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

JokerDisplay.Definitions["j_bloons_monkey_business"] = { --Monkey Commerce
}

JokerDisplay.Definitions["j_bloons_monkey_intelligence_bureau"] = { --Monkey Intelligence Bureau
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "num" }
            },
            border_colour = G.C.GREEN
        }
    },
}

JokerDisplay.Definitions["j_bloons_monkey_city"] = { --Monkey City
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_primary_expertise"] = { --Primary Expertise
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult"}
            }
        }
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'pex')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}