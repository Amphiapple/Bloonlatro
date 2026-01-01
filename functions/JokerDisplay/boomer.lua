JokerDisplay.Definitions["j_bloons_boomer"] = { --Boomerang Monkey
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local held_cards = {}

        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end

        local first_card = JokerDisplay.calculate_leftmost_card(held_cards)

        return first_card and playing_card == first_card and
            joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_glaives"] = { --Glaives
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}

JokerDisplay.Definitions["j_bloons_redhot"] = { --Red Hot Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)
        local second_last_card = scoring_hand and #scoring_hand >= 2 and scoring_hand[#scoring_hand - 1]
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

JokerDisplay.Definitions["j_bloons_glord"] = { --Glaive Lord
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}