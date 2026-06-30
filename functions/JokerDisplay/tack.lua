JokerDisplay.Definitions["j_bloons_tack_shooter"] = { --Tack Shooter
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(8)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 8 then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
        card.joker_display_values.mult = card.ability.extra.mult * count
    end,
}

JokerDisplay.Definitions["j_bloons_faster_shooting_tack"] = { --Faster Shooting
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(8)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 8 then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
        card.joker_display_values.mult = card.ability.extra.mult * count
    end,
}

JokerDisplay.Definitions["j_bloons_even_faster_shooting"] = { --Even Faster Shooting
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(8)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 8 then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end,
}

JokerDisplay.Definitions["j_bloons_hot_shots"] = { --Hot Shots
    text = {
        { text = "(8)", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_played == 0 and "Active!" or "Inactive"
    end
}

JokerDisplay.Definitions["j_bloons_ring_of_fire"] = { --Ring of Fire
}

JokerDisplay.Definitions["j_bloons_inderno_ring"] = { --Inferno Ring
}

JokerDisplay.Definitions["j_bloons_long_range_tacks"] = { --Long Range Tacks
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(7, 8, 9)" }
    }
}

JokerDisplay.Definitions["j_bloons_super_range_tacks"] = { --Super Range Tacks
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(Odd)" }
    }
}

JokerDisplay.Definitions["j_bloons_blade_shooter"] = { --Blade Shooter
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { text = "3 Odd Cards", colour = G.C.ORANGE },
        { text = ")" },
    }
}

JokerDisplay.Definitions["j_bloons_blade_maelstrom"] = { --Blade Maelstrom
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x",                              scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { text = "Number Cards", colour = G.C.ORANGE },
        { text = ")" },
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() >= 0 and (scoring_card:get_id() <= 10 or scoring_card:get_id() == 14) then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mael')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

JokerDisplay.Definitions["j_bloons_super_maelstrom"] = { --Super Maelstrom
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_more_tacks"] = { --More Tacks
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(4, 8)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 4 or scoring_card:get_id() == 8 then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
        card.joker_display_values.mult = card.ability.extra.mult * count
    end,
}

JokerDisplay.Definitions["j_bloons_even_more_tacks"] = { --Even More Tacks
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(2, 4, 6, 8)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 2 or
                    scoring_card:get_id() == 4 or
                    scoring_card:get_id() == 6 or
                    scoring_card:get_id() == 8 then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
        card.joker_display_values.mult = card.ability.extra.mult * count
    end,
}

JokerDisplay.Definitions["j_bloons_tack_sprayer"] = { --Tack Sprayer
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    reminder_text = {
        { text = "(Even)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                 if scoring_card:get_id() == 2 or
                    scoring_card:get_id() == 4 or
                    scoring_card:get_id() == 6 or
                    scoring_card:get_id() == 8 or
                    scoring_card:get_id() == 10 then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
        card.joker_display_values.mult = card.ability.extra.mult * count
    end,
}

JokerDisplay.Definitions["j_bloons_overdrive"] = { --Overdrive
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
    reminder_text = {
        { text = "(8)" }
    }
}

JokerDisplay.Definitions["j_bloons_the_tack_zone"] = { --The Tack Zone
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(Sum to 32)" }
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local sum = 0
        if playing_hand then
            for _, playing_card in ipairs(G.play.cards) do
                if not SMODS.has_no_rank(playing_card) then
                    sum = sum + playing_card.base.nominal
                end
            end
        else
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_card.highlighted then
                    if not (playing_card.facing == 'back') and not SMODS.has_no_rank(playing_card) then
                        sum = sum + playing_card.base.nominal
                    end
                end
            end
        end
        card.joker_display_values.Xmult = sum == 32 and card.ability.extra.Xmult or 1
    end,
}
