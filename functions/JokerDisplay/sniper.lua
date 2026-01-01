JokerDisplay.Definitions["j_bloons_sniper"] = { --Sniper Monkey
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.active = "Active!"
        else
            card.joker_display_values.mult = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_shraps"] = { --Shrapnel Shot
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local mult_value = 0
        local right_card = nil

        if text ~= 'Unknown' and #scoring_hand >= 2 then
            local mult_card = scoring_hand[#scoring_hand - 1]
            if mult_card.facing ~= 'back' then
                mult_value = mult_card.base.nominal
            end
            right_card = JokerDisplay.calculate_rightmost_card(scoring_hand)
        end

        card.joker_display_values.mult = right_card and JokerDisplay.calculate_card_triggers(right_card, scoring_hand, false) * mult_value or 0
    end
}

JokerDisplay.Definitions["j_bloons_dprec"] = { --Deadly Precision
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.active = "Next!"
            card.joker_display_values.Xmult = card.ability.extra.Xmult
        else
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.Xmult = 1
        end
    end
}

JokerDisplay.Definitions["j_bloons_supply"] = { --Supply Drop
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Tarot },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.active = "Next!"
            card.joker_display_values.tarots = 1
        else
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.tarots = 0
        end
    end
}

JokerDisplay.Definitions["j_bloons_edef"] = { --Elite Defender
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        if G.STATE and G.STATE ~= G.STATES.SELECTING_HAND then
            local state = G.STATE == G.STATES.HAND_PLAYED or G.STATE == G.STATES.DRAW_TO_HAND
            card.joker_display_values.Xmult = state and card.joker_display_values and card.joker_display_values.Xmult or 1
            return
        end

        local Xmult = 1
        if G.GAME.current_round.hands_left <= 1 then
            if G.GAME.chips/G.GAME.blind.chips <= to_big(0.25) then
                Xmult = card.ability.extra.Xmult3
            else
                Xmult = card.ability.extra.Xmult2
            end
        elseif G.GAME.current_round.hands_played ~= 0 then
            Xmult = card.ability.extra.Xmult1
        end

        card.joker_display_values.Xmult = Xmult
    end
}