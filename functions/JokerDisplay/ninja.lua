JokerDisplay.Definitions["j_bloons_ninja_monkey"] = { --Ninja Monkey
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_ninja_discipline"] = { --Ninja Discipline
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
    }
}

JokerDisplay.Definitions["j_bloons_sharp_shurikens"] = { --Sharp Shurikens
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_double_shot_ninja"] = { --Double Shot
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
        { text = " Diamonds", colour = lighten(G.C.SUITS["Diamonds"], 0.35) },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_suit('Diamonds', true) and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.Xmult = count >= card.ability.extra.number and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_bloonjitsu"] = { --Bloonjitsu
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
        { text = " Diamonds", colour = lighten(G.C.SUITS["Diamonds"], 0.35) },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_suit('Diamonds', true) and not scoring_card.debuff then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.Xmult = count >= card.ability.extra.number and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_grandmaster_ninja"] = { --Grandmaster Ninja
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
                if scoring_card:is_suit('Diamonds', true) and not scoring_card.debuff then
                    total_Xmult = total_Xmult + card.ability.extra.Xmult
                end
            end
        end
        card.joker_display_values.Xmult = total_Xmult
    end
}

JokerDisplay.Definitions["j_bloons_distraction"] = { --Distraction
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'distract')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_counter_espionage"] = { --Counter Espionage
}

JokerDisplay.Definitions["j_bloons_shinobi_tactics"] = { --Shinobi Tactics
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
        { text = "x" },
        { text = "Ninjas", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.ability.tower_info and joker_card.ability.tower_info.base and joker_card.ability.tower_info.base == 'Ninja Monkey' then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (card.ability.tower_info and card.ability.tower_info.base and card.ability.tower_info.base == 'Ninja Monkey' and mod_joker.ability.extra.Xmult * JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

JokerDisplay.Definitions["j_bloons_bloon_sabotage"] = { --Bloon Sabotage
    reminder_text = {
        { text = "(" },
        { text = "Heart", colour = lighten(G.C.SUITS["Clubs"], 0.35) },
        { text = ")" },
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'sabo')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_grand_saboteur"] = { --Grand Saboteur
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "number", colour = G.C.ORANGE },
        { text = " Hearts", colour = lighten(G.C.SUITS["Clubs"], 0.35) },
        { text = ")" },
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'gsabo')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_seeking_shuriken"] = { --Seeking Shuriken
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            local first_card = JokerDisplay.calculate_leftmost_card(scoring_hand)
            if first_card and not first_card.debuff then
                count = JokerDisplay.calculate_card_triggers(first_card, scoring_hand)
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_caltrops"] = { --Caltrops
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
    },
}

JokerDisplay.Definitions["j_bloons_flash_bomb"] = { --Flash Bomb
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.active = "Next!"
        else
            card.joker_display_values.mult = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_sticky_bomb"] = { --Sticky Bomb
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local stickied = false
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability.sticky_bomb then
                    stickied = true
                end
            end
        end
        card.joker_display_values.Xmult = stickied and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_master_bomber"] = { --Master Bomber
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
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
        card.joker_display_values.Xmult = 1 + card.ability.extra.Xmult * count
    end
}
