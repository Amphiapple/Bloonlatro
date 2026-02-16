JokerDisplay.Definitions["j_bloons_beast"] = { --Beast Handler
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.CHIPS },
}

JokerDisplay.Definitions["j_bloons_piranha"] = { --Piranha
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
                if scoring_card.ability.name == 'Bonus' and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.mult = count >= 1 and card.ability.extra.mult or 0
    end
}

JokerDisplay.Definitions["j_bloons_barracuda"] = { --Barracuda
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
                if scoring_card.ability.name == 'Bonus' and not scoring_card.debuff then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_greatwhite"] = { --Great White
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local retrigger = false
        local idx
        for i, card in ipairs(scoring_hand) do
            if card == playing_card then
                idx = i
                break
            end
        end
        if idx then
            local left  = scoring_hand[idx-1]
            local right = scoring_hand[idx+1]
            retrigger =
                (left  and left.ability  and left.ability.name  == "Bonus") or
                (right and right.ability and right.ability.name == "Bonus")
        end
        return retrigger and joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_orca"] = { --Orca
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.Xmult = card.ability.extra.number >= card.ability.extra.limit and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_meg"] = { --Megalodon
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
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
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Bonus' and not scoring_card.debuff then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'meg')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_micro"] = { --Microraptor
    text = {
        { text = "+"},
        { ref_table = "card.joker_display_values", ref_value = "chips" },
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Mult' and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.chips = count >= 1 and card.ability.extra.chips or 0
    end
}

JokerDisplay.Definitions["j_bloons_ada"] = { --Adasaurus
    text = {
        { text = "+"},
        { ref_table = "card.joker_display_values", ref_value = "chips" },
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Mult' and not scoring_card.debuff then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
    end
}

JokerDisplay.Definitions["j_bloons_velo"] = { --Velociraptor
    text = {
        { text = "+"},
        { ref_table = "card.joker_display_values", ref_value = "planets" },
    },
    text_config = { colour = G.C.SECONDARY_SET.Planet },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Mult' and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.planets = count >= card.ability.extra.number and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_trex"] = { --Tyrannosaurus Rex
}

JokerDisplay.Definitions["j_bloons_giga"] = { --Giganotosaurus
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
            { text = "x",                              scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult1" },
            },
        },
        { text = "-" },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult2" },
            },
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
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Mult' and not scoring_card.debuff then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'giga')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_gyrfalcon"] = { --Gyrfalcon
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Wild Card' and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.chips = count >= 1 and card.ability.extra.chips or 0
        card.joker_display_values.mult = count >= 1 and card.ability.extra.mult or 0
    end
}

JokerDisplay.Definitions["j_bloons_owl"] = { --Horned Owl
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "tarots" },
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Wild Card' and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.tarots = count >= 1 and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_geagle"] = { --Golden Eagle
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return playing_card.ability.name == 'Wild Card' and joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_condor"] = { --Giant Condor
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'condor')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_pouakai"] = { --Pouākai
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}