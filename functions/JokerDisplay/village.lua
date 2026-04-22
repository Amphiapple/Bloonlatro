JokerDisplay.Definitions["j_bloons_monkey_village"] = { --Monkey Village
}

JokerDisplay.Definitions["j_bloons_bigger_radius"] = { --Bigger Radius
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

JokerDisplay.Definitions["j_bloons_primary_training"] = { --Primary Training
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
        { text = "x" },
        { text = "Primary", colour = G.C.PRIMARY },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card ~= card and joker_card.ability.tower_info.category == 'primary' then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (card ~= mod_joker and card.ability.tower_info.category == 'primary' and mod_joker.ability.extra.Xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

JokerDisplay.Definitions["j_bloons_primary_mentoring"] = { --Primary Mentoring
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
        { text = "x" },
        { text = "Primary", colour = G.C.PRIMARY },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card ~= card and joker_card.ability.tower_info.category == 'primary' then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (card ~= mod_joker and card.ability.tower_info.category == 'primary' and mod_joker.ability.extra.Xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
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
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'pex')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_grow_blocker"] = { --Grow Blocker
}

JokerDisplay.Definitions["j_bloons_radar_scanner"] = { --Radar Scanner
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

JokerDisplay.Definitions["j_bloons_call_to_arms"] = { --Call to Arms
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local active = G.GAME and (G.GAME.current_round.hands_left == 1 and not next(G.play.cards) or G.GAME.current_round.hands_left == 0 and next(G.play.cards))
        card.joker_display_values.active = active and "Active!" or "Inactive"
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'call_to_arms')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_homeland_defense"] = { --Homeland Defense
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local active = G.GAME and (G.GAME.current_round.hands_left == 1 and not next(G.play.cards) or G.GAME.current_round.hands_left == 0 and next(G.play.cards))
        card.joker_display_values.active = active and "Active!" or "Inactive"
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'homeland_defense')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_monkey_business"] = { --Monkey Business
}

JokerDisplay.Definitions["j_bloons_monkey_commerce"] = { --Monkey Commerce
}

JokerDisplay.Definitions["j_bloons_monkey_town"] = { --Monkey Town
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

JokerDisplay.Definitions["j_bloons_monkeyopolis"] = { --Monkeyopolis
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    },
    calc_function = function(card)
        card.joker_display_values.money = math.ceil(card.sell_cost / 2)
    end
}
