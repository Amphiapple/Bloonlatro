SMODS.Joker { --Mortar Monkey
    key = 'mortar_monkey',
    name = 'Mortar Monkey',
	loc_txt = {
        name = 'Mortar Monkey',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 2, mult = 5 } --Variables: num/denom = probability fraction, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'mortar_monkey', card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey') then
            return {
                mult = card.ability.extra.mult,
            }
		end
    end
}

SMODS.Joker { --Bigger Blast
    key = 'bigger_blast',
    name = 'Bigger Blast',
	loc_txt = {
        name = 'Bigger Blast',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 2, mult = 7 } --Variables: num/denom = probability fraction, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'bigger_blast')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'bigger_blast', card.ability.extra.num, card.ability.extra.denom, 'bigger_blast') then
            return {
                mult = card.ability.extra.mult,
            }
		end
    end
}

SMODS.Joker { --Bloon Buster
    key = 'bloon_buster',
    name = 'Bloon Buster',
	loc_txt = {
        name = 'Bloon Buster',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 3, mult = 12 } --Variables: num/denom = probability fraction, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'bloon_buster')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'bloon_buster', card.ability.extra.num, card.ability.extra.denom, 'bloon_buster') then
            return {
                mult = card.ability.extra.mult,
            }
		end
    end
}

SMODS.Joker { --Shell Shock
    key = 'shell_shock',
    name = 'Shell Shock',
    loc_txt = {
        name = 'Shell Shock',
        text = {
            '{C:green}#1# in #2#{} chance to',
            '{C:attention}stun{} each scoring card',
            'and give {C:mult}+#3#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 12 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 2, mult = 10 } --Variables: num/denom = probability fraction 
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'shell_shock')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'shell_shock', card.ability.extra.num, card.ability.extra.denom, 'shell_shock') and not context.other_card.debuff then
            context.other_card:set_ability('m_bloons_stunned', nil, true)
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --The Big One
    key = 'the_big_one',
    name = 'The Big One',
    loc_txt = {
        name = 'The Big One',
        text = {
            '{C:green}#1# in #2#{} chance to',
            '{C:attention}stun{} all scoring cards',
            'and give {C:mult}+#3#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 12 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 2, mult = 40, active = false } --Variables: num/denom = probability fraction 
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'the_big_one')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'the_big_one', card.ability.extra.num, card.ability.extra.denom, 'the_big_one') and not context.blueprint then
            card.ability.extra.active = true
            for k, v in ipairs(context.scoring_hand) do
                if not v.debuff then
                    v:set_ability('m_bloons_stunned', nil, true)
                end
            end
        elseif context.joker_main and card.ability.extra.active then
            card.ability.extra.active = false
            return {
                mult = card.ability.extra.mult 
            }
        end
    end
}

