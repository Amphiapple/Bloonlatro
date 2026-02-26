JokerDisplay.Definitions["j_bloons_dartling_gunner"] = { --Dartling Gunner
    text = {
        { text = "+", colour = G.C.CHIPS },
        {
            dynatext = {
                string = (
                    function()
                        local card = SMODS.Centers["j_bloons_dartling"]
                        local r_chips = {}
                        for i = card.config.extra.min, card.config.extra.max do
                            r_chips[#r_chips + 1] = tostring(i)
                        end
                        return r_chips
                    end
                )(),
                colours = { G.C.CHIPS },
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.5,
                scale = 0.4,
                min_cycle_time = 0
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_focused_firing"] = { --Focused Firing
    text = {
        { text = "+", colour = G.C.CHIPS },
        {
            dynatext = {
                string = (
                    function()
                        local card = SMODS.Centers["j_bloons_focus"]
                        local r_chips = {}
                        for i = card.config.extra.min, card.config.extra.max do
                            r_chips[#r_chips + 1] = tostring(i)
                            if i >= card.config.extra.q1 and i <= card.config.extra.q3 then
                                r_chips[#r_chips + 1] = tostring(i)
                            end
                        end
                        return r_chips
                    end
                )(),
                colours = { G.C.CHIPS },
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.5,
                scale = 0.4,
                min_cycle_time = 0
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_laser_shock"] = { --Laser Shock
    text = {
        { text = "+",                       colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
    }
}

JokerDisplay.Definitions["j_bloons_laser_cannon"] = { --Laser Cannon
    text = {
        { text = "+",                       colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
    }
}

JokerDisplay.Definitions["j_bloons_plasma_accelerator"] = { --Plasma Accelerator
    text = {
        { text = "+",                              colour = G.C.MULT },
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

JokerDisplay.Definitions["j_bloons_ray_of_doom"] = { --Ray of Doom
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

JokerDisplay.Definitions["j_bloons_advanced_targeting"] = { --Advanced Targeting
    text = {
        { text = "+", colour = G.C.CHIPS },
        {
            dynatext = {
                string = (
                    function()
                        local card = SMODS.Centers["j_bloons_advanced"]
                        local r_chips = {}
                        for i = card.config.extra.min, card.config.extra.max do
                            r_chips[#r_chips + 1] = tostring(i)
                        end
                        return r_chips
                    end
                )(),
                colours = { G.C.CHIPS },
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.5,
                scale = 0.4,
                min_cycle_time = 0
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_faster_barrel_spin"] = { --Faster Barrel Spin
    text = {
        { text = "+", colour = G.C.CHIPS },
        {
            dynatext = {
                string = (
                    function()
                        local card = SMODS.Centers["j_bloons_fastspin"]
                        local r_chips = {}
                        for i = card.config.extra.min, card.config.extra.max do
                            r_chips[#r_chips + 1] = tostring(i)
                        end
                        return r_chips
                    end
                )(),
                colours = { G.C.CHIPS },
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.5,
                scale = 0.4,
                min_cycle_time = 0
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_hydra_rocket_pods"] = { --Hydra Rocket Pods
    text = {
        { text = "+",                       colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(" },
        { text = "Pair", colour = G.C.ORANGE },
        { text = ")" }
    }
}

JokerDisplay.Definitions["j_bloons_rocket_storm"] = { --Rocket Storm
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

JokerDisplay.Definitions["j_bloons_faster_swivel"] = { --Faster Swivel
    text = {
        { text = "+", colour = G.C.CHIPS },
        {
            dynatext = {
                string = (
                    function()
                        local card = SMODS.Centers["j_bloons_swivel"]
                        local r_chips = {}
                        for i = card.config.extra.min, card.config.extra.max do
                            r_chips[#r_chips + 1] = tostring(i)
                            if i <= card.config.extra.q1 or i >= card.config.extra.q3 then
                                r_chips[#r_chips + 1] = tostring(i)
                            end
                        end
                        return r_chips
                    end
                )(),
                colours = { G.C.CHIPS },
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.5,
                scale = 0.4,
                min_cycle_time = 0
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_powerful_darts"] = { --Powerful Darts
    text = {
        { text = "+", colour = G.C.CHIPS },
        {
            dynatext = {
                string = (
                    function()
                        local card = SMODS.Centers["j_bloons_powerful"]
                        local r_chips = {}
                        for i = card.config.extra.min, card.config.extra.max do
                            r_chips[#r_chips + 1] = tostring(i)
                        end
                        return r_chips
                    end
                )(),
                colours = { G.C.CHIPS },
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.5,
                scale = 0.4,
                min_cycle_time = 0
            }
        }
    },
    extra = {
        {
            { text = "(",                              colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")",                              colour = G.C.GREEN, scale = 0.3 },
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
                { text = "X" },
                {
                    dynatext = {
                        string = (
                            function()
                                local card = SMODS.Centers["j_bloons_buckshot"]
                                local r_xmult = {}
                                for i = card.config.extra.min, card.config.extra.max do
                                    r_xmult[#r_xmult + 1] = tostring(i/10)
                                end
                                return r_xmult
                            end
                        )(),
                        colours = { G.C.WHITE },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.5,
                        scale = 0.4,
                        min_cycle_time = 0
                    }
                }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_bloon_area_denial_system"] = { --Bloon Area Denial System
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x",                              scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                {
                    dynatext = {
                        string = (
                            function()
                                local card = SMODS.Centers["j_bloons_bads"]
                                local r_xmult = {}
                                for i = card.config.extra.min, card.config.extra.max do
                                    r_xmult[#r_xmult + 1] = tostring(i/100)
                                end
                                return r_xmult
                            end
                        )(),
                        colours = { G.C.WHITE },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.5,
                        scale = 0.4,
                        min_cycle_time = 0
                    }
                }
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

JokerDisplay.Definitions["j_bloons_bloon_exclusion_zone"] = { --Bloon Exclusion Zone
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x",                              scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                {
                    dynatext = {
                        string = (
                            function()
                                local card = SMODS.Centers["j_bloons_bez"]
                                local r_xmult = {}
                                for i = card.config.extra.min, card.config.extra.max do
                                    r_xmult[#r_xmult + 1] = tostring(i/100)
                                end
                                return r_xmult
                            end
                        )(),
                        colours = { G.C.WHITE },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.5,
                        scale = 0.4,
                        min_cycle_time = 0
                    }
                }
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
