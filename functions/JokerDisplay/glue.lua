JokerDisplay.Definitions["j_bloons_glue_gunner"] = { --Glue Monkey
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },

    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local first_card

        if text ~= "Unknown" then
            first_card = JokerDisplay.calculate_leftmost_card(scoring_hand)
        end
        card.joker_display_values.mult = first_card and
            (card.ability.extra.mult * JokerDisplay.calculate_card_triggers(first_card, scoring_hand)) or 0
    end
}

JokerDisplay.Definitions["j_bloons_glue_soak"] = { --Glue Soak
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'glue_soak')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_corrosive_glue"] = { --Corrosive Glue
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_bloon_dissolver"] = { --Bloon Dissolver
}

JokerDisplay.Definitions["j_bloons_bloon_liquefier"] = { --Bloon Liquefier
    text = {
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
                if scoring_card.ability.name == 'Glued Card' then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end,
}

JokerDisplay.Definitions["j_bloons_the_bloon_solver"] = { --The Bloon Solver
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" },
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_bigger_globs"] = { --Bigger Globs
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult" },
    },
    text_config = { colour = G.C.MULT },
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

JokerDisplay.Definitions["j_bloons_glue splatter"] = { --Glue Splatter
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult" },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_glue_hose"] = { --Glue Hose
}

JokerDisplay.Definitions["j_bloons_glue_strike"] = { --Glue Strike
}

JokerDisplay.Definitions["j_bloons_glue_storm"] = { --Glue Storm
}

JokerDisplay.Definitions["j_bloons_stickier_glue"] = { --Stickier Glue
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },

    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local first_card

        if text ~= "Unknown" then
            first_card = JokerDisplay.calculate_leftmost_card(scoring_hand)
        end
        card.joker_display_values.mult = first_card and
            (card.ability.extra.mult * JokerDisplay.calculate_card_triggers(first_card, scoring_hand)) or 0
    end
}

JokerDisplay.Definitions["j_bloons_stronger_glue"] = { --Stronger Glue
    text = {
        { text = "+"},
        { ref_table = "card.joker_display_values", ref_value = "mult" },
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Glued Card' and not scoring_card.debuff then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_moab_glue"] = { --Moab Glue
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "active_text" },
    },
    calc_function = function(card)
        local boss_active = G.GAME and G.GAME.blind and G.GAME.blind.get_type and
            ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))
        card.joker_display_values.active = boss_active

        card.joker_display_values.Xmult = boss_active and card.ability.extra.Xmult or 1
        card.joker_display_values.active_text = boss_active and "active" or "no boss active"
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[1] and card.joker_display_values then
            reminder_text.children[1].config.colour = card.joker_display_values.active and G.C.GREEN or
                G.C.RED
            reminder_text.children[1].config.scale = card.joker_display_values.active and 0.35 or 0.3
            return true
        end
        return false
    end
}

JokerDisplay.Definitions["j_bloons_relentless_glue"] = { --Relentless Glue
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return SMODS.in_scoring(playing_card, scoring_hand) and
                playing_card.ability.name == 'Glued Card' and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end,
}

JokerDisplay.Definitions["j_bloons_super_glue"] = { --Super Glue
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
                if scoring_card.ability.name == 'Glued Card' and not scoring_card.debuff then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end
}