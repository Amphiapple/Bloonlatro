JokerDisplay.Definitions["j_bloons_glaive_dominus"] = { --Glaive Dominus
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_goliath_doomship"] = { --Goliath Doomship
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY, retrigger_type = "mult" },
        { text = " +", colour = G.C.SECONDARY_SET.Tarot },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot },
        { text = " +", colour = G.C.SECONDARY_SET.Planet },
        { ref_table = "card.joker_display_values", ref_value = "planets", colour = G.C.SECONDARY_SET.Planet },
    },
    reminder_text = {
        { text = "(Ace)" }
    },
    calc_function = function(card)
        local held_count, scoring_count = 0, 0
        local highlighted_aces = {}
        local _, _, scoring_hand = JokerDisplay.evaluate_hand()
        local playing_hand = next(G.play.cards)
        for _, scoring_card in pairs(scoring_hand) do
            if scoring_card:get_id() == 14 then
                scoring_count = scoring_count + JokerDisplay.calculate_card_triggers(scoring_card, nil, true)
            end
        end
        for _, hand_card in pairs(G.hand.cards) do
            if hand_card:get_id() == 14 then
                if hand_card.highlighted then
                    if not playing_hand then
                        table.insert(highlighted_aces, hand_card)
                    end
                else
                    held_count = held_count + JokerDisplay.calculate_card_triggers(hand_card, nil, true)
                end
            end
        end

        card.joker_display_values.money = card.ability.extra.money * scoring_count
        card.joker_display_values.tarots = #highlighted_aces
        card.joker_display_values.planets = held_count
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        return (playing_card:get_id() == 14) and
            joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_magus_perfectus"] = { --Magus Perfectus
}

JokerDisplay.Definitions["j_bloons_mega_massive_munitions_factory"] = { --Mega Massive Munitions Factory
    text = {
        { text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { ref_table = "card.ability.extra", ref_value = "mines", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { text = " mines)", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        local counter = card.ability.extra.counter
        local limit = card.ability.extra.limit

        card.joker_display_values.active =
            (counter % limit == limit - 1 and "Next!") or ((limit - (counter % limit) - 1) .. " remaining")
    end
}

JokerDisplay.Definitions["j_bloons_vengeful_true_sun_god"] = { --Vengeful True Sun God
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "sacrifices" },
        { text = ")" },
    },
    calc_function = function(card)
        local sacs = card.ability.extra.sacrifices
        card.joker_display_values.sacrifices =
            (sacs["primary"] or 0) .. " " ..
            (sacs["military"] or 0) .. " " ..
            (sacs["magic"] or 0) .. " " ..
            (sacs["support"] or 0)
    end
}
