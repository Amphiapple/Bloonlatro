JokerDisplay.Definitions["j_bloons_spike_factory"] = { --Spike Factory
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.CHIPS }
}

JokerDisplay.Definitions["j_bloons_bigger_stacks"] = { --Bigger Stacks
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.CHIPS }
}

JokerDisplay.Definitions["j_bloons_white_hot_spikes"] = { --White Hot Spikes
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

JokerDisplay.Definitions["j_bloons_spiked_balls"] = { --Spiked Balls
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.CHIPS }
}

JokerDisplay.Definitions["j_bloons_spiked_mines"] = { --Spiked Mines
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

JokerDisplay.Definitions["j_bloons_super_mines"] = { --Super Mines
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.Xmult = #G.deck.cards == 0 and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_faster_production"] = { --Faster Production
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_even_faster_production"] = { --Even Faster Production
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_moab_shredr"] = { --MOAB SHREDR
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_spike_storm"] = { --Spike Storm
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

JokerDisplay.Definitions["j_bloons_carpet_of_spikes"] = { --Carpet of Spikes
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

JokerDisplay.Definitions["j_bloons_long_reach"] = { --Long Reach
}

JokerDisplay.Definitions["j_bloons_smart_spikes"] = { --Smart Spikes
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_long_life_spikes"] = { --Long Life Spikes
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "spike_factory_card_suit" },
        { text = ")" }
    },
    calc_function = function(card)
        card.joker_display_values.spike_factory_card_suit = localize(G.GAME.current_round.spike_factory_card.suit, 'suits_singular')
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[2] then
            reminder_text.children[2].config.colour = lighten(G.C.SUITS[G.GAME.current_round.spike_factory_card.suit], 0.35)
        end
        return false
    end
}

JokerDisplay.Definitions["j_bloons_deadly_spikes"] = { --Deadly Spikes
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "spike_factory_card", colour = G.C.FILTER },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.spike_factory_card = localize{
                type = 'variable', key = "jdis_rank_of_suit", vars = { localize(G.GAME.current_round.spike_factory_card.rank, 'ranks'), localize(G.GAME.current_round.spike_factory_card.suit, 'suits_plural') } }
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[2] then
            reminder_text.children[2].config.colour = lighten(G.C.SUITS[G.GAME.current_round.spike_factory_card.suit], 0.35)
        end
        return false
    end
}

JokerDisplay.Definitions["j_bloons_perma_spike"] = { --Perma Spike
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.BLUE }
}
