JokerDisplay.Definitions["j_bloons_sub"] = { --Monkey Sub
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local mult = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                    mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.mult = mult
    end
}

JokerDisplay.Definitions["j_bloons_intel"] = { --Advanced Intel
}

JokerDisplay.Definitions["j_bloons_tripguns"] = { --Triple guns
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_fs"] = { --First Strike Capability
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_gizer"] = { --Energizer
}