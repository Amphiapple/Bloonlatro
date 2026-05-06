JokerDisplay.Definitions["j_bloons_druid"] = { --Druid
}

JokerDisplay.Definitions["j_bloons_hard_thorns"] = { --Hard Thorns
}

JokerDisplay.Definitions["j_bloons_heart_of_thunder"] = { --Heart of Thunder
}

JokerDisplay.Definitions["j_bloons_druid_of_the_storm"] = { --Druid of the Storm
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "planets" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Planet },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
        { text = ")" }
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds", retrigger_type = "mult" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local planet = nil
        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
            if v.config.hand_type == JokerDisplay.evaluate_hand() then
                planet = v.name
            end
        end
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'druid_of_the_storm')
        card.joker_display_values.odds = n .. " in " .. d
        card.joker_display_values.poker_hand = planet or 'None'
        card.joker_display_values.planets = planet and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_ball_lightning"] = { --Ball Lightning
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        local total_Xmult = 1
        for _, consumable in ipairs(G.consumeables.cards) do
            local center_key = consumable.config and consumable.config.center_key
            if center_key and G.P_CENTERS[center_key] and G.P_CENTERS[center_key].set == "Planet" then
                local hand_type = G.P_CENTERS[center_key].config.hand_type
                total_Xmult = total_Xmult * (hand_type == text and card.ability.extra.Xmult_match or card.ability.extra.Xmult)
            end
        end
        card.joker_display_values.Xmult = total_Xmult
    end
}

JokerDisplay.Definitions["j_bloons_monarch_of_storms"] = { --Monarch of Storms
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "planets", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Planet },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
        { text = ")" }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local planet = nil
        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
            if v.config.hand_type == G.GAME.last_hand_played then
                planet = v.name
            end
        end
        card.joker_display_values.poker_hand = planet or 'None'
        card.joker_display_values.planets = planet and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_thorn_swarm"] = { --Thorn Swarm
}

JokerDisplay.Definitions["j_bloons_heart_of_oak"] = { --Heart of Oak
    text = {
        { text = "+$" },
        { ref_table = "card.ability.extra", ref_value = "money", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.MONEY }
}

JokerDisplay.Definitions["j_bloons_druid_of_the_jungle"] = { --Druid of the Jungle
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.MONEY },
    calc_function = function(card)
        local count = 0
        for _, consumable in ipairs(G.consumeables.cards) do
            local center_key = consumable.config and consumable.config.center_key
            if center_key and G.P_CENTERS[center_key] and G.P_CENTERS[center_key].set == "Planet" then
                count = count + 1
            end
        end
        card.joker_display_values.money = card.ability.extra.money * count
    end
}

JokerDisplay.Definitions["j_bloons_jungles_bounty"] = { --Jungle's Bounty
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "money" },
    },
    text_config = { colour = G.C.MONEY },
    calc_function = function(card)
        local count = 0
        for _, consumable in ipairs(G.consumeables.cards) do
            local center_key = consumable.config and consumable.config.center_key
            if center_key and G.P_CENTERS[center_key] and G.P_CENTERS[center_key].set == "Planet" then
                count = count + 1
            end
        end
        card.joker_display_values.money = card.ability.extra.money * count
    end
}

JokerDisplay.Definitions["j_bloons_spirit_of_the_forest"] = { --Spirit of the Forest
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.MONEY },
    calc_function = function(card)
        local money = 0
        local text, _, _ = JokerDisplay.evaluate_hand()
        if text and text ~= "Unknown" and G.GAME.hands[text] then
            money = G.GAME.hands[text].level
        end
        card.joker_display_values.money = money > card.ability.extra.max and card.ability.extra.max or money
    end
}

JokerDisplay.Definitions["j_bloons_druidic_reach"] = { --Druidic Reach
}

JokerDisplay.Definitions["j_bloons_heart_of_vengeance"] = { --Heart of Vengeance
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        card.joker_display_values.mult = (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0)
    end
}

JokerDisplay.Definitions["j_bloons_druid_of_wrath"] = { --Druid of Wrath
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        local count = (text ~= 'Unknown' and G.GAME.hands[text] and G.GAME.hands[text].played + (next(G.play.cards) and 0 or 1)) or 0
        card.joker_display_values.Xmult = 1 + card.ability.extra.Xmult * count
    end
}

JokerDisplay.Definitions["j_bloons_poplust"] = { --Poplust
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
        { text = "x" },
        { text = "Druids", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.ability.tower_info and joker_card.ability.tower_info.base and joker_card.ability.tower_info.base == 'Druid' then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (card.ability.tower_info and card.ability.tower_info.base and card.ability.tower_info.base == 'Druid' and mod_joker.ability.extra.Xmult * JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

JokerDisplay.Definitions["j_bloons_avatar_of_wrath"] = { --Avatar of Wrath
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    }
}