JokerDisplay.Definitions["j_bloons_spac"] = { --Spike Factory
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.CHIPS }
}

JokerDisplay.Definitions["j_bloons_stacks"] = { --Bigger Stacks
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.CHIPS }
}

JokerDisplay.Definitions["j_bloons_whitehot"] = { --White Hot Spikes
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips" },
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        card.joker_display_values.chips = card.ability.extra.chips *
            (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left == card.ability.extra.discards and 1 or 0)
    end
}

JokerDisplay.Definitions["j_bloons_spalls"] = { --Spiked Balls
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.CHIPS }
}

JokerDisplay.Definitions["j_bloons_spines"] = { --Spiked Mines
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.Xmult = G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left == 0 and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_fastspac"] = { --Faster Production
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_evenspac"] = { --Even Faster Production
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_shredr"] = { --MOAB SHREDR
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_sporm"] = { --Spike Storm
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x",                              scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local count = 0
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
            card.joker_display_values.count = count
            card.joker_display_values.active = "Active!"
            card.joker_display_values.Xmult = card.ability.extra.Xmult
        else
            card.joker_display_values.count = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.Xmult = 1
        end
    end
}

JokerDisplay.Definitions["j_bloons_cos"] = { --Carpet of Spikes
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult * count *
                (G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left == card.ability.extra.discards and 1 or 0)
    end
}

JokerDisplay.Definitions["j_bloons_rangespac"] = { --Long Reach
}

JokerDisplay.Definitions["j_bloons_smart"] = { --Smart Spikes
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_lls"] = { --Long Life Spikes
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_deadly"] = { --Deadly Spikes
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_pspike"] = { --Perma Spike
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.BLUE }
}
