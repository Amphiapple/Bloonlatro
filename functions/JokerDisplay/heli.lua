JokerDisplay.Definitions["j_bloons_heli_pilot"] = { --Heli Pilot
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
        card.joker_display_values.localized_text = localize("k_face_cards")
    end
}

JokerDisplay.Definitions["j_bloons_quad_darts"] = { --Quad Darts
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
        card.joker_display_values.localized_text = localize("k_face_cards")
    end
}

JokerDisplay.Definitions["j_bloons_pursuit"] = { --Pursuit
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
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local number_cards = {}
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() then
                    table.insert(number_cards, scoring_card)
                end
            end
        end
        local last_number = JokerDisplay.calculate_rightmost_card(number_cards)
        card.joker_display_values.Xmult = last_number and
            (card.ability.extra.Xmult ^ JokerDisplay.calculate_card_triggers(last_number, scoring_hand)) or 1
        card.joker_display_values.localized_text = localize("k_face_cards")
    end
}

JokerDisplay.Definitions["j_bloons_razor_rotors"] = { --Razor Rotors
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_apache_dartship"] = { --Apache Dartship
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(2,3,5,7)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                local id = scoring_card:get_id()
                if id == 2 or id == 3 or id == 5 or id == 7 then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

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

JokerDisplay.Definitions["j_bloons_bigger_jets"] = { --Bigger Jets
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_ifr"] = { --IFR
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    calc_function = function(card)
        local has_j, has_q, has_k = false, false, false
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if not scoring_card.debuff then
                    if scoring_card:get_id() == 11 then
                        has_j = true
                    elseif scoring_card:get_id() == 12 then
                        has_q = true
                    elseif scoring_card:get_id() == 13 then
                        has_k = true
                    end
                end
            end
        end
        card.joker_display_values.count = has_j and has_q and has_k  and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_downdraft"] = { --Downdraft
}

JokerDisplay.Definitions["j_bloons_support_chinook"] = { --Support Chinook
}

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

JokerDisplay.Definitions["j_bloons_faster_darts"] = { --Faster Darts
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
        card.joker_display_values.localized_text = localize("k_face_cards")
    end
}

JokerDisplay.Definitions["j_bloons_faster_firing"] = { --Faster Firing
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
        card.joker_display_values.localized_text = localize("k_face_cards")
    end
}

JokerDisplay.Definitions["j_bloons_moab_shove"] = { --MOAB Shove
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "active_text" },
    },
    calc_function = function(card)
        local boss_active = G.GAME and G.GAME.blind and G.GAME.blind.get_type and G.GAME.blind:get_type() == 'Boss'
        card.joker_display_values.active = boss_active and card.ability.extra.counter > 0
        card.joker_display_values.active_text = boss_active and card.ability.extra.counter > 0 and "active" or boss_active and "inactive" or "no boss active"
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[1] and card.joker_display_values then
            reminder_text.children[1].config.colour = card.joker_display_values.active and G.C.GREEN or
                G.C.RED
            reminder_text.children[1].config.scale = card.joker_display_values.active and 0.35 or 0.3
            return true
        end
        return false
    end
}

JokerDisplay.Definitions["j_bloons_comanche_defense"] = { --Comanche Defense
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
    },
}

JokerDisplay.Definitions["j_bloons_comanche_commander"] = { --Comanche Commander
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
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local number = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() and number < card.ability.extra.number then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    number = number + 1
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
        card.joker_display_values.localized_text = localize("k_face_cards")
    end

}
