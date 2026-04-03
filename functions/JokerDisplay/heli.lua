--[[
JokerDisplay.Definitions["j_bloons_heli_pilot"] = { --Heli Pilot
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { text = "Number Cards", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local number_cards = {}
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() >= 0 and (scoring_card:get_id() <= 10 or scoring_card:get_id() == 14) then
                    table.insert(number_cards, scoring_card)
                end
            end
        end
        local last_number = JokerDisplay.calculate_rightmost_card(number_cards)
        card.joker_display_values.Xmult = last_number and
            (card.ability.extra.Xmult ^ JokerDisplay.calculate_card_triggers(last_number, scoring_hand)) or 1
    end
}

JokerDisplay.Definitions["j_bloons_quad_darts"] = { --Quad Darts
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT },
    },
}
]]
JokerDisplay.Definitions["j_bloons_apache_prime"] = { --Apache Prime
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(2,3,5,7)" }
    },
    calc_function = function(card)
        local total_Xmult = 1
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                local triggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand) or 0
                if triggers > 0 then
                    local id = scoring_card:get_id()
                    if id == 2 then
                        total_Xmult = total_Xmult * (card.ability.extra.Xmult1 ^ triggers)
                    elseif id == 3 then
                        total_Xmult = total_Xmult * (card.ability.extra.Xmult2 ^ triggers)
                    elseif id == 5 then
                        total_Xmult = total_Xmult * (card.ability.extra.Xmult3 ^ triggers)
                    elseif id == 7 then
                        total_Xmult = total_Xmult * (card.ability.extra.Xmult4 ^ triggers)
                    end
                end
            end
        end
        card.joker_display_values.Xmult = total_Xmult
    end
}
--[[
JokerDisplay.Definitions["j_bloons_downdraft"] = { --Downdraft
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        card.joker_display_values.active = card.ability.extra.counter >= 1 and "Active!" or "Inactive"
    end
}
]]
JokerDisplay.Definitions["j_bloons_special_poperations"] = { --Special Poperations
    text = {
        { text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { ref_table = "card.joker_display_values", ref_value = "active_marine", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { text = ")", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active_cash_drop" },
        { text = ")" },
    },
    extra = {
        {
            { text = "+", colour = G.C.ORANGE },
            { ref_table = "card.joker_display_values", ref_value = "marine", colour = G.C.ORANGE },
            { text = " +", colour = G.C.MONEY },
            { ref_table = "card.joker_display_values", ref_value = "cash_drop", colour = G.C.MONEY },
        }
    },
    calc_function = function(card)
        local marine = card.ability.extra.marine
        local cash = card.ability.extra.cash
        local counter = card.ability.extra.counter
        if (counter + 1) % marine == 0 then
            card.joker_display_values.marine = 1
            card.joker_display_values.active_marine = "Next!"
        else
            card.joker_display_values.marine = 0
            card.joker_display_values.active_marine = marine - counter % marine .. " remaining"
        end

        if (counter + 1) % cash == 0 then
            card.joker_display_values.cash_drop = 1
            card.joker_display_values.active_cash_drop = "Next!"
        else
            card.joker_display_values.cash_drop = 0
            card.joker_display_values.active_cash_drop = cash - counter % cash .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_comanche_defense"] = { --Comanche Defense
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
    },
}
