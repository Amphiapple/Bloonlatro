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
            { ref_table = "card.joker_display_values", ref_value = "odds" },
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
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
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
        { ref_table = "card.joker_display_values", ref_value = "planets" }
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
        { ref_table = "card.ability.extra", ref_value = "money" },
    },
    text_config = { colour = G.C.MONEY }
}

JokerDisplay.Definitions["j_bloons_druid_of_the_jungle"] = { --Druid of the Jungle
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "money" },
    },
    text_config = { colour = G.C.MONEY }
}

JokerDisplay.Definitions["j_bloons_jungles_bounty"] = { --Jungle's Bounty
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "money" },
    },
    text_config = { colour = G.C.MONEY },
    reminder_text = {
        { text = "(" },
        { text = "Full House", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        local high = 0
        local low = 0

        if text ~= "Unknown" and poker_hands['Full House'] then
            if next(poker_hands['Full House']) then
                low, high = scoring_hand[1].base.nominal, scoring_hand[1].base.nominal
                for _, scoring_card in ipairs(scoring_hand) do
                    if scoring_card.base.nominal < low then
                        low = scoring_card.base.nominal
                        break
                    elseif scoring_card.base.nominal > high then
                        high = scoring_card.base.nominal
                        break
                    end
                end
            end
        end

        card.joker_display_values.money = math.max(0, high - low)
    end
}

JokerDisplay.Definitions["j_bloons_avatar_of_wrath"] = { --Avatar of Wrath
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    }
}