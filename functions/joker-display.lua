if SMODS.Mods["JokerDisplay"] and SMODS.Mods["JokerDisplay"].can_load then
    if JokerDisplay then
        local jd_def = JokerDisplay.Definitions

        jd_def["j_bloons_dart"] = { --Dart
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
                { text = " +", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
            }
        }

        jd_def["j_bloons_boomer"] = { --Boomer
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local held_cards = {}

                for i = 1, #G.hand.cards do
                    if not G.hand.cards[i].highlighted then
                        table.insert(held_cards, G.hand.cards[i])
                    end
                end

                local first_card = JokerDisplay.calculate_leftmost_card(held_cards)

                return first_card and playing_card == first_card and
                    joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end
        }

        jd_def["j_bloons_bomb"] = { --Bomb
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
                { text = "Steel", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card.ability.name == 'Steel Card' then
                            count = count +
                                JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
            end,
        }

        jd_def["j_bloons_tack"] = { --Tack
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

        jd_def["j_bloons_ice"] = { --Ice
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_played == 0 and
                    "Active!" or "Inactive"
                card.joker_display_values.chips = G.GAME and G.GAME.current_round.hands_played == 0 and
                    card.ability.extra.chips or 0
            end,
        }

        jd_def["j_bloons_glue"] = { --Glue
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

        jd_def["j_bloons_sniper"] = { --Sniper
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                if card.ability.extra.counter ~= card.ability.extra.limit then
                    card.joker_display_values.mult = card.ability.extra.mult
                else
                    card.joker_display_values.mult = 0
                end

                if card.ability.extra.counter == card.ability.extra.limit - 1 then
                    card.joker_display_values.active = "Active!"
                else
                    card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
                end
            end
        }

        jd_def["j_bloons_sub"] = { --Sub
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
            },
            calc_function = function(card)
                local playing_hand = next(G.play.cards)
                local mult = 0
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                            mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.mult = mult
            end
        }

        jd_def["j_bloons_boat"] = { --Boat
            text = {
                { text = "+$", colour = G.C.MONEY },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
            },
            reminder_text = {
                { text = "(Round)" }
            }
        }

        jd_def["j_bloons_ace"] = { --Ace
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
            },
            reminder_text = {
                { text = "(Ace)"}
            },
            calc_function = function(card)
                local playing_hand = next(G.play.cards)
                local chips = 0
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:get_id() == 14 then
                            chips = chips + card.ability.extra.chips * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.chips = chips
            end
        }

        jd_def["j_bloons_heli"] = { --Heli
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
                { text = "Number Cards", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local number_cards = {}
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:get_id() >= 0 and (scoring_card:get_id() <= 10 or scoring_card:get_id() == 14) then
                            table.insert(number_cards, scoring_card)
                        end
                    end
                end
                local last_number = JokerDisplay.calculate_rightmost_card(number_cards)
                card.joker_display_values.Xmult = last_number and
                    (card.ability.extra.Xmult ^ JokerDisplay.calculate_card_triggers(last_number, scoring_hand)) or 1
            end
        }

        jd_def["j_bloons_mortar"] = { --Mortar
            text = {
                { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
                { text = "x", scale = 0.35 },
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
            },
            extra = {
                {
                    { text = "(", colour = G.C.GREEN, scale = 0.3 },
                    { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
                    { text = ")", colour = G.C.GREEN, scale = 0.3 },
                }
            },
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
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_dartling"] = { --Dartling
            text = {
                { text = "+???", colour = G.C.CHIPS },
            }
        }

        jd_def["j_bloons_wiz"] = { --Wizard
        }

        jd_def["j_bloons_super"] = { --Super
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "Xmult" }
                    }
                }
            }
        }

        jd_def["j_bloons_ninja"] = { --Ninja
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
            }
        }

        jd_def["j_bloons_alch"] = { --Alch
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
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
                card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_left <= 1 and "Active!" or "Inactive"
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'alch')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_druid"] = { --Druid
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
            },
            reminder_text = {
                { text = "(" },
                { text = "Full House", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local mult = 0
                local _, poker_hands, _ = JokerDisplay.evaluate_hand()
                if poker_hands['Full House'] and next(poker_hands['Full House']) then
                    mult = card.ability.extra.mult
                end
                card.joker_display_values.mult = mult
            end
        }

        jd_def["j_bloons_merm"] = { --Merm
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
            },
            reminder_text = {
                { text = "(Bonus card)" }
            },
            calc_function = function(card)
                local mult = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card.ability.name == 'Bonus' then
                            mult = card.ability.extra.mult
                            break
                        end
                    end
                end
                card.joker_display_values.mult = mult
            end
        }

        jd_def["j_bloons_farm"] = { --Farm
            text = {
                { text = "+$", colour = G.C.MONEY },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
            },
            reminder_text = {
                { text = "(Round)" }
            }
        }

        jd_def["j_bloons_spac"] = { --Spac
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
            },
        }

        jd_def["j_bloons_village"] = { --Village
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
                { text = "x" },
                { text = "Common", colour = G.C.BLUE },
                { text = ")" },
            },
            calc_function = function(card)
                local count = 0
                if G.jokers then
                    for _, joker_card in ipairs(G.jokers.cards) do
                        if joker_card.config.center.rarity and joker_card.config.center.rarity == 1 then
                            count = count + 1
                        end
                    end
                end
                card.joker_display_values.count = count
            end,
            mod_function = function(card, mod_joker)
                return { mult = (card.config.center.rarity == 1 and mod_joker.ability.extra.mult * JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
            end
        }

        jd_def["j_bloons_engi"] = { --Engi
            text = {
                { text = "+$", colour = G.C.MONEY },
                { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
            },
            reminder_text = {
                { text = "(" },
                { text = "Straight, Flush", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local money = 0
                local _, poker_hands, _ = JokerDisplay.evaluate_hand()

                if poker_hands['Straight'] and poker_hands['Flush'] then
                    if next(poker_hands['Straight']) and next(poker_hands['Flush']) then
                        money = card.ability.extra.money * 2
                    elseif next(poker_hands['Straight']) or next(poker_hands['Flush']) then
                        money = card.ability.extra.money
                    end
                end

                card.joker_display_values.money = money
            end
        }

        jd_def["j_bloons_beast"] = { --Beast
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
            },
            reminder_text = {
                { text = "(Mult card)" }
            },
            calc_function = function(card)
                local chips = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card.ability.name == 'Mult' then
                            chips = card.ability.extra.chips
                            break
                        end
                    end
                end
                card.joker_display_values.chips = chips
            end
        }

        jd_def["j_bloons_desp"] = { --Desp
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
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
                card.joker_display_values.chips = card.ability.extra.chips * count
            end
        }

        jd_def["j_bloons_eyesight"] = { --Eyesight
        }

        jd_def["j_bloons_redhot"] = { --Red Hot
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" }
            },
            calc_function = function(card)
                local _, _, scoring_hand = JokerDisplay.evaluate_hand()
                card.joker_display_values.active =
                    (#scoring_hand >= card.ability.extra.number) and "Active!" or #scoring_hand .. "/" .. card.ability.extra.number
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                local last_card = scoring_hand and JokerDisplay.calculate_rightmost_card(scoring_hand)
                return last_card and playing_card == last_card and #scoring_hand >= joker_card.ability.extra.number and
                    joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end
        }

        jd_def["j_bloons_frags"] = { --Frags
            extra = {
                {
                    { text = "(", colour = G.C.GREEN, scale = 0.3 },
                    { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
                    { text = ")", colour = G.C.GREEN, scale = 0.3 },
                }
            },
            calc_function = function(card)
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_moretacks"] = { --More Tacks
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
                { text = " +", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
            },
            reminder_text = {
                { text = "(10)" }
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card:get_id() == 10 then
                            count = count +
                                JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.chips = card.ability.extra.chips * count
                card.joker_display_values.mult = card.ability.extra.mult * count
            end,
        }

        jd_def["j_bloons_refreeze"] = { --Refreeze
            reminder_text = {
                { text = "(" },
                { text = "Frozen", colour = G.C.ORANGE },
                { text = ")" }
            },
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                local held_cards = {}

                for i = 1, #G.hand.cards do
                    if not G.hand.cards[i].highlighted then
                        table.insert(held_cards, G.hand.cards[i])
                    end
                end

                for _, card in ipairs(held_cards) do
                    if card == playing_card and card.ability and card.ability.name == 'Frozen Card' then
                        return joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card)
                    end
                end

                return 0
            end
        }

        jd_def["j_bloons_corrosive"] = { --Corrosive
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
            },
            reminder_text = {
                { text = "(" },
                { text = "Glued", colour = G.C.ORANGE },
                { text = ")" }
            }
        }

        jd_def["j_bloons_shraps"] = { --Shraps 
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local mult_value = 0
                local right_card = nil

                if text ~= 'Unknown' and #scoring_hand >= 2 then
                    mult_value = scoring_hand[#scoring_hand - 1].base.nominal
                    right_card = JokerDisplay.calculate_rightmost_card(scoring_hand)
                end

                card.joker_display_values.mult = right_card and JokerDisplay.calculate_card_triggers(right_card, scoring_hand, false) * mult_value or 0
            end
        }

        jd_def["j_bloons_intel"] = { --Intel
        }

        jd_def["j_bloons_grape"] = { --Grape Shot
            text = {
                { text = "+$", colour = G.C.MONEY },
                { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY },
            },
            reminder_text = {
                { text = "(Round)" }
            }
        }

        jd_def["j_bloons_pineapple"] = { --Pineapple
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "counter" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.counter = (card.ability.extra.hands) .. " remaining"
            end,
        }

        jd_def["j_bloons_quad"] = { --Quad
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT },
            },
        }

        jd_def["j_bloons_burny"] = { --Burny
            reminder_text = {
                { text = '(First played card)'}
            },
            extra = {
                {
                    { text = "(", colour = G.C.GREEN, scale = 0.3 },
                    { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
                    { text = ")", colour = G.C.GREEN, scale = 0.3 },
                }
            },
            calc_function = function(card)
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'burny')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_lshock"] = { --Laser Shock
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
            }
        }

        jd_def["j_bloons_wof"] = { --WOF
        }

        jd_def["j_bloons_uv"] = { --Ultravision
        }

        jd_def["j_bloons_espionage"] = { --Espionage
        }

        jd_def["j_bloons_amd"] = { --AMD
            extra = {
                {
                    { text = "(", colour = G.C.GREEN, scale = 0.3 },
                    { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
                    { text = ")", colour = G.C.GREEN, scale = 0.3 },
                }
            },
            calc_function = function(card)
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'amd')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_thunder"] = { --Thunder
            extra = {
                {
                    { text = "(", colour = G.C.GREEN, scale = 0.3 },
                    { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
                    { text = ")", colour = G.C.GREEN, scale = 0.3 },
                }
            },
            calc_function = function(card)
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'thunder')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_network"] = { --Network
            text = {
                { text = "+", colour = G.C.SECONDARY_SET.Planet },
                { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Planet }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "number", colour = G.C.ORANGE},
                { text = " Bonus", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local bonus_cards = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card.ability.name == 'Bonus' then
                            bonus_cards = bonus_cards + 1
                        end
                    end
                end
                card.joker_display_values.tarots = bonus_cards >= 2 and 1 or 0
            end
        }

        jd_def["j_bloons_salvage"] = { --Salvage
        }

        jd_def["j_bloons_smart"] = { --Smart
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
            }
        }

        jd_def["j_bloons_discount"] = { --Discount
        }

        jd_def["j_bloons_sentries"] = { --Sentries
        }

        jd_def["j_bloons_owl"] = { --Owl
            text = {
                { text = "+", colour = G.C.SECONDARY_SET.Tarot },
                { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "number", colour = G.C.ORANGE},
                { text = " Mult", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local mult_cards = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card.ability.name == 'Mult' then
                            mult_cards = mult_cards + 1
                        end
                    end
                end
                card.joker_display_values.tarots = mult_cards >= 2 and 1 or 0
            end
        }

        jd_def["j_bloons_nomad"] = { --Nomad
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
            }
        }

        jd_def["j_bloons_sentry"] = { --Sentry
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
                { text = " +", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "duration" },
                { text = ")" }
            },
            calc_function = function(card)
                card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
            end
        }

        jd_def["j_bloons_tripshot"] = { --Trip shot
            text = {
                { text = "+", colour = G.C.SECONDARY_SET.Tarot },
                { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                if card.ability.extra.counter ~= card.ability.extra.limit then
                    card.joker_display_values.tarots = card.ability.extra.tarots
                else
                    card.joker_display_values.tarots = 0
                end

                if card.ability.extra.counter == 1 then
                    card.joker_display_values.active = "Active!"
                else
                    card.joker_display_values.active = card.ability.extra.counter .. " remaining"
                end
            end
        }

        jd_def["j_bloons_bioboomer"] = { --Bioboomer
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
            },
            reminder_text = {
                { text = "(" },
                { text = "Steel", colour = G.C.ORANGE },
                { text = ")" }
            }
        }

        jd_def["j_bloons_mauler"] = { --Mauler
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

        jd_def["j_bloons_blade"] = { --Blade
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
            },
            reminder_text = {
                { text = "(7, 8, 9)" }
            }
        }

        jd_def["j_bloons_shards"] = { --Shards
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
            },
            reminder_text = {
                { text = "(" },
                { text = "Frozen", colour = G.C.ORANGE },
                { text = ")" }
            },
        }

        jd_def["j_bloons_glose"] = { --Glose
        }

        jd_def["j_bloons_dprec"] = { --Dprec
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
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" }
            },
            calc_function = function(card)
                if card.ability.extra.counter ~= card.ability.extra.limit then
                    card.joker_display_values.Xmult = card.ability.extra.Xmult
                else
                    card.joker_display_values.Xmult = 1
                end

                if card.ability.extra.counter == card.ability.extra.limit - 1 then
                    card.joker_display_values.active = "Active!"
                else
                    card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
                end
            end
        }

        jd_def["j_bloons_tripguns"] = { --Trip guns
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "current" }
                    }
                }
            },
        }

        jd_def["j_bloons_destroyer"] = { --Destroyer
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xmult" }
                    }
                }
            },
            calc_function = function(card)
                card.joker_display_values.Xmult = card.ability.extra.active and card.ability.extra.Xmult or 1
            end
        }

        jd_def["j_bloons_nevamiss"] = { --Nevamiss
            text = {
                { text = "+1", colour = G.C.SECONDARY_SET.Tarot },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "percent_min", colour = G.C.ORANGE },
                { text = "-", colour = G.C.ORANGE },
                { ref_table = "card.ability.extra", ref_value = "percent_max", colour = G.C.ORANGE },
                { text = "%", colour = G.C.ORANGE },
                { text = ")" }
            }
        }

        jd_def["j_bloons_draft"] = { --Draft
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" }
            },
            calc_function = function(card)
                card.joker_display_values.active = card.ability.extra.counter >= 1 and "Active!" or "Inactive"
            end
        }

        jd_def["j_bloons_sshock"] = { --Shell Shock
            text = {
                { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
                { text = "x", scale = 0.35 },
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
            },
            extra = {
                {
                    { text = "(", colour = G.C.GREEN, scale = 0.3 },
                    { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
                    { text = ")", colour = G.C.GREEN, scale = 0.3 },
                }
            },
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
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_buckshot"] = { --Buckshot
            text = {
                {
                    border_nodes = {
                        { text = "X?.?" },
                    }
                }
            },
        }

        jd_def["j_bloons_amast"] = { --Amast
        }

        jd_def["j_bloons_sav"] = { --Sav
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xmult" }
                    }
                }
            },
            calc_function = function(card)
                local text, _, _ = JokerDisplay.evaluate_hand()
                local total_Xmult = 1

                for _, consumable in ipairs(G.consumeables.cards) do
                    local center_key = consumable.config and consumable.config.center_key
                    if center_key and G.P_CENTERS[center_key] and G.P_CENTERS[center_key].set == "Planet" then
                        local hand_type = G.P_CENTERS[center_key].config.hand_type
                        total_Xmult = total_Xmult * (hand_type == text and card.ability.extra.Xmult_match or card.ability.extra.Xmult)
                    end
                end

                card.joker_display_values.Xmult = total_Xmult
            end
        }

        jd_def["j_bloons_flash"] = {
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
                    card.joker_display_values.active = "Active!"
                else
                    card.joker_display_values.mult = 0
                    card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
                end
            end
        }

        jd_def["j_bloons_melody"] = { --Melody
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
            },
            reminder_text = {
                { text = "(" },
                { text = "Bonus", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card.ability.name == 'Bonus' then
                            count = count +
                                JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.chips = card.ability.extra.chips * count
            end,
        }

        jd_def["j_bloons_bank"] = { --Bank
            text = {
                { text = "$", colour = G.C.MONEY },
                { ref_table = "card", ref_value = "sell_cost", colour = G.C.MONEY }
            }
        }

        jd_def["j_bloons_lls"] = { --LLS
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT },
            },
        }

        jd_def["j_bloons_mib"] = { --MIB
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "num" }
                    },
                    border_colour = G.C.GREEN
                }
            },
        }

        jd_def["j_bloons_doublegun"] = { --Doublegun
            text = {
                { text = "+$", colour = G.C.MONEY },
                { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY }
            },
            calc_function = function(card)
                local held_cards = {}

                for i = 1, #G.hand.cards do
                    if not G.hand.cards[i].highlighted then
                        table.insert(held_cards, G.hand.cards[i])
                    end
                end

                local idx_by_id = {}
                local count = 0

                for i = 1, #held_cards do
                    local held_card = held_cards[i]
                    local id = held_card:get_id()
                    local prev_idx = idx_by_id[id]

                    if prev_idx then
                        count = count + JokerDisplay.calculate_card_triggers(held_card, nil, true)
                        idx_by_id[id] = nil
                    else
                        idx_by_id[id] = i
                    end
                end
                card.joker_display_values.money = count * card.ability.extra.money
            end
        }

        jd_def["j_bloons_velo"] = { --Velo
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
            },
            reminder_text = {
                { text = "(" },
                { text = "Mult", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        if scoring_card.ability.name == 'Mult' then
                            count = count +
                                JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end
                end
                card.joker_display_values.mult = card.ability.extra.mult * count
            end,
        }

        jd_def["j_bloons_enforcer"] = { --Enforcer
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "current" }
                    }
                }
            }
        }

        jd_def["j_bloons_jugg"] = { --Jugg
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count +
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
                card.joker_display_values.mult = card.ability.extra.mult * (count * (count + 1)) / 2
            end
        }

        jd_def["j_bloons_press"] = { --Press
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "active_text" },
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local will_apply = false
                local boss_active = G.GAME and G.GAME.blind and G.GAME.blind.get_type and
                    ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))

                if text ~= "Unknown" and #G.hand.highlighted == 1 then
                    will_apply = scoring_hand[1]:is_face()
                end

                card.joker_display_values.active = boss_active and will_apply

                card.joker_display_values.active_text = boss_active and will_apply and "active" or boss_active and "inactive" or "no boss active"
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

        jd_def["j_bloons_blimpact"] = { --Blimpact
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
            },
            reminder_text = {
                { text = "(" },
                { text = "Stunned", colour = G.C.ORANGE },
                { text = ")" }
            },
        }

        jd_def["j_bloons_od"] = { --Overdrive
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

        jd_def["j_bloons_icicles"] = { --Icicles
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
                    }
                }
            },
            calc_function = function(card)
                local playing_hand = next(G.play.cards)
                local count = 0
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_hand or not playing_card.highlighted then
                        if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability and playing_card.ability.name == 'Frozen Card' then
                            count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                        end
                    end
                end
                card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
            end
        }

        jd_def["j_bloons_relentless"] = { --Relentless
        }

        jd_def["j_bloons_supply"] = { --Supply Drop
            text = {
                { text = "+", colour = G.C.SECONDARY_SET.Tarot },
                { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" }
            },
            calc_function = function(card)
                if card.ability.extra.counter == card.ability.extra.limit - 1 then
                    card.joker_display_values.active = "Active!"
                    card.joker_display_values.tarots = 1
                else
                    card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
                    card.joker_display_values.tarots = 0
                end
            end
        }

        jd_def["j_bloons_fs"] = { --First Strike
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "current" }
                    }
                }
            }
        }

        jd_def["j_bloons_flavored"] = { --Flavored
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" }
            },
            calc_function = function(card)
                local my_pos = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then my_pos = i; break end
                end

                local text, _, _ = JokerDisplay.evaluate_hand()
                local one_card = nil
                if text ~= "Unknown" then
                    one_card = #G.hand.highlighted == 1
                end

                local no_hands_played = G.GAME.current_round.hands_played == 0
                local joker_to_destroy = my_pos and G.jokers.cards[my_pos+1] and not G.jokers.cards[my_pos+1].ability.eternal

                card.joker_display_values.active = one_card and no_hands_played and joker_to_destroy and "Active!" or "Inactive"
            end
        }

        jd_def["j_bloons_gz"] = { --GZ
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
            },
            calc_function = function(card)
                card.joker_display_values.chips = G.GAME.current_round.hands_played == 0 and card.ability.extra.chips or 0
            end
        }

        jd_def["j_bloons_comdef"] = { --Comdef
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS },
            },
        }

        jd_def["j_bloons_abatt"] = { --Abatt
            text = {
                { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
                { text = "x", scale = 0.35 },
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "Xmult"}
                    }
                }
            },
            extra = {
                {
                    { text = "(", colour = G.C.GREEN, scale = 0.3 },
                    { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
                    { text = ")", colour = G.C.GREEN, scale = 0.3 },
                }
            },
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
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'abatt')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_rorm"] = { --Rorm
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

        jd_def["j_bloons_necro"] = { --Necro
        }

        jd_def["j_bloons_tech"] = { --Tech TODO (not ready)
        }

        jd_def["j_bloons_sabo"] = { --Sabo
            reminder_text = {
                { text = "(" },
                { text = "Heart", colour = lighten(G.C.SUITS["Hearts"], 0.35) },
                { text = "+" },
                { text = "Other", colour = G.C.ORANGE },
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
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'sabo')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_r2g"] = { --R2g
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                local text, _, _ = JokerDisplay.evaluate_hand()

                local only_card = text ~= "Unknown" and #G.hand.highlighted == 1

                card.joker_display_values.active = G.GAME and G.GAME.current_round.discards_left == 1 and only_card and "Active!" or "Inactive"
            end
        }

        jd_def["j_bloons_jbounty"] = { --Jbounty
            text = {
                { text = "+$", colour = G.C.MONEY },
                { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
            },
            reminder_text = {
                { text = "(" },
                { text = "Full House", colour = G.C.ORANGE },
                { text = ")" }
            },
            calc_function = function(card)
                local text, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
                local high = 0
                local low = 0

                if text ~= "Unknown" and poker_hands['Full House'] then
                    if next(poker_hands['Full House']) then
                        low, high = scoring_hand[1].base.nominal, scoring_hand[1].base.nominal
                        for _, scoring_card in ipairs(scoring_hand) do
                            if scoring_card.base.nominal < low then
                                low = scoring_card.base.nominal
                                break
                            elseif scoring_card.base.nominal > high then
                                high = scoring_card.base.nominal
                                break
                            end
                        end
                    end
                end

                card.joker_display_values.money = math.max(0, high - low)
            end
        }

        jd_def["j_bloons_arknight"] = { --Arknight
            reminder_text = {
                { text = "(" },
                { text = "Bonus", colour = G.C.ORANGE },
                { text = ")" }
            },
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

        jd_def["j_bloons_brf"] = { --BRF
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "current" }
                    }
                }
            }
        }

        jd_def["j_bloons_sporm"] = { --Sporm
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "current" }
                    }
                }
            }
        }

        jd_def["j_bloons_city"] = { --City
            text = {
                { text = "+$", colour = G.C.MONEY },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MONEY },
            },
            reminder_text = {
                { text = "(Round)" }
            }
        }

        jd_def["j_bloons_sexpert"] = { --Sexpert
        }

        jd_def["j_bloons_condor"] = { --Condor
            reminder_text = {
                { text = "(" },
                { text = "Mult", colour = G.C.ORANGE },
                { text = ")" }
            },
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

        jd_def["j_bloons_twix"] = { --Twix
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
                        if scoring_card:get_id() == 6 then
                            count = count + 1
                        end
                    end
                end

                card.joker_display_values.Xmult = count == card.ability.extra.number and card.ability.extra.Xmult or 1
            end
        }

        jd_def["j_bloons_crushing_sentry"] = { --Crushing Sentry
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT, retrigger_type = "mult"}
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "duration" },
                { text = ")" }
            },
            calc_function = function(card)
                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count +
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
                card.joker_display_values.mult = card.ability.extra.mult * count
                card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
            end
        }

        jd_def["j_bloons_boom_sentry"] = { --Boom Sentry
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
                { ref_table = "card.joker_display_values", ref_value = "duration" },
                { text = ")" }
            },
            calc_function = function(card)
                local held_cards = {}

                for i = 1, #G.hand.cards do
                    if not G.hand.cards[i].highlighted then
                        table.insert(held_cards, G.hand.cards[i])
                    end
                end

                local first_card = JokerDisplay.calculate_leftmost_card(held_cards)
                local count = first_card and JokerDisplay.calculate_card_triggers(first_card, nil, true) or 0

                card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
                card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
            end
        }

        jd_def["j_bloons_cold_sentry"] = {--Cold Sentry
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "duration" },
                { text = ")" }
            },
            calc_function = function(card)
                card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                if held_in_hand then return 0 end
                local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
                return first_card and playing_card == first_card and
                    joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end
        }

        jd_def["j_bloons_energy_sentry"] = {--Energy Sentry
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
                { text = " +", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "duration" },
                { text = ")" }
            },
            calc_function = function(card)
                card.joker_display_values.duration = card.ability.extra.rounds .. " round" .. (card.ability.extra.rounds ~= 1 and "s" or "") .. " left"
            end
        }

        jd_def["j_bloons_bloonprint"] = {--Bloonprint
            text = {
                { text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
                { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED, scale = 0.3 },
                { text = ")", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
            },
            reminder_text = {
                { text = "(Position " },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
                card.joker_display_values.blueprint_compat = localize('k_incompatible')
                JokerDisplay.copy_display(card, copied_joker, copied_debuff)
            end,
            get_blueprint_joker = function(card)
                return G.jokers.cards[card.ability.extra.current] or nil
            end
        }

        jd_def["j_bloons_xbm"] = {--Xbm
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
                { ref_table = "card.joker_display_values", ref_value = "counter" },
                { text = ")" }
            },
            calc_function = function(card)
                local limit = card.ability.extra.limit
                local counter = card.ability.extra.counter

                if G.STATE and G.STATE == G.STATES.HAND_PLAYED then
                    card.joker_display_values.Xmult = card.joker_display_values and card.joker_display_values.Xmult or 1
                    card.joker_display_values.counter = counter <= limit - 1 and limit - counter % limit .. " remaining" or "Next!"
                    return
                end

                local count = 0
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()

                if text ~= "Unknown" and type(scoring_hand) == "table" then
                    for _, scoring_card in pairs(scoring_hand) do
                        count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end

                local activations = (count + counter - 1 >= limit) and 1 + math.floor((count + counter - 1 - limit) / limit) or 0

                card.joker_display_values.Xmult = (activations > 0 and (card.ability.extra.Xmult ^ activations) or 1)

                card.joker_display_values.counter =
                    counter <= limit - 1 and limit - counter % limit .. " remaining" or "Next!"
            end
        }

        jd_def["j_bloons_glord"] = { --Glaive Lord
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.CHIPS }
            }
        }

        jd_def["j_bloons_blitz"] = { --Blitz
        }

        jd_def["j_bloons_iring"] = { --Iring
        }

        jd_def["j_bloons_az"] = { --Absolute Zero
            text = {
                { text = "+", colour = G.C.SECONDARY_SET.Spectral },
                { ref_table = "card.joker_display_values", ref_value = "spectrals", colour = G.C.SECONDARY_SET.Spectral }
            },
            calc_function = function(card)
                local cards_needed = false
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()

                if text ~= 'Unknown' then
                    cards_needed = #scoring_hand == card.ability.extra.number
                end

                local first_hand = G.GAME and G.GAME.current_round.hands_played == 0

                card.joker_display_values.spectrals = first_hand and cards_needed and 1 or 0
            end
        }

        jd_def["j_bloons_edef"] = { --Edef
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xmult" }
                    }
                }
            },
            calc_function = function(card)
                if G.STATE and G.STATE ~= G.STATES.SELECTING_HAND then
                    local state = G.STATE == G.STATES.HAND_PLAYED or G.STATE == G.STATES.DRAW_TO_HAND
                    card.joker_display_values.Xmult = state and card.joker_display_values and card.joker_display_values.Xmult or 1
                    return
                end

                local Xmult = 1
                if G.GAME.current_round.hands_left <= 1 then
                    if G.GAME.chips/G.GAME.blind.chips <= to_big(0.25) then
                        Xmult = card.ability.extra.Xmult3
                    else
                        Xmult = card.ability.extra.Xmult2
                    end
                elseif G.GAME.current_round.hands_played ~= 0 then
                    Xmult = card.ability.extra.Xmult1
                end

                card.joker_display_values.Xmult = Xmult
            end
        }

        jd_def["j_bloons_gizer"] = { --Gizer
        }

        jd_def["j_bloons_plord"] = { --Plord TODO (not ready)
        }

        jd_def["j_bloons_shredder"] = { --Shredder
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
                { ref_table = "card.ability.extra", ref_value = "counter" },
                { text = "/" },
                { ref_table = "card.ability.extra", ref_value = "limit" },
                { text = " Aces)" },
            },
        }

        jd_def["j_bloons_aprime"] = { --Aprime
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(2,3,5,7)" }
            },
            calc_function = function(card)
                local total_Xmult = 1
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    for _, scoring_card in pairs(scoring_hand) do
                        local triggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand) or 0
                        if triggers > 0 then
                            local id = scoring_card:get_id()
                            if id == 2 then
                                total_Xmult = total_Xmult * (card.ability.extra.Xmult1 ^ triggers)
                            elseif id == 3 then
                                total_Xmult = total_Xmult * (card.ability.extra.Xmult2 ^ triggers)
                            elseif id == 5 then
                                total_Xmult = total_Xmult * (card.ability.extra.Xmult3 ^ triggers)
                            elseif id == 7 then
                                total_Xmult = total_Xmult * (card.ability.extra.Xmult4 ^ triggers)
                            end
                        end
                    end
                end
                card.joker_display_values.Xmult = total_Xmult
            end
        }

        jd_def["j_bloons_cin"] = { --Cin
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

        jd_def["j_bloons_rod"] = { --Rod
            text = {
                { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
                { text = "x",                              scale = 0.35 },
                {
                    border_nodes = {
                        { text = "X?.?" }
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

                card.joker_display_values.count = count
            end
        }

        jd_def["j_bloons_wlp"] = { --WLP
        }

        jd_def["j_bloons_lotn"] = { --LOTN
        }

        jd_def["j_bloons_gmn"] = { --GMN
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
                        if scoring_card:is_suit('Diamonds', true) then
                            total_Xmult = total_Xmult + card.ability.extra.Xmult
                        end
                    end
                end
                card.joker_display_values.Xmult = total_Xmult
            end
        }

        jd_def["j_bloons_tt5"] = { --TT5
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                card.joker_display_values.active = card.ability.extra.current >= card.ability.extra.rounds and
                    "Active!" or
                    (card.ability.extra.current .. "/" .. card.ability.extra.rounds)
            end
        }

        jd_def["j_bloons_aow"] = { --AoW
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "current" }
                    }
                }
            }
        }

        jd_def["j_bloons_lota"] = { --Lota
            text = {
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.ability.extra", ref_value = "number" },
                { text = "/" },
                { ref_table = "card.ability.extra", ref_value = "limit" },
                { text = ")" },
            },
            calc_function = function(card)
                if not G.playing_cards then return end

                local count = 0
                for _, deck_card in pairs(G.playing_cards) do
                    if deck_card.ability.name == 'Bonus' then
                        count = count + 1
                    end
                end

                card.joker_display_values.mult = count >= card.ability.extra.limit and card.ability.extra.mult or 0
            end
        }

        jd_def["j_bloons_wallstreet"] = { --Wall Street
        }

        jd_def["j_bloons_pspike"] = {
            text = {
                { text = "+", colour = G.C.BLUE },
                { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.BLUE }
            }
        }

        jd_def["j_bloons_pex"] = { --Pex
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "Xmult"}
                    }
                }
            },
            extra = {
                {
                    { text = "(", colour = G.C.GREEN, scale = 0.3 },
                    { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
                    { text = ")", colour = G.C.GREEN, scale = 0.3 },
                }
            },
            calc_function = function(card)
                local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'pex')
                card.joker_display_values.odds = numerator .. " in " .. denominator
            end
        }

        jd_def["j_bloons_uboost"] = { --Uboost
        }

        jd_def["j_bloons_meg"] = { --Meg
            text = {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "current_chips", colour = G.C.CHIPS },
                { text = " +", colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "current_mult", colour = G.C.MULT },
            },
            reminder_text = {
                { text = "(" },
                { text = "Bonus", colour = G.C.ORANGE },
                { text = ", " },
                { text = "Mult", colour = G.C.ORANGE },
                { text = ")" }
            }
        }

        jd_def["j_bloons_gustice"] = { --Gustice
        }

        jd_def["j_bloons_mdom"] = { --Moab Domination
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "current" }
                    }
                }
            }
        }

        jd_def["j_bloons_fortress"] = { --Fortress
            text = {
                { text = "+$", colour = G.C.MONEY },
                { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY, retrigger_type = "mult" },
                { text = " +", colour = G.C.SECONDARY_SET.Tarot },
                { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot },
                { text = " +", colour = G.C.SECONDARY_SET.Planet },
                { ref_table = "card.joker_display_values", ref_value = "planets", colour = G.C.SECONDARY_SET.Planet },
            },
            reminder_text = {
                { text = "(Ace)" }
            },
            calc_function = function(card)
                local held_count, played_count = 0, 0
                local highlighted_aces = {}
                local _, _, scoring_hand = JokerDisplay.evaluate_hand()

                for _, hand_card in pairs(G.hand.cards) do
                    if hand_card:get_id() == 14 then
                        if hand_card.highlighted then
                            table.insert(highlighted_aces, hand_card)
                            played_count = played_count + JokerDisplay.calculate_card_triggers(hand_card, scoring_hand, false)
                        else
                            held_count = held_count + JokerDisplay.calculate_card_triggers(hand_card, nil, true)
                        end
                    end
                end

                card.joker_display_values.money = G.STATE ~= G.STATES.HAND_PLAYED and played_count * card.ability.extra.money
                                                  or card.joker_display_values and card.joker_display_values.money
                                                  or 0
                card.joker_display_values.tarots = #highlighted_aces
                card.joker_display_values.planets = held_count
            end,
            retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
                return (playing_card:get_id() == 14) and
                    joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end
        }

        jd_def["j_bloons_pbrew"] = { --Pbrew
        }

        jd_def["j_bloons_smines"] = { --Smines
            text = {
                { text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
                { ref_table = "card.ability.extra", ref_value = "mines", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
                { text = " mines)", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "active" },
                { text = ")" },
            },
            calc_function = function(card)
                local counter = card.ability.extra.counter
                local limit = card.ability.extra.limit

                card.joker_display_values.active =
                    (counter % limit == limit - 1 and "Next!") or ((limit - (counter % limit) - 1) .. " remaining")
            end
        }

        jd_def["j_bloons_vtsg"] = { --VTSG
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "sacrifices" },
                { text = ")" },
            },

            calc_function = function(card)
                local sacs = card.ability.extra.sacrifices
                card.joker_display_values.sacrifices =
                    (sacs["+chips"] or 0) .. " " ..
                    (sacs["+mult"] or 0) .. " " ..
                    (sacs["Xmult"] or 0) .. " " ..
                    (sacs["econ"] or 0) .. " " ..
                    (sacs["value"] or 0) .. " " ..
                    (sacs["support"] or 0)
            end
        }
    end
end
