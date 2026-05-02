--[[
JokerDisplay.Definitions["j_bloons_druid"] = { --Druid
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(" },
        { text = "Full House", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local mult = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands['Full House'] and next(poker_hands['Full House']) then
            mult = card.ability.extra.mult
        end
        card.joker_display_values.mult = mult
    end
}

JokerDisplay.Definitions["j_bloons_heart_of_thunder"] = { --Heart of Thunder
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'thunder')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_druid_of_the_storm"] = { --Druid of the Storm
    text = {
        { text = "+", colour = G.C.BLUE },
        { ref_table = "card.joker_display_values", ref_value = "hands", colour = G.C.BLUE }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.hands = card.ability.extra.hands
            card.joker_display_values.active = "Next!"
        else
            card.joker_display_values.hands = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_jungles_bounty"] = { --Jungle's Bounty
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
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
]]