SMODS.Joker { --Dartling Gunner
    key = 'dartling',
    name = 'Dartling Gunner',
	loc_txt = {
        name = 'Dartling Gunner',
        text = {
            '{C:chips}+??{} Chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 0, max = 150 } --Variables: min = min possible +chips, max = max possible +chips
    },

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_chips = pseudorandom('dartling', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Focused Firing
    key = 'focus',
    name = 'Focused Firing',
	loc_txt = {
        name = 'Focused Firing',
        text = {
            '{C:chips}+??{} Chips',
            'Higher chance of',
            'central values'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 0, q1 = 50, q3 = 100, max = 150 } --Variables: min = min possible +chips, q1,q3 = range for central values, max = max possible +chips
    },

    calculate = function(self, card, context)
        if context.joker_main then
            local r = pseudorandom(pseudoseed('focus'))
            local temp_chips
            if r < 0.5 then
                temp_chips = pseudorandom('focus', card.ability.extra.q1, card.ability.extra.q3)
            else
                temp_chips = pseudorandom('focus', card.ability.extra.min, card.ability.extra.max)
            end
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Laser Shock
    key = 'lshock',
    name = 'Laser Shock',
    loc_txt = {
        name = 'Laser Shock',
        text = {
            '{C:mult}+??{} Mult for current and',
            'next hand if scoring hand',
            'contains a {C:attention}face{} card',
            '{C:inactive}Shock damage {C:mult}+#1#{C:inactive} Mult{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 13 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 0, max = 23, mult = 0 } --Variables: max = max possible +mult, min = min possible +mult, mult = shock +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local has_face = false
            for k, v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    has_face = true
                end
            end
            local temp_mult = card.ability.extra.mult
            if has_face then
                local rand_mult = pseudorandom('lshock', card.ability.extra.min, card.ability.extra.max)
                temp_mult = temp_mult + rand_mult
                card.ability.extra.mult = rand_mult
            else
                card.ability.extra.mult = 0
            end
            if temp_mult > 0 then
                return {
                    mult = temp_mult
                }
            end
		end
    end
}

SMODS.Joker { --Laser Cannon
    key = 'lcan',
    name = 'Laser Cannon',
    loc_txt = {
        name = 'Laser Cannon',
        text = {
            'Each {C:attention}face{} card gives',
            '{C:mult}+??{} Mult when scored,',
            'store Mult as shock',
            'damage for next hand',
            '{C:inactive}Shock damage {C:mult}+#1#{C:inactive} Mult{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 13 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 0, max = 11, mult = 0, saved = 0 } --Variables: max = max possible +mult, min = min possible +mult, mult = shock +mult, saved = saved shock +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() and not context.other_card.debuff then
            local rand_mult = pseudorandom('lcan', card.ability.extra.min, card.ability.extra.max)
            if not context.blueprint then
                card.ability.extra.saved = card.ability.extra.saved + rand_mult
            end
            return {
                mult = rand_mult
            }
        elseif context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    mult = card.ability.extra.mult
                }
            end
		elseif context.after and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.saved
            card.ability.extra.saved = 0
        end
    end
}

SMODS.Joker { --Plasma Accelerator
    key = 'paccel',
    name = 'Plasma Accelerator',
	loc_txt = {
        name = 'Plasma Accelerator',
        text = {
            'Each repeated card rank',
            'in played hand gives',
            '{C:mult}+#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 13 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { mult = 10, ranks = {} } --Variables: mult = +mult, ranks = card ranks played
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local new_rank = true
            local id = context.other_card:get_id()
            if id < 0 then
                new_rank = false
            end
            for k, v in pairs(card.ability.extra.ranks) do
                if id == k then
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
            if new_rank and not context.blueprint then
                card.ability.extra.ranks[id] = true
            end
        elseif context.after and not context.blueprint then
            card.ability.extra.ranks = {}
        end
    end
}

SMODS.Joker { --Ray of Doom
    key = 'rod',
    name = 'Ray of Doom',
	loc_txt = {
        name = 'Ray of Doom',
        text = {
            'Each repeated card rank',
            'in played hand gives',
            '{X:mult,C:white}X#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 13 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { Xmult = 1.5, ranks = {} } --Variables: Xmult = Xmult, ranks = card ranks played
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local new_rank = true
            local id = context.other_card:get_id()
            if id < 0 then
                new_rank = false
            end
            for k, v in pairs(card.ability.extra.ranks) do
                if id == k then
                    return {
                        x_mult = card.ability.extra.Xmult
                    }
                end
            end
            if new_rank and not context.blueprint then
                card.ability.extra.ranks[id] = true
            end
        elseif context.after and not context.blueprint then
            card.ability.extra.ranks = {}
        end
    end
}

SMODS.Joker { --Advanced Targeting
    key = 'advanced',
    name = 'Advanced Targeting',
	loc_txt = {
        name = 'Advanced Targeting',
        text = {
            '{C:chips}+??{} Chips',
            'Smaller range of values'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 25, max = 125 } --Variables: min = min possible +chips, max = max possible +chips
    },

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_chips = pseudorandom('advanced', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Faster Barrel Spin
    key = 'fastspin',
    name = 'Faster Barrel Spin',
	loc_txt = {
        name = 'Faster Barrel Spin',
        text = {
            '{C:chips}+??{} Chips',
            'Higher possible values'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 13 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 50, max = 150 } --Variables: min = min possible +chips, max = max possible +chips
    },

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_chips = pseudorandom('fastspin', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Hydra Rocket Pods
    key = 'hrp',
    name = 'Hydra Rocket Pods',
	loc_txt = {
        name = 'Hydra Rocket Pods',
        text = {
            'This Joker gains {C:chips}+??{}',
            'Chips per {C:attention}consecutive{} hand',
            'played containing a {C:attention}Pair{}',
            '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 13 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'dartling',
        extra = { min = 0, max = 11, current = 0 } --Variables: min = min possible chip gain, max = max possible chips gain, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and context.poker_hands and not context.blueprint then
            if next(context.poker_hands['Pair']) then
                local temp_Xmult = pseudorandom('hrp', card.ability.extra.min, card.ability.extra.max) / 100.0
                card.ability.extra.current = card.ability.extra.current + temp_Xmult
            else
                card.ability.extra.current = 0
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED,
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Rocket Storm
    key = 'rorm',
    name = 'Rocket Storm',
	loc_txt = {
        name = 'Rocket Storm',
        text = {
            'This Joker gains {X:mult,C:white}X0.??{}',
            'Mult per {C:attention}consecutive{} hand',
            'played containing a {C:attention}Pair{}',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 13 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'dartling',
        extra = { min = 0, max = 15, current = 1 } --Variables: max = max possible Xmult gain *100, min = min possible Xmult gain *100, current = current Xmult
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and context.poker_hands and not context.blueprint then
            if next(context.poker_hands['Pair']) then
                local temp_Xmult = pseudorandom('rorm', card.ability.extra.min, card.ability.extra.max) / 100.0
                card.ability.extra.current = card.ability.extra.current + temp_Xmult
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED,
                    delay = 0.45,
                }
            else
                card.ability.extra.current = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED,
                }
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --M.A.D
    key = 'mad',
    name = 'M.A.D',
	loc_txt = {
        name = 'M.A.D',
        text = {
            'This Joker gains {X:mult,C:white}X0.??{} Mult',
            'when {C:attention}Boss Blind{} is selected',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 13 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'dartling',
        extra = { min = 25, max = 100, current = 1 } --Variables: min = min possible Xmult gain *100, max = max possible Xmult gain *100, current = current Xmult
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.blind.boss and not card.getting_sliced and not context.blueprint then
            local temp_Xmult = pseudorandom('mad', card.ability.extra.min, card.ability.extra.max) / 100.0
            card.ability.extra.current = card.ability.extra.current + temp_Xmult
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Faster Swivel
    key = 'swivel',
    name = 'Faster Swivel',
	loc_txt = {
        name = 'Faster Swivel',
        text = {
            '{C:chips}+??{} Chips',
            'Higher chance of',
            'edge values'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 0, q1 = 50, q3 = 100, max = 150 } --Variables: max = max possible +chips, q1-q3 = range for extreme values, min = min possible +chips
    },

    calculate = function(self, card, context)
        if context.joker_main then
            local r = pseudorandom(pseudoseed('swivel'))
            local temp_chips
            if r < 0.33 then
                temp_chips = pseudorandom('swivel', card.ability.extra.min, card.ability.extra.q1)
            elseif r > 0.67 then
                temp_chips = pseudorandom('swivel', card.ability.extra.q3, card.ability.extra.max)
            else
                temp_chips = pseudorandom('swivel', card.ability.extra.min, card.ability.extra.max)
            end
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Powerful Darts
    key = 'powerful',
    name = 'Powerful Darts',
	loc_txt = {
        name = 'Powerful Darts',
        text = {
            '{C:green}#1# in #2#{} chance for',
            '{C:chips}+??{} Chips',
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 13 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { num = 1, denom = 2, min = 150, max = 250 } --Variables: num/denom = probabiltiy fraction, max = max possible +chips, min = min possible +chips
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'powerful')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and SMODS.pseudorandom_probability(card, 'powerful', card.ability.extra.num, card.ability.extra.denom, 'powerful') then
            local temp_chips = pseudorandom('powerful', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Buckshot
    key = 'buckshot',
    name = 'Buckshot',
	loc_txt = {
        name = 'Buckshot',
        text = {
            '{X:mult,C:white}X?.?{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 13 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { max = 20, min = 10 } --Variables: max = max possible Xmult *10, min = min possible Xmult *10
    },

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Xmult = pseudorandom('buckshot', card.ability.extra.min, card.ability.extra.max) / 10.0
            return {
                x_mult = temp_Xmult
            }
		end
    end
}

SMODS.Joker { --Bloon Area Denial System
    key = 'bads',
    name = 'Bloon Area Denial System',
	loc_txt = {
        name = 'Bloon Area Denial System',
        text = {
            '{C:attention}First{}, {C:attention}last{}, {C:attention}lowest{}, and',
            '{C:attention}highest{} rank cards give',
            '{X:mult,C:white}X?.?{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 13 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 100, max = 150, cards = {} } --Variables: min = min possible Xmult *100, max = max possible Xmult *100
    },

    calculate = function(self, card, context)
        if context.before then
            local low = 0
            local high = 0
            for k, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then
                    local id = v:get_id()
                    if k == 1 then
                        card.ability.extra.cards['first'] = v
                        low = id
                        high = id
                    end
                    if k == #context.scoring_hand then
                        card.ability.extra.cards['last'] = v
                    end
                    if id < low then
                        low = id
                        card.ability.extra.cards['low'] = v
                    end
                    if id > high then
                        high = id
                        card.ability.extra.cards['high'] = v
                    end
                end
            end
        elseif context.individual and context.cardarea == G.play and not context.other_card.debuff then
            for k, v in pairs(card.ability.extra.cards) do
                if context.other_card == v then
                    local temp_Xmult = pseudorandom('bads', card.ability.extra.min, card.ability.extra.max) / 100
                    return {
                        x_mult = temp_Xmult
                    }
                end
            end
		end
    end
}

SMODS.Joker { --Bloon Exclusion Zone
    key = 'bez',
    name = 'Bloon Exclusion Zone',
	loc_txt = {
        name = 'Bloon Exclusion Zone',
        text = {
            '{C:attention}First{}, {C:attention}last{}, and',
            '{C:attention}highest{} rank cards played',
            'or held in hand give',
            '{X:mult,C:white}X?.?{} Mult when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 13 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { min = 100, max = 150, cards = {} } --Variables: min = min possible Xmult *100, max = max possible Xmult *100
    },

    calculate = function(self, card, context)
        if context.before then
            local high = 0
            for k, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then
                    local id = v:get_id()
                    if k == 1 then
                        card.ability.extra.cards['first'] = v
                        high = id
                    end
                    if k == #context.scoring_hand then
                        card.ability.extra.cards['last'] = v
                    end
                    if id > high then
                        high = id
                        card.ability.extra.cards['high'] = v
                    end
                end
            end
            high = 0
            for k, v in ipairs(G.hand.cards) do
                if not SMODS.has_no_rank(v) then
                    local id = v:get_id()
                    if k == 1 then
                        card.ability.extra.cards['h_first'] = v
                        high = id
                    end
                    if k == #G.hand.cards then
                        card.ability.extra.cards['h_last'] = v
                    end
                    if id > high then
                        high = id
                        card.ability.extra.cards['h_high'] = v
                    end
                end
            end
        elseif context.individual and (context.cardarea == G.play or context.cardarea == G.hand) and not context.other_card.debuff and not context.end_of_round then
            for k, v in pairs(card.ability.extra.cards) do
                if context.other_card == v then
                    local temp_Xmult = pseudorandom('bez', card.ability.extra.min, card.ability.extra.max) / 100
                    return {
                        x_mult = temp_Xmult
                    }
                end
            end
		end
    end
}
