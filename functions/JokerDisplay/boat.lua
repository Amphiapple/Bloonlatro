JokerDisplay.Definitions["j_bloons_boat"] = { --Monkey Buccaneer
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
}

JokerDisplay.Definitions["j_bloons_fastboat"] = { --Faster Shooting
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
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

JokerDisplay.Definitions["j_bloons_doubleboat"] = { --Double Shot
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    calc_function = function(card)
        local count = 0
        local idx_by_id = {}
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for k, v in pairs(scoring_hand) do
                local id = v:get_id()
                if idx_by_id[id] then
                    count = count + JokerDisplay.calculate_card_triggers(v, nil, true)
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

JokerDisplay.Definitions["j_bloons_airrier"] = { --Airtcraft Carrier
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

JokerDisplay.Definitions["j_bloons_flag"] = { --Carrier Flagship
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

JokerDisplay.Definitions["j_bloons_grape"] = { --Grape Shot
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(Round)" }
    }
}

JokerDisplay.Definitions["j_bloons_hotshot"] = { --Hot Shot
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

JokerDisplay.Definitions["j_bloons_plord"] = { --Cannon Ship
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
        { text = " +$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
    },
}

JokerDisplay.Definitions["j_bloons_plord"] = { --Monkey Pirates
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

JokerDisplay.Definitions["j_bloons_plord"] = { --Pirate Lord
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

JokerDisplay.Definitions["j_bloons_rangeboat"] = { --Long Range
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY },
    },
    calc_function = function(card)
        card.joker_display_values.dollars = G.GAME.current_round.discards_left > 0 and card.ability.extra.dollars or 0
    end
}

JokerDisplay.Definitions["j_bloons_crowsnest"] = { --Crow's Nest
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY },
    },
    calc_function = function(card)
        card.joker_display_values.dollars = G.GAME.current_round.discards_left > 0 and #G.hand.highlighted == 1 and card.ability.extra.dollars or 0
    end
}

JokerDisplay.Definitions["j_bloons_merchant"] = { --Merchantman
}

JokerDisplay.Definitions["j_bloons_flavored"] = { --Favored Trades
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_empire"] = { --Trade Empire
}