JokerDisplay.Definitions["j_bloons_wiz"] = { --Wizard Monkey
}

JokerDisplay.Definitions["j_bloons_guided"] = { --Guided Magic
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "enhancement", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.enhancement = card.ability.extra.enhancement.effect or card.ability.extra.enhancement.name
    end
}

JokerDisplay.Definitions["j_bloons_ablast"] = { --Arcane Blast
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(Enhanced)" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.config.center ~= G.P_CENTERS.c_base then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
    end
}

JokerDisplay.Definitions["j_bloons_amast"] = { --Arcane Mastery
}

JokerDisplay.Definitions["j_bloons_aspike"] = { --Arcane Spike
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local new_enhancement = true
        local e = playing_card.config.center.name
        for k, v in pairs(joker_card.ability.extra.enhancements) do
            if e == k then
                new_enhancement = false
            end
        end
        return new_enhancement and joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_arch"] = { --Archmage
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return playing_card.config.center ~= G.P_CENTERS.c_base and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_fireball"] = { --Fireball
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { text = "(Stone Card)", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Stone Card' then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_wof"] = { --Wall of Fire
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.demon, 'wof')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

JokerDisplay.Definitions["j_bloons_dbreath"] = { --Dragon's Breath
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_phoenix"] = { --Summon Phoenix
}

JokerDisplay.Definitions["j_bloons_wlp"] = { --Wizard Lord Phoenix
}

JokerDisplay.Definitions["j_bloons_intense"] = { --Intense Magic
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(Enhanced)" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.config.center ~= G.P_CENTERS.c_base then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_sense"] = { --Monkey Sense
}

JokerDisplay.Definitions["j_bloons_shimmer"] = { --Shimmer
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.demon, 'wof')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

JokerDisplay.Definitions["j_bloons_necro"] = { --Necromancer: Unpopped Army
}

JokerDisplay.Definitions["j_bloons_pod"] = { --Prince of Darkness
}
