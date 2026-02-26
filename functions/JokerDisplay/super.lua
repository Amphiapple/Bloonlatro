JokerDisplay.Definitions["j_bloons_super_monkey"] = { --Super Monkey
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_super_range"] = { --Super Range
}

JokerDisplay.Definitions["j_bloons_ultravision"] = { --Ultravision
}

JokerDisplay.Definitions["j_bloons_sun_avatar"] = { --Sun Avatar
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        local total_Xmult = 1

        for _, consumable in ipairs(G.consumeables.cards) do
            local center_key = consumable.config and consumable.config.center_key
            if center_key and G.P_CENTERS[center_key] and G.P_CENTERS[center_key].set == "Planet" then
                local hand_type = G.P_CENTERS[center_key].config.hand_type
                total_Xmult = total_Xmult * (hand_type == text and card.ability.extra.Xmult_match or card.ability.extra.Xmult)
            end
        end

        card.joker_display_values.Xmult = total_Xmult
    end
}

JokerDisplay.Definitions["j_bloons_tech_terror"] = { --Tech Terror
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
        local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)
        return first_card and last_card and playing_card ~= first_card and playing_card ~= last_card and
            joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_legend_of_the_night"] = { --Legend of the Night
}