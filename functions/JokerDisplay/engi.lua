JokerDisplay.Definitions["j_bloons_engineer_monkey"] = { --Engineer Monkey
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(" },
        { text = "Straight, Flush", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local money = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()

        if poker_hands['Straight'] and poker_hands['Flush'] then
            if next(poker_hands['Straight']) and next(poker_hands['Flush']) then
                money = card.ability.extra.money * 2
            elseif next(poker_hands['Straight']) or next(poker_hands['Flush']) then
                money = card.ability.extra.money
            end
        end

        card.joker_display_values.money = money
    end
}

JokerDisplay.Definitions["j_bloons_sentry_gun"] = { --Sentry Gun
}

JokerDisplay.Definitions["j_bloons_faster_engineering"] = { --Faster Engineering
}

JokerDisplay.Definitions["j_bloons_sprockets"] = { --Sprockets
}

JokerDisplay.Definitions["j_bloons_sentry_expert"] = { --Sentry Expert
}

JokerDisplay.Definitions["j_bloons_sentry_champion"] = { --Sentry Champion
}

JokerDisplay.Definitions["j_bloons_larger_service_area"] = { --Larger Service Area
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        card.joker_display_values.money = text ~= 'Unknown' and #scoring_hand == 5 and card.ability.extra.money or 0
    end
}

JokerDisplay.Definitions["j_bloons_deconstruction"] = { --Deconstruction
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count",          colour = G.C.ORANGE },
        { text = "x" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.YELLOW },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if card.ability.base == 'engi' or card.ability.base == 'sentry' then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
        card.joker_display_values.localized_text = 'Engi/Sentry'
    end,
    mod_function = function(card, mod_joker)
        return { mult = ((card.ability.base == 'engi' or card.ability.base == 'sentry') and mod_joker.ability.extra.mult * JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

JokerDisplay.Definitions["j_bloons_cleansing_foam"] = { --Cleansing Foam
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_overclock"] = { --Overclock
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
        { ref_table = "card.ability.extra", ref_value = "hands" },
        { text = "/10)" },
    },
}

JokerDisplay.Definitions["j_bloons_ultraboost"] = { --Ultraboost
}

JokerDisplay.Definitions["j_bloons_oversize_nails"] = { --Oversize Nails
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(" },
        { text = "Straight, Flush", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local money = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()

        if poker_hands['Straight'] and poker_hands['Flush'] then
            if next(poker_hands['Straight']) and next(poker_hands['Flush']) then
                money = card.ability.extra.money * 2
            elseif next(poker_hands['Straight']) or next(poker_hands['Flush']) then
                money = card.ability.extra.money
            end
        end

        card.joker_display_values.money = money
    end
}

JokerDisplay.Definitions["j_bloons_pin"] = { --Pin
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_double_gun"] = { --Double Gun
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY }
    },
    calc_function = function(card)
        local held_cards = {}

        for i = 1, #G.hand.cards do
            local hand_card = G.hand.cards[i]
            if not hand_card.highlighted and hand_card.facing ~= 'back' then
                table.insert(held_cards, hand_card)
            end
        end

        local idx_by_id = {}
        local count = 0

        for i = 1, #held_cards do
            local held_card = held_cards[i]
            local id = held_card:get_id()
            local prev_idx = idx_by_id[id]

            if prev_idx then
                count = count + JokerDisplay.calculate_card_triggers(held_card, nil, true)
                idx_by_id[id] = nil
            else
                idx_by_id[id] = i
            end
        end
        card.joker_display_values.money = count * card.ability.extra.money
    end
}

JokerDisplay.Definitions["j_bloons_bloon_trap"] = { --Bloon Trap
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY }
    },
}

JokerDisplay.Definitions["j_bloons_xxxl_trap"] = { --XXXL Trap
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY }
    },
}