JokerDisplay.Definitions["j_bloons_desperado"] = { --Desperado
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(First " },
        { ref_table = "card.ability.extra", ref_value = "number" },
        { text = " cards)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for i = 1, math.min(card.ability.extra.number, #scoring_hand) do
                local scoring_card = scoring_hand[i]
                if scoring_card then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_quickdraw"] = { --Quickdraw
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(First " },
        { ref_table = "card.ability.extra", ref_value = "number" },
        { text = " cards)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local playing_hand = next(G.play.cards)
        local unscoring = 0
        if playing_hand then
            for k, v in ipairs(G.play.cards) do
                if not SMODS.in_scoring(v, scoring_hand) then
                    unscoring = unscoring + 1
                end
            end
            for i = 1, math.min(card.ability.extra.number, #scoring_hand) do
                local scoring_card = scoring_hand[i]
                if scoring_card then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        elseif text ~= 'Unknown' then
            unscoring = #G.hand.highlighted - #scoring_hand
            for i = 1, math.min(card.ability.extra.number, #scoring_hand) do
                local scoring_card = scoring_hand[i]
                if scoring_card then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count * unscoring
    end
}

JokerDisplay.Definitions["j_bloons_standoff"] = { --Standoff
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(First " },
        { ref_table = "card.ability.extra", ref_value = "number" },
        { text = " cards)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local playing_hand = next(G.play.cards)
        local missing = 0
        if playing_hand then
            missing = 5 - #G.play.cards
            for i = 1, math.min(card.ability.extra.number, #scoring_hand) do
                local scoring_card = scoring_hand[i]
                if scoring_card then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        elseif text ~= 'Unknown' then
            missing = 5 - #G.hand.highlighted
            for i = 1, math.min(card.ability.extra.number, #scoring_hand) do
                local scoring_card = scoring_hand[i]
                if scoring_card then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count * missing
    end
}

JokerDisplay.Definitions["j_bloons_big_iron"] = { --Big Iron
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(6)" },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 6 and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end

        card.joker_display_values.mult = count >= 1 and card.ability.extra.mult or 0
    end
}

JokerDisplay.Definitions["j_bloons_twin_sixes"] = { --Twin Sixes
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "number", colour = G.C.ORANGE },
        { text = " 6s", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 6 and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end

        card.joker_display_values.Xmult = count >= card.ability.extra.number and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_the_blazing_sun"] = { --The Blazing Sun
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
        { ref_table = "card.joker_display_values", ref_value = "desperado_card", colour = G.C.FILTER },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_suit('Hearts') and scoring_card:get_id() and scoring_card:get_id() == G.GAME.current_round.desperado_card.id then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
        card.joker_display_values.desperado_card = localize { type = 'variable', key = "jdis_rank_of_suit", vars = { localize(G.GAME.current_round.desperado_card.rank, 'ranks'), localize('Hearts', 'suits_plural') } }
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[2] then
            reminder_text.children[2].config.colour = lighten(G.C.SUITS['Hearts'], 0.35)
        end
        return false
    end
}

JokerDisplay.Definitions["j_bloons_eagle_eye"] = { --Eagle Eye
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "desperado_card_rank", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for i = 1, math.min(card.ability.extra.number, #scoring_hand) do
                local scoring_card = scoring_hand[i]
                if scoring_card then
                    if scoring_card:get_id() == G.GAME.current_round.desperado_card.id then
                        mult = mult + card.ability.extra.mark_mult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    else
                        mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
            end
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.desperado_card_rank = localize(G.GAME.current_round.desperado_card.rank, 'ranks')
    end
}

JokerDisplay.Definitions["j_bloons_bullseye"] = { --Bullseye
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "desperado_card_rank", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for i = 1, math.min(card.ability.extra.number, #scoring_hand) do
                local scoring_card = scoring_hand[i]
                if scoring_card then
                    if scoring_card:get_id() == G.GAME.current_round.desperado_card.id then
                        mult = mult + card.ability.extra.mark_mult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    else
                        mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
            end
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.desperado_card_rank = localize(G.GAME.current_round.desperado_card.rank, 'ranks')
    end
}

JokerDisplay.Definitions["j_bloons_deadeye"] = { --Deadeye
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "desperado_card_rank", },
        { text = ")" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() and scoring_card:get_id() == G.GAME.current_round.desperado_card.id then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
        card.joker_display_values.desperado_card_rank = localize(G.GAME.current_round.desperado_card.rank, 'ranks')
    end
}

JokerDisplay.Definitions["j_bloons_bounty_hunter"] = { --Bounty Hunter
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult", colour = G.C.MONEY },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "desperado_card_rank", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local dollars = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() and scoring_card:get_id() == G.GAME.current_round.desperado_card.id then
                    dollars = dollars + card.ability.extra.money * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.dollars = dollars
        card.joker_display_values.desperado_card_rank = localize(G.GAME.current_round.desperado_card.rank, 'ranks')
    end
}

JokerDisplay.Definitions["j_bloons_golden_justice"] = { --Golden Justice
}

JokerDisplay.Definitions["j_bloons_wanderer"] = { --Wanderer
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    },
}

JokerDisplay.Definitions["j_bloons_nomad"] = { --Nomad
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.poker_hand = card.ability.extra.poker_hand ~= "" and card.ability.extra.poker_hand or "None"
    end
}

JokerDisplay.Definitions["j_bloons_enforcer"] = { --Enforcer
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_avenger"] = { --Avenger
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "ranks" },
        { text = ")" },
    },
    calc_function = function(card)
        local rank_string = ' '
        if next(card.ability.extra.ranks) == nil then
            rank_string = 'None'
        end
        for k, v in pairs(card.ability.extra.ranks) do
            rank_string = rank_string .. v .. ' '
        end
        card.joker_display_values.ranks = rank_string
    end
}

JokerDisplay.Definitions["j_bloons_the_desert_phantom"] = { --The Desert Phantom
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
}
