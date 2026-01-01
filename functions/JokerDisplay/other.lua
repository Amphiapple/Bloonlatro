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

JokerDisplay.Definitions["j_bloons_cold_sentry"] = {--Cold Sentry
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

JokerDisplay.Definitions["j_bloons_energy_sentry"] = {--Energy Sentry
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