SMODS.Joker { --The Biggest One
    key = 'the_biggest_one',
    name = 'The Biggest One',
    loc_txt = {
        name = 'The Biggest One',
        text = {
            '{C:green}#1# in #2#{} chance to',
            '{C:attention}stun{} all scoring cards',
            'and give {X:mult,C:white}X#3#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 5, y = 12 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 2, Xmult = 3, active = false } --Variables: num/denom = probability fraction 
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'the_biggest_one')
        return { vars = { n, d, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'the_biggest_one', card.ability.extra.num, card.ability.extra.denom, 'the_biggest_one') and not context.blueprint then
            card.ability.extra.active = true
            for k, v in ipairs(context.scoring_hand) do
                if not v.debuff then
                    v:set_ability('m_bloons_stunned', nil, true)
                end
            end
        elseif context.joker_main and card.ability.extra.active then
            card.ability.extra.active = false
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Faster Reload
    key = 'faster_reload',
    name = 'Faster Reload',
	loc_txt = {
        name = 'Faster Reload',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 2, denom = 3, mult = 5 } --Variables: num/denom = probability fraction, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'mortar_monkey', card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey') then
            return {
                mult = card.ability.extra.mult,
            }
		end
    end
}

SMODS.Joker { --Rapid Reload
    key = 'rapid_reload',
    name = 'Rapid Reload',
	loc_txt = {
        name = 'Rapid Reload',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 3, denom = 4, mult = 5 } --Variables: num/denom = probability fraction, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'mortar_monkey', card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey') then
            return {
                mult = card.ability.extra.mult,
            }
		end
    end
}

SMODS.Joker { --Heavy Shells
    key = 'heavy_shells',
    name = 'Heavy Shells',
    loc_txt = {
        name = 'Heavy Shells',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{} Mult',
            'when a {C:attention}Stunned{} card wears off',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 12 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_bloons_stunned',
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { mult = 1, current = 0 } --Variables: mult = +mult for each stunned, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.hook and not context.other_card.debuff and not context.blueprint then
            if context.other_card.ability.name == 'Stunned Card' and context.stun then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "current",
                    scalar_value = "mult",
                    message_colour = G.C.FILTER
                })
                return nil, true
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Artillery Battery
    key = 'artillery_battery',
    name = 'Artillery Battery',
	loc_txt = {
        name = 'Artillery Battery',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'scoring cards to give',
            '{C:chips}+#3#{} Chips, {C:mult}+#4#{} Mult, and',
            '{X:mult,C:white}X#5#{} Mult independently'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 12 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 3, chips = 33, mult = 8, Xmult = 1.3 } --Variables: num/denom = probability fraction, chips = +chips, mult = +mult, Xmult = Xmult

    },
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'artillery_battery')
        return {
            vars = {
                n,
                d,
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.Xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local temp_chips, temp_mult, temp_Xmult = 0, 0, 1
            if SMODS.pseudorandom_probability(card, 'artillery_battery_1', card.ability.extra.num, card.ability.extra.denom, 'artillery_battery') then
                temp_chips = card.ability.extra.chips
            end
            if SMODS.pseudorandom_probability(card, 'artillery_battery_2', card.ability.extra.num, card.ability.extra.denom, 'artillery_battery') then
                temp_mult = card.ability.extra.mult
            end
            if SMODS.pseudorandom_probability(card, 'artillery_battery_3', card.ability.extra.num, card.ability.extra.denom, 'artillery_battery') then
                temp_Xmult = card.ability.extra.Xmult
            end
                return {
                    chips = temp_chips,
                    mult = temp_mult,
                    x_mult = temp_Xmult
                }
		end
    end
}

SMODS.Joker { --Pop and Awe
    key = 'pop_and_awe',
    name = 'Pop and Awe',
    loc_txt = {
        name = 'Pop and Awe',
        text = {
            'This {C:attention}Joker{} gains {X:mult,C:white}X#1#{} Mult',
            'when a {C:attention}Stunned{} card wears off,',
            'resets when {C:attention}Boss Blind{} is defeated',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 12 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_bloons_stunned',
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { Xmult = 0.2, current = 1 } --Variables: Xmult = Xmult for each stunned, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.hook and not context.other_card.debuff and not context.blueprint then
            if context.other_card.ability.name == 'Stunned Card' and context.stun then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "current",
                    scalar_value = "Xmult",
                    message_colour = G.C.FILTER
                })
                return nil, true
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        elseif context.end_of_round and context.beat_boss and card.ability.extra.current > 1 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Increased Accuracy
    key = 'increased_accuracy',
    name = 'Increased Accuracy',
	loc_txt = {
        name = 'Increased Accuracy',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:chips}+#3#{} Chips when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 2, chips = 30 } --Variables: num/denom = probability fraction, chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey')
        return { vars = { n, d, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'mortar_monkey', card.ability.extra.num, card.ability.extra.denom, 'mortar_monkey') then
            return {
                chips = card.ability.extra.chips,
            }
		end
    end
}

SMODS.Joker { --Burny Stuff
    key = 'burny_stuff',
    name = 'Burny Stuff',
    loc_txt = {
        name = 'Burny Stuff',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'destroy {C:attention}first{}',
            'played card'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { num = 1, denom = 4 } --Variables: num/denom = probability fraction 
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'burny_stuff')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card == context.full_hand[1] and SMODS.pseudorandom_probability(card, 'burny_stuff', card.ability.extra.num, card.ability.extra.denom, 'burny_stuff') then
            return {remove = true}
        end
    end
}

SMODS.Joker { --Signal Flare
    key = 'signal_flare',
    name = 'Signal Flare',
    loc_txt = {
        name = 'Signal Flare',
        text = {
            'Unscoring cards are',
            '{C:attention}Stunned{} and discarded'
        }
    },
    atlas = 'Joker',
	pos = { x = 13, y = 12 },
    rarity = 2,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
    end,
    calculate = function(self, card, context)
        if context.before then
            local stunned = {}
            for k, v in pairs(context.full_hand) do
                if not SMODS.in_scoring(v, context.scoring_hand) and not v.debuff then
                    v:set_ability('m_bloons_stunned', nil, true)
                    table.insert(stunned, v)
                end
            end
            stop_use()
            G.CONTROLLER.interrupt.focus = true
            G.CONTROLLER:save_cardarea_focus('hand')
            for k, v in ipairs(stunned) do
                v.ability.forced_selection = nil
            end
            if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
            local count = #stunned
            if count > 0 then
                table.sort(stunned, function(a,b) return a.T.x < b.T.x end)
                inc_career_stat('c_cards_discarded', count)
                for j = 1, #G.jokers.cards do
                    G.jokers.cards[j]:calculate_joker({pre_discard = true, full_hand = stunned, hook = false})
                end
                local cards = {}
                local destroyed_cards = {}
                for i=1, count do
                    stunned[i]:calculate_seal({discard = true})

                    if stunned[i].seal == 'Purple' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                    local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                    card:add_to_deck()
                                    G.consumeables:emplace(card)
                                    G.GAME.consumeable_buffer = 0
                                return true
                            end)}))
                        card_eval_status_text(stunned[i], 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                    end

                    local removed = false
                    for j = 1, #G.jokers.cards do
                        local eval = nil
                        eval = G.jokers.cards[j]:calculate_joker({discard = true, other_card =  stunned[i], full_hand = stunned, stun = true})
                        if eval then
                            if eval.remove then removed = true end
                            card_eval_status_text(G.jokers.cards[j], 'jokers', nil, 1, nil, eval)
                        end
                    end
                    table.insert(cards, stunned[i])
                    if removed then
                        destroyed_cards[#destroyed_cards + 1] = stunned[i]
                        stunned[i]:start_dissolve()
                    else 
                        stunned[i].ability.discarded = true
                        stunned[i]:set_ability(G.P_CENTERS.c_base, nil, true)
                        draw_card(G.play, G.discard, i*100/count, 'down', false, stunned[i])
                    end
                end

                if destroyed_cards[1] then 
                    for j=1, #G.jokers.cards do
                        eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = destroyed_cards})
                    end
                end

                G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
                check_for_unlock({type = 'discard_custom', cards = cards})
            end
        end
    end
}

SMODS.Joker { --Shattering Shells
    key = 'shattering_shells',
    name = 'Shattering Shells',
	loc_txt = {
        name = 'Shattering Shells',
        text = {
            'Remove {C:enhanced}Enhancements{},',
            '{C:dark_edition}Editions{} and {C:attention}Seals{}',
            'from all scoring cards',
            'Gives {X:mult,C:white}X#1#{} Mult for each'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 12 },
    rarity = 2,
	cost = 8,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { Xmult = 0.5 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total = 1
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base or v.edition or v.seal then
                    total = total + card.ability.extra.Xmult
                end
            end
            if total > 1 then
                return {
                    x_mult = total
                }
            end
        elseif context.after and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    for k, v in ipairs(context.scoring_hand) do
                        if v.config.center ~= G.P_CENTERS.c_base then
                            v:set_ability(G.P_CENTERS.c_base)
                        end
                        if v.edition then
                            v:set_edition(nil, true)
                        end
                        if v.seal then
                            v.seal = nil
                        end
                    end
                    return true
                end)
            }))
        end
    end
}

SMODS.Joker { --Blooncineration
    key = 'blooncineration',
    name = 'Blooncineration',
	loc_txt = {
        name = 'Blooncineration',
        text = {
            'Destroy all scoring',
            'cards with {C:enhanced}Enhancements{},',
            '{C:dark_edition}Editions{} or {C:attention}Seals{}',
            'Gives {X:mult,C:white}X#1#{} Mult for each'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 12 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Mortar Monkey", category = "military" },
        extra = { Xmult = 1 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total = 1
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base or v.edition or v.seal then
                    total = total + card.ability.extra.Xmult
                end
            end
            if total > 1 then
                return {
                    x_mult = total
                }
            end
        elseif context.destroying_card and not context.blueprint then
            if context.destroying_card.config.center ~= G.P_CENTERS.c_base or context.destroying_card.edition or context.destroying_card.seal then
                return true
            end
            return nil
        end
    end
}
