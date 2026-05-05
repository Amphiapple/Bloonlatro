JokerDisplay.Definitions["j_bloons_mortar_monkey"] = { --Mortar Monkey
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
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
        local count = 0
        if G.play then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_bigger_blast"] = { --Bigger Blast
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
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
        local count = 0
        if G.play then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'bigger_blast')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_bloon_buster"] = { --Bloon Buster
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
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
        local count = 0
        if G.play then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'bloon_buster')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_shell_shock"] = { --Shell Shock
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
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
        local count = 0
        if G.play then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'shell_shock')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_the_big_one"] = { --The Big One
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'the_big_one')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_the_biggest_one"] = { --The Biggest One
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
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
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'the_biggest_one')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_faster_reload"] = { --Faster Reload
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
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
        local count = 0
        if G.play then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'faster_reload')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_rapid_reload"] = { --Rapid Reload
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
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
        local count = 0
        if G.play then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'rapid_reload')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_heavy_shells"] = { --Heavy Shells
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability.name == 'Stunned Card' then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_artillery_battery"] = { --Artillery Battery
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT }
}

JokerDisplay.Definitions["j_bloons_pop_and_awe"] = { --Pop and Awe
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_increased_accuracy"] = { --Increased Accuracy
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS }
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
        local count = 0
        if G.play then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'increased_accuracy')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_burny_stuff"] = { --Burny Stuff
    reminder_text = {
        { text = '(First played card)'}
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
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'burny_stuff')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_signal_flare"] = { --Signal Flare
}

JokerDisplay.Definitions["j_bloons_shattering_shells"] = { --Shattering Shells
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local total_Xmult = 1
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.config.center ~= G.P_CENTERS.c_base or scoring_card.edition or scoring_card.seal then
                    total_Xmult = total_Xmult + card.ability.extra.Xmult
                end
            end
        end
        card.joker_display_values.Xmult = total_Xmult
    end
}

JokerDisplay.Definitions["j_bloons_blooncineration"] = { --Blooncineration
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local total_Xmult = 1
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.config.center ~= G.P_CENTERS.c_base or scoring_card.edition or scoring_card.seal then
                    total_Xmult = total_Xmult + card.ability.extra.Xmult
                end
            end
        end
        card.joker_display_values.Xmult = total_Xmult
    end
}