JokerDisplay.Definitions["j_bloons_monkey_buccaneer"] = { --Monkey Buccaneer
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Play)" }
    },
}

JokerDisplay.Definitions["j_bloons_faster_shooting_buccaneer"] = { --Faster Shooting
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Play)" }
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'fastboat')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_double_shot_buccaneer"] = { --Double Shot
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Play)" }
    },
    calc_function = function(card)
        local count = 0
        local idx_by_id = {}
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for k, v in pairs(scoring_hand) do
                local id = v:get_id()
                if idx_by_id[id] then
                    count = count + JokerDisplay.calculate_card_triggers(v, scoring_hand)
                    idx_by_id[id] = nil
                else
                    idx_by_id[id] = k
                end
            end
        end
        card.joker_display_values.money = count * card.ability.extra.money
    end
}

JokerDisplay.Definitions["j_bloons_destroyer"] = { --Destroyer
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.Xmult = card.ability.extra.active and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_aircraft_carrier"] = { --Airtcraft Carrier
    text = {
        { ref_table = "card.ability.extra", ref_value = "planes", retrigger_type = "mult" },
            { text = "x", scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
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
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'airrier')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_carrier_flagship"] = { --Carrier Flagship
    text = {
        { ref_table = "card.ability.extra", ref_value = "planes", retrigger_type = "mult" },
            { text = "x", scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
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
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'flag')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_grape_shot"] = { --Grape Shot
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_hot_shot"] = { --Hot Shot
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'hotshot')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_cannon_ship"] = { --Cannon Ship
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
        { text = " +$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
}

JokerDisplay.Definitions["j_bloons_monkey_pirates"] = { --Monkey Pirates
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        -- Talisman compatibility
        local blind_ratio = to_big(G.GAME.chips / G.GAME.blind.chips)
        card.joker_display_values.active = G.GAME and G.GAME.chips and G.GAME.blind.chips and
            blind_ratio and blind_ratio ~= to_big(0) and blind_ratio >= to_big(card.ability.extra.percent/100) and localize("jdis_active") or
            localize("jdis_inactive")
    end
}

JokerDisplay.Definitions["j_bloons_pirate_lord"] = { --Pirate Lord
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    },
    calc_function = function(card)
        card.joker_display_values.money = G.GAME and G.GAME.blind and G.GAME.blind.dollars
    end
}

JokerDisplay.Definitions["j_bloons_long_range"] = { --Long Range
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Discard)" }
    },
    calc_function = function(card)
        card.joker_display_values.money = G.GAME.current_round.discards_left > 0 and card.ability.extra.money or 0
    end
}

JokerDisplay.Definitions["j_bloons_crows_nest"] = { --Crow's Nest
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Discard)" }
    },
    calc_function = function(card)
        card.joker_display_values.money = G.GAME.current_round.discards_left > 0 and #G.hand.highlighted == 1 and card.ability.extra.money or 0
    end
}

JokerDisplay.Definitions["j_bloons_merchantman"] = { --Merchantman
}

JokerDisplay.Definitions["j_bloons_favored_trades"] = { --Favored Trades
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_trade_empire"] = { --Trade Empire
}