JokerDisplay.Definitions["j_bloons_boomerang_monkey"] = { --Boomerang Monkey
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)
        return last_card and playing_card == last_card and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_improved_rangs"] = { --Improved Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
        local last_card = scoring_hand and sorted_cards[#sorted_cards]
        local second_last_card = scoring_hand and #scoring_hand >= 2 and sorted_cards[#sorted_cards - 1]
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

JokerDisplay.Definitions["j_bloons_glaive_ricochet"] = { --Glaive Ricochet
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}

JokerDisplay.Definitions["j_bloons_moar_glaives"] = { --MOAR Glaives
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}

JokerDisplay.Definitions["j_bloons_glaive_lord"] = { --Glaive Lord
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    }
}

JokerDisplay.Definitions["j_bloons_faster_throwing_boomerang"] = { --Faster Throwing
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

JokerDisplay.Definitions["j_bloons_faster_rangs"] = { --Faster Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end
        local sorted_cards = JokerDisplay.sort_cards(held_cards)
        local last_card = held_cards and sorted_cards[#sorted_cards]
        local second_last_card = held_cards and #held_cards >= 2 and sorted_cards[#sorted_cards - 1]
        return ((last_card and playing_card == last_card) or (second_last_card and playing_card == second_last_card)) and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_bionic_boomerang"] = { --Bionic Boomerang
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        return held_in_hand and playing_card.ability.name == 'Steel Card' and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_turbo_charge"] = { --Turbo Charge
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        local active = G.GAME and (G.GAME.current_round.hands_left == 1 and not next(G.play.cards) or G.GAME.current_round.hands_left == 0 and next(G.play.cards))
        card.joker_display_values.active = active and "Active!" or "Inactive"
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local active = G.GAME and (G.GAME.current_round.hands_left == 1 and not next(G.play.cards) or G.GAME.current_round.hands_left == 0 and next(G.play.cards))
        return held_in_hand and active and joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}


JokerDisplay.Definitions["j_bloons_perma_charge"] = { --Perma Charge
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

JokerDisplay.Definitions["j_bloons_long_range_rangs"] = { --Long Range Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
        return first_card and playing_card == first_card and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_red_hot_rangs"] = { --Red Hot Rangs
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)

        local retriggers = 0
        if (first_card and playing_card == first_card) then
            retriggers = retriggers + JokerDisplay.calculate_joker_triggers(joker_card)
        end
        if (last_card and playing_card == last_card) then
            retriggers = retriggers + JokerDisplay.calculate_joker_triggers(joker_card)
        end
        return retriggers * JokerDisplay.calculate_joker_triggers(joker_card)
    end
}

JokerDisplay.Definitions["j_bloons_kylie_boomerang"] = { --Kylie Boomerang
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)
        return first_card and last_card and playing_card ~= first_card and playing_card ~= last_card and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_moab_press"] = { --MOAB Press
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

JokerDisplay.Definitions["j_bloons_moab_domination"] = { --MOAB Domination
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
        if text ~= 'Unknown' then
            for k, v in ipairs(sorted_cards) do
                local last_card = sorted_cards[k-1] or nil
                if (last_card and v:get_id() <= last_card:get_id() or SMODS.has_no_rank(v)) and not v.debuff then
                    count = count + JokerDisplay.calculate_card_triggers(v, scoring_hand)
                    break
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local last_card = nil
        local active = true
        local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
        for k, v in ipairs(sorted_cards) do
            last_card = sorted_cards[k-1]
            if last_card and v:get_id() <= last_card:get_id() or SMODS.has_no_rank(v) and not v.debuff then
                active = false
            end
            if v == playing_card then
                return SMODS.in_scoring(playing_card, scoring_hand) and active and joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end
        end
    end,
}
