SMODS.Joker { --Skywarden
    key = 'skywarden',
    name = 'Skywarden',
    atlas = 'Joker',
	pos = { x = 0, y = 20 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { starting_mult = 4, mult_gain = 2, current = 4 } --Variables: starting_mult = +mult at the start of round, mult_gain = +mult after each hand, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mult_gain } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "mult_gain",
            })
            return nil, true
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.starting_mult
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Aerial Attunement
    key = 'aerial_attunement',
    name = 'Aerial Attunement',
    atlas = 'Joker',
	pos = { x = 1, y = 20 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { starting_mult = 8, mult_gain = 2, current = 8 } --Variables: starting_mult = +mult at the start of round, mult_gain = +mult after each hand, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mult_gain } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "mult_gain",
            })
            return nil, true
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.starting_mult
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Zephyr Sense
    key = 'zephyr_sense',
    name = 'Zephyr Sense',
    atlas = 'Joker',
	pos = { x = 1, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { starting_mult = 8, mult_gain = 2, current = 8 } --Variables: starting_mult = +mult at the start of ante, mult_gain = +mult after each hand, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mult_gain } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "mult_gain",
            })
            return nil, true
        elseif context.end_of_round and context.beat_boss and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.starting_mult
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Wind Weaver
    key = 'wind_weaver',
    name = 'Wind Weaver',
    atlas = 'Joker',
	pos = { x = 3, y = 20 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { mult = 1, retrigger = 1, retrigger_limit = 5, current = 0 } --Variables: mult = +mult after each card, retrigger_limit = mult to retrigger card, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.retrigger_limit, card.ability.extra.current } }
    end,
    calculate = function (self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if not context.blueprint then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "current",
                        scalar_value = "mult",
                        no_message = true
                    })
                end
                return {
                    mult = card.ability.extra.current
                }
            end
        elseif context.repetition and context.cardarea == G.play and card.ability.extra.current >= card.ability.extra.retrigger_limit then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
        end
    end
}

SMODS.Joker { --Galesage
    key = 'galesage',
    name = 'Galesage',
    atlas = 'Joker',
	pos = { x = 4, y = 20 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { number = 5, retrigger = 1 } --Variables: number = required scoring cards, retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function (self, card, context)
        if context.repetition and context.cardarea == G.play and #context.scoring_hand == card.ability.extra.number then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --Farwind Seer
    key = 'farwind_seer',
    name = 'Farwind Seer',
    atlas = 'Joker',
	pos = { x = 5, y = 20 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { retrigger = 0 } --Variables: number = required scoring cards, retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.retrigger = (G.jokers.config.card_limit - #G.jokers.cards)
        end
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and card.ability.extra.retrigger > 0 then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --Storm's Pulse
    key = 'storms_pulse',
    name = "Storm's Pulse",
    atlas = 'Joker',
	pos = { x = 6, y = 20 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { starting_mult = 4, mult_gain = 4, current = 4 } --Variables: starting_mult = +mult at the start of round, mult_gain = +mult after each hand, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mult_gain } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "mult_gain",
            })
            return nil, true
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.starting_mult
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Thundering Arc
    key = 'thundering_arc',
    name = 'Thundering Arc',
    atlas = 'Joker',
	pos = { x = 7, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { starting_mult = 4, mult_gain = 2, current = 4 } --Variables: starting_mult = +mult at the start of round, mult_gain = +mult after each card, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mult_gain } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "mult_gain",
                operation = function(ref_table, ref_value, initial, scaling)
                    ref_table[ref_value] = initial + scaling*#context.scoring_hand
                end
            })
            return nil, true
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.starting_mult
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Galvanic Conduit
    key = 'galvanic_conduit',
    name = 'Galvanic Conduit',
    atlas = 'Joker',
	pos = { x = 8, y = 20 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { mult = 1, stun_limit = 5, current = 0 } --Variables: mult = +mult after each card, stun_limit = mult to stun card, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.stun_limit, card.ability.extra.current } }
    end,
    calculate = function (self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if not context.blueprint then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "current",
                        scalar_value = "mult",
                        no_message = true
                    })
                end
                if card.ability.extra.current >= card.ability.extra.stun_limit then
                    context.other_card:set_ability(G.P_CENTERS.m_bloons_stunned, nil, true)
                end
                return {
                    mult = card.ability.extra.current
                }
            end
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
        end
    end
}

SMODS.Joker { --Thunder's Decree
    key = 'thunders_decree',
    name = "Thunder's Decree",
    atlas = 'Joker',
	pos = { x = 9, y = 20 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { Xmult = 1.5 } --Variables: Xmult = Xmult for stunned cards
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[#context.scoring_hand] and context.other_card.ability.name ~= 'Stunned Card' then
                context.other_card:set_ability(G.P_CENTERS.m_bloons_stunned, nil, true)
            end
            if context.other_card.ability.name == 'Stunned Card' then
                return {
                    mult = card.ability.extra.Xmult
                }
            end
        end
    end
}

SMODS.Joker { --Stormwrath Archon
    key = 'stormwrath_archon',
    name = 'Stormwrath Archon',
    atlas = 'Joker',
	pos = { x = 10, y = 20 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_stunned',
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { Xmult = 2, mult = 10 } --Variables: Xmult = Xmult for stunned cards, mult = +mult for adjacent cards
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.mult } }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play then
            local temp_mult = 0
            for k, v in ipairs(context.scoring_hand) do
                if context.other_card == context.scoring_hand[k] and
                ((k > 1 and context.scoring_hand[k-1].ability.name == 'Stunned Card') or
                (k < #context.scoring_hand and context.scoring_hand[k+1].ability.name == 'Stunned Card')) then
                    temp_mult = card.ability.extra.mult
                end
            end
            local temp_Xmult = context.other_card.ability.name == 'Stunned Card' and card.ability.extra.Xmult or 1
            return {
                mult = temp_mult,
                Xmult = temp_Xmult
            }
        end
    end
}

SMODS.Joker { --Shatterpoint
    key = 'shatterpoint',
    name = 'Shatterpoint',
    atlas = 'Joker',
	pos = { x = 11, y = 20 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { mult = 6, rank_limit = 6 } --Variables: mult = +mult, rank_limit = rank to destroy frozen
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.mult, card.ability.extra.rank_limit } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        elseif context.destroy_card and not context.blueprint then
            if context.destroy_card.ability.name == 'Frozen Card' and context.destroy_card:get_id() < card.ability.extra.rank_limit then
                return {remove = true}
            end
        end
    end
}

SMODS.Joker { --Icebore
    key = 'icebore',
    name = 'Icebore',
    atlas = 'Joker',
	pos = { x = 12, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { mult = 6, frozen_mult = 6 } --Variables: mult = +mult, frozen_mult = mult for frozen cards
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.mult, card.ability.extra.frozen_mult } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        elseif context.individual and context.cardarea == G.hand and context.other_card.ability.name == 'Frozen Card' and not context.end_of_round then
            return {
                mult = card.ability.extra.frozen_mult
            }
        end
    end
}

SMODS.Joker { --Coldchain
    key = 'coldchain',
    name = 'Coldchain',
    atlas = 'Joker',
	pos = { x = 13, y = 20 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { chips = 6, freeze_limit = 30, current = 0 } --Variables: chips = +chips after each card, stun_limit = chips to stun card, current = current chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.chips, card.ability.extra.freeze_limit , card.ability.extra.current } }
    end,
    calculate = function (self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if not context.blueprint then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "current",
                        scalar_value = "chips",
                        no_message = true
                    })
                end
                if card.ability.extra.current >= card.ability.extra.freeze_limit then
                    context.other_card:set_ability(G.P_CENTERS.m_bloons_frozen, nil, true)
                end
                return {
                    chips = card.ability.extra.current
                }
            end
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
        end
    end
}

SMODS.Joker { --Frozen Verdict
    key = 'frozen_verdict',
    name = 'Frozen Verdict',
    atlas = 'Joker',
	pos = { x = 14, y = 20 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { Xmult = 0.5, current = 1 } --Variables: chips = +chips after each card, stun_limit = chips to stun card, current = current chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        elseif context.cards_destroyed and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.glass_shattered) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.current + card.ability.extra.Xmult*frozens}}})
                        return true
                    end
                }))
            end
        elseif context.remove_playing_cards and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.removed) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.Xmult*frozens}}})
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Winter's Mercy
    key = 'winters_mercy',
    name = "Winter's Mercy",
    atlas = 'Joker',
	pos = { x = 15, y = 20 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { Xmult_deck = 0.1, Xmult_destroyed = 0.5, destroyed = 0, current = 1 } --Variables: Xmult_deck = Xmult for frozens in deck = Xmult_destroyed = Xmult for frozens destroyed, destroyed = number destroyed, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.Xmult_deck, card.ability.extra.Xmult_destroyed, card.ability.extra.current } }
    end,
    update = function (self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local count = 0
            for k, v in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(v, 'm_bloons_frozen') then
                    count = count + 1
                end
            end
            card.ability.extra.current = 1 + card.ability.extra.Xmult_destroyed * card.ability.extra.destroyed + card.ability.extra.Xmult_deck * count
        end
    end,
    calculate = function (self, card, context)
        if context.joker_main and card.ability.extra.current > 1 then
            return {
                mult = card.ability.extra.current
            }
        elseif context.cards_destroyed and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.glass_shattered) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.current + card.ability.extra.Xmult*frozens}}})
                        return true
                    end
                }))
            end
        elseif context.remove_playing_cards and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.removed) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.Xmult*frozens}}})
                        return true
                    end
                }))
            end
        end
    end
}
