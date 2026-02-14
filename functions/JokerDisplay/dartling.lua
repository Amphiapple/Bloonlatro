JokerDisplay.Definitions["j_bloons_dartling"] = { --Dartling Gunner
    text = {
        { text = "+??", colour = G.C.CHIPS },
    }
}

JokerDisplay.Definitions["j_bloons_focus"] = { --Focused Firing
    text = {
        { text = "+??", colour = G.C.CHIPS },
    }
}

JokerDisplay.Definitions["j_bloons_lshock"] = { --Laser Shock
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
    }
}

JokerDisplay.Definitions["j_bloons_lcan"] = { --Laser Cannon
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
    }
}

JokerDisplay.Definitions["j_bloons_paccel"] = { --Plasma Accelerator
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    calc_function = function(card)
        local count = 0
        local ids = {}
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= "Unknown" then
            for _, scoring_card in pairs(scoring_hand) do
                local id = scoring_card:get_id()
                local triggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand) or 0

                if ids[id] then
                    count = count + triggers
                elseif triggers >= 2 then
                    ids[id] = true
                    count = count + (triggers - 1)
                else
                    ids[id] = true
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_rod"] = { --Ray of Doom
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local count = 0
        local ids = {}
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()

        if text ~= "Unknown" then
            for _, scoring_card in pairs(scoring_hand) do
                local id = scoring_card:get_id()
                local triggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand) or 0

                if ids[id] then
                    count = count + triggers
                elseif triggers >= 2 then
                    ids[id] = true
                    count = count + (triggers - 1)
                else
                    ids[id] = true
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end
}

JokerDisplay.Definitions["j_bloons_advanced"] = { --Advanced Targeting
    text = {
        { text = "+??", colour = G.C.CHIPS },
    }
}

JokerDisplay.Definitions["j_bloons_fastspin"] = { --Faster Barrel Spin
    text = {
        { text = "+??", colour = G.C.CHIPS },
    }
}

JokerDisplay.Definitions["j_bloons_hrp"] = { --Hydra Rocket Pods
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(" },
        { text = "Pair", colour = G.C.ORANGE },
        { text = ")" }
    }
}

JokerDisplay.Definitions["j_bloons_rorm"] = { --Rocket Storm
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { text = "Pair", colour = G.C.ORANGE },
        { text = ")" }
    }
}

JokerDisplay.Definitions["j_bloons_mad"] = { --MAD
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_swivel"] = { --Faster Swivel
    text = {
        { text = "+??", colour = G.C.CHIPS },
    }
}

JokerDisplay.Definitions["j_bloons_powerful"] = { --Powerful Darts
    text = {
        { text = "+??", colour = G.C.CHIPS },
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'powerful')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_buckshot"] = { --Buckshot
    text = {
        {
            border_nodes = {
                { text = "X?.?" },
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_bads"] = { --Bloon Area Denial System
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        {
            border_nodes = {
                { text = "X?.?" },
            }
        }
    },
    calc_function = function(card)
        local count = 0
        local low = 0
        local high = 0
        local trigger_cards = {}
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
            for k, v in ipairs(sorted_cards) do
                if not SMODS.has_no_rank(v) then
                    local id = v:get_id()
                    if k == 1 then
                        trigger_cards['first'] = v
                        low = id
                        high = id
                    end
                    if k == #sorted_cards then
                        trigger_cards['last'] = v
                    end
                    if id < low then
                        low = id
                        trigger_cards['low'] = v
                    end
                    if id > high then
                        high = id
                        trigger_cards['high'] = v
                    end
                end
            end
            for k, v in ipairs(scoring_hand) do
                for i, j in pairs(trigger_cards) do
                    if v == j then
                        count = count + 1
                        break
                    end
                end
            end
        end
        card.joker_display_values.count = count
    end
}

JokerDisplay.Definitions["j_bloons_bez"] = { --Bloon Exclusion Zone
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        {
            border_nodes = {
                { text = "X?.?" },
            }
        }
    },
    calc_function = function(card)
        local count = 0
        local high = 0
        local trigger_cards = {}
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local held_cards = {}
        for i = 1, #G.hand.cards do
            local hand_card = G.hand.cards[i]
            if not hand_card.highlighted and hand_card.facing ~= 'back' then
                table.insert(held_cards, hand_card)
            end
        end
        if text ~= 'Unknown' then
            local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
            for k, v in ipairs(sorted_cards) do
                if not SMODS.has_no_rank(v) and not v.debuff then
                    local id = v:get_id()
                    if k == 1 then
                        trigger_cards['first'] = v
                        high = id
                    end
                    if k == #sorted_cards then
                        trigger_cards['last'] = v
                    end
                    if id > high then
                        high = id
                        trigger_cards['high'] = v
                    end
                end
            end
        end
        local sorted_h_cards = JokerDisplay.sort_cards(held_cards)
        for k, v in ipairs(sorted_h_cards) do
            if not SMODS.has_no_rank(v) and not v.debuff then
                local id = v:get_id()
                if k == 1 then
                    trigger_cards['h_first'] = v
                    high = id
                end
                if k == #sorted_h_cards then
                    trigger_cards['h_last'] = v
                end
                if id > high then
                    high = id
                    trigger_cards['h_high'] = v
                end
            end
        end
        for k, v in ipairs(G.hand.cards) do
            for i, j in pairs(trigger_cards) do
                if v == j then
                    count = count + 1
                    break
                end
            end
        end
        card.joker_display_values.count = count
    end
}
