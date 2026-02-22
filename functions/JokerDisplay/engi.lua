JokerDisplay.Definitions["j_bloons_engi"] = { --Engineer Monkey
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

JokerDisplay.Definitions["j_bloons_sentrygun"] = { --Sentry Gun
}

JokerDisplay.Definitions["j_bloons_doublegun"] = { --Double Gun
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

JokerDisplay.Definitions["j_bloons_sexpert"] = { --Sentry Expert
}

JokerDisplay.Definitions["j_bloons_uboost"] = { --Ultraboost
}