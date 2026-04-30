JokerDisplay.Definitions["j_bloons_marine"] = { --Marine
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "duration" },
        { text = ")" }
    },
    calc_function = function(card)
        card.joker_display_values.duration = card.ability.extra.hands .. " hand" .. (card.ability.extra.hands ~= 1 and "s" or "") .. " left"
    end
}

JokerDisplay.Definitions["j_bloons_sentry"] = { --Nail Sentry
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "duration" },
        { text = ")" }
    },
    calc_function = function(card)
        card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
    end
}

JokerDisplay.Definitions["j_bloons_crushing_sentry"] = { --Crushing Sentry
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT, retrigger_type = "mult"}
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "duration" },
        { text = ")" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                count = count +
                    JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
        card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
    end
}

JokerDisplay.Definitions["j_bloons_boom_sentry"] = { --Boom Sentry
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
        { ref_table = "card.joker_display_values", ref_value = "duration" },
        { text = ")" }
    },
    calc_function = function(card)
        local held_cards = {}

        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end

        local first_card = JokerDisplay.calculate_leftmost_card(held_cards)
        local count = first_card and JokerDisplay.calculate_card_triggers(first_card, nil, true) or 0

        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
        card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
    end
}

JokerDisplay.Definitions["j_bloons_cold_sentry"] = { --Cold Sentry
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "duration" },
        { text = ")" }
    },
    calc_function = function(card)
        card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
    end,

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

JokerDisplay.Definitions["j_bloons_energy_sentry"] = { --Energy Sentry
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "duration" },
        { text = ")" }
    },
    calc_function = function(card)
        card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
    end
}

JokerDisplay.Definitions["j_bloons_champion_sentry"] = { --Champion Sentry
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "duration" },
        { text = ")" }
    },
    calc_function = function(card)
        card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
    end
}

JokerDisplay.Definitions["j_bloons_mega_green_sentry"] = { --Mega Green Sentry
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
        local Xmult = 1
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            Xmult = card.ability.extra.Xmult
        end
        card.joker_display_values.Xmult = Xmult
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_mega_red_sentry"] = { --Mega Red Sentry
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
        local Xmult = 1
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            Xmult = card.ability.extra.Xmult
        end
        card.joker_display_values.Xmult = Xmult
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_mega_blue_sentry"] = { --Mega Blue Sentry
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "active_text" },
    },
    calc_function = function(card)
        local boss_active = G.GAME and G.GAME.blind and G.GAME.blind.get_type and G.GAME.blind:get_type() == 'Boss'
        card.joker_display_values.active = boss_active
        card.joker_display_values.Xmult = boss_active and card.ability.extra.Xmult or 1
        card.joker_display_values.active_text = boss_active and "active" or "no boss active"
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

JokerDisplay.Definitions["j_bloons_bloonprint"] = {--Bloonprint
    text = {
        { text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED, scale = 0.3 },
        { text = ")", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
    },
    reminder_text = {
        { text = "(Position " },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
        card.joker_display_values.blueprint_compat = localize('k_incompatible')
        JokerDisplay.copy_display(card, copied_joker, copied_debuff)
    end,
    get_blueprint_joker = function(card)
        return G.jokers.cards[card.ability.extra.current] or nil
    end
}

JokerDisplay.Definitions["j_bloons_card_storm"] = {--Card Storm
    text = {
        { text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED, scale = 0.3 },
        { text = ")", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "copy_pos", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
        card.joker_display_values.blueprint_compat = localize('k_incompatible')
        card.joker_display_values.copy_pos = card.ability.extra.current == 1 and 'rightmost' or 'leftmost'
        JokerDisplay.copy_display(card, copied_joker, copied_debuff)
    end,
    get_blueprint_joker = function(card)
        local other_joker = nil
        if card.ability.extra.current == 1 then
            other_joker = G.jokers.cards[#G.jokers.cards]
        else
            other_joker = G.jokers.cards[1]
        end
        return other_joker
    end
}
