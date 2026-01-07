JokerDisplay.Definitions["j_bloons_boomer"] = { --Boomerang Monkey
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)
        return last_card and playing_card == last_card and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_improved"] = { --Improved Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end 
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)
        local second_last_card = scoring_hand and #scoring_hand >= 2 and scoring_hand[#scoring_hand - 1]
        return ((last_card and playing_card == last_card) or (second_last_card and playing_card == second_last_card)) and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_glaives"] = { --Glaives
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}

JokerDisplay.Definitions["j_bloons_rico"] = { --Glaive Ricochet
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}

JokerDisplay.Definitions["j_bloons_moar"] = { --MOAR Glaives
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}

JokerDisplay.Definitions["j_bloons_glord"] = { --Glaive Lord
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}

JokerDisplay.Definitions["j_bloons_fastboomer"] = { --Faster Throwing
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end
        local last_card = JokerDisplay.calculate_rightmost_card(held_cards)
        return last_card and playing_card == last_card and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_fastrangs"] = { --Faster Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end
        local last_card = JokerDisplay.calculate_rightmost_card(held_cards)
        local second_last_card = held_cards and #held_cards >= 2 and held_cards[#held_cards - 1]
        return ((last_card and playing_card == last_card) or (second_last_card and playing_card == second_last_card)) and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_bioboomer"] = { --Bionic Boomerang
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(" },
        { text = "Steel", colour = G.C.ORANGE },
        { text = ")" }
    }
}

JokerDisplay.Definitions["j_bloons_tcharge"] = { --Turbo Charge
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = G.GAME and
                ((G.GAME.current_round.hands_left == 1 and not next(G.play.cards)) or
                (G.GAME.current_round.hands_left == 0 and next(G.play.cards))) and "Active!" or "Inactive"
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end
        local last_card = JokerDisplay.calculate_rightmost_card(held_cards)
        return last_card and playing_card == last_card and
                ((G.GAME.current_round.hands_left == 1 and not next(G.play.cards)) or
                (G.GAME.current_round.hands_left == 0 and next(G.play.cards))) and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}


JokerDisplay.Definitions["j_bloons_pcharge"] = { --Perma Charge
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end
        local last_card = JokerDisplay.calculate_rightmost_card(held_cards)
        return last_card and playing_card == last_card and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_rangerangs"] = { --Long Range Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
        return first_card and playing_card == first_card and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_redhot"] = { --Red Hot Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)

        return ((first_card and playing_card == first_card) or (last_card and playing_card == last_card)) and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_kylie"] = { --Kylie Boomerang
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)

        return last_card and playing_card ~= last_card and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_press"] = { --MOAB Press
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "active_text" },
    },
    calc_function = function(card)
        local boss_active = G.GAME and G.GAME.blind and G.GAME.blind.get_type and
                ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))
        card.joker_display_values.active = boss_active
        card.joker_display_values.active_text = localize(boss_active and 'k_active' or 'ph_no_boss_active')
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return SMODS.in_scoring(playing_card, scoring_hand) and joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[1] and card.joker_display_values then
            reminder_text.children[1].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.RED
            reminder_text.children[1].config.scale = card.joker_display_values.active and 0.35 or 0.3
            return true
        end
        return false
    end
}

--[[
JokerDisplay.Definitions["j_bloons_press"] = { --MOAB Press
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "active_text" },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local will_apply = false
        local boss_active = G.GAME and G.GAME.blind and G.GAME.blind.get_type and
            ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))

        will_apply = #G.hand.highlighted == 1 and scoring_hand and scoring_hand[1]

        card.joker_display_values.active = boss_active and will_apply

        card.joker_display_values.active_text = boss_active and will_apply and "active" or boss_active and "inactive" or "no boss active"
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
]]