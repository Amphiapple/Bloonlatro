SMODS.Joker { --Sniper Monkey
    key = 'sniper_monkey',
    name = 'Sniper Monkey',
	loc_txt = {
        name = 'Sniper Monkey',
        text = {
            '{C:mult}+#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 7 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { mult = 20, limit = 3, counter = 3 } --Variables: mult = +mult, limit = number of hands for +mult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                return {
                    mult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Full Metal Jacket
    key = 'full_metal_jacket',
    name = 'Full Metal Jacket',
	loc_txt = {
        name = 'Full Metal Jacket',
        text = {
            '{C:mult}+#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 7 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { mult = 30, limit = 3, counter = 3 } --Variables: mult = +mult, limit = number of hands for +mult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                return {
                    mult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Large Calibre
    key = 'large_calibre',
    name = 'Large Calibre',
	loc_txt = {
        name = 'Large Calibre',
        text = {
            '{C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult every',
            '{C:attention}#3#{} hands played',
            '{C:inactive}(#4#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 7 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { chips = 30, mult = 30, limit = 3, counter = 3 } --Variables: chips = +chips, mult = +mult, limit = number of hands for +mult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
                card.ability.extra.chips,
				card.ability.extra.mult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Deadly Precision
    key = 'deadly_precision',
    name = 'Deadly Precision',
	loc_txt = {
        name = 'Deadly Precision',
        text = {
            '{X:mult,C:white}X#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 7 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { Xmult = 3, limit = 3, counter = 3 } --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.Xmult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Maim MOAB
    key = 'maim_moab',
    name = 'Maim MOAB',
	loc_txt = {
        name = 'Maim MOAB',
        text = {
            '{X:mult,C:white}X#1#{} Mult every',
            '{C:attention}#3#{} hands played',
            '{X:mult,C:white}X#2#{} Mult against',
            '{C:attention}Boss Blinds{}',
            '{C:inactive}(#4#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 7 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { Xmult = 2, Xmult_boss = 4, limit = 3, counter = 3 } --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.Xmult,
                card.ability.extra.Xmult_boss,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                if G.GAME.blind.boss then
                    return {
                        x_mult = card.ability.extra.Xmult_boss,
                    }
                else
                    return {
                        x_mult = card.ability.extra.Xmult,
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Cripple MOAB
    key = 'cripple_moab',
    name = 'Cripple MOAB',
	loc_txt = {
        name = 'Cripple MOAB',
        text = {
            '{X:mult,C:white}X#1#{} Mult and disable',
            'the current {C:attention}Boss Blind{}',
            'every {C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 7 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { Xmult = 3, limit = 3, counter = 3 } --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local disableable = G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))
            main_end = {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = self, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                        {n=G.UIT.T, config={text = ' '..localize(disableable and 'k_active' or 'ph_no_boss_active')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                    }}
                }}
            }
        end
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.Xmult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then 
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                    G.GAME.blind:disable_blind_modifiers()
                    G.GAME.blind:disable()
                end
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Night Vision Goggles
    key = 'night_vision_goggles',
    name = 'Night Vision Goggles',
    loc_txt = {
        name = 'Night Vision Goggles',
        text = {
            'Playing cards',
            'cannot be face down'
        }
    },
    atlas = 'Joker',
	pos = { x = 6, y = 7 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
    },

    update = function(self, card, dt)
        if G.GAME.blind then
            for k, v in pairs(G.hand.cards) do
                if v.facing == 'back' then
                    v:flip()
                end
            end
        end
    end
}

SMODS.Joker { --Shrapnel Shot
    key = 'shrapnel_shot',
    name = 'Shrapnel Shot',
    loc_txt = {
        name = 'Shrapnel Shot',
        text = {
            '{C:attention}Last{} played card',
            'gives Mult equal to',
            'the rank of the previous',
            'card when scored'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 7 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and #context.scoring_hand > 1 and
                context.other_card == context.scoring_hand[#context.scoring_hand] and
                not SMODS.has_no_rank(context.scoring_hand[#context.scoring_hand-1]) then
            local last_number = context.scoring_hand[#context.scoring_hand-1].base.nominal
            return {
                mult = last_number
            }
        end
    end
}

SMODS.Joker { --Bouncing Bullet
    key = 'bouncing_bullet',
    name = 'Bouncing Bullet',
    loc_txt = {
        name = 'Bouncing Bullet',
        text = {
            'Each scoring card',
            'gives Mult equal to',
            'the rank of the previous',
            'card when scored'
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 7 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and #context.scoring_hand > 1 then
            local last_card = nil
            for k, v in ipairs(context.scoring_hand) do
                if v == context.other_card then
                    last_card = context.scoring_hand[k-1]
                end
            end
            if last_card and not SMODS.has_no_rank(last_card) then
                return {
                    mult = last_card.base.nominal
                }
            end
        end
    end
}

SMODS.Joker { --Supply Drop
    key = 'supply_drop',
    name = 'Supply Drop',
    loc_txt = {
        name = 'Supply Drop',
        text = {
            'Earn {C:money}$#1#{} and',
            'create a {C:tarot}Tarot{} card',
            'card every {C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 7 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { limit = 4, counter = 4, money = 4 } --Variables: limit = number of hands for tarot, counter = hand index, money = dollars
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
                card.ability.extra.money,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'supply_drop')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        return true
                    end}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                return {
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            end
        end
    end
}

SMODS.Joker { --Elite Sniper
    key = 'elite_sniper',
    name = 'Elite Sniper',
    loc_txt = {
        name = 'Elite Sniper',
        text = {
            'Earn {C:money}$#1#{} and',
            'create a {C:power}Power{} card',
            'every {C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 7 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { limit = 4, counter = 4, money = 4 } --Variables: limit = number of hands for money and spectral, counter = hand index, money = dollars
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
                card.ability.extra.money,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = create_card('Power', G.consumeables, nil, nil, nil, nil, nil, 'elite_sniper')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1 Power', colour = G.C.YELLOW})
                return {
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            end
        end
    end
}

SMODS.Joker { --Fast Firing
    key = 'fast_firing_sniper',
    name = 'Fast Firing (Sniper)',
	loc_txt = {
        name = 'Fast Firing',
        text = {
            '{C:mult}+#1#{} Mult every',
            '{C:attention}2 or 3{} hands played',
            '{C:inactive}(#2#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 7 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { mult = 20, limit = 2.5, counter = 2.5 } --Variables: mult = +mult, limit = number of hands for +mult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if cap - count%cap - 1 <= 0 then
				return 'Active!'
			end
			return math.ceil(cap - count%cap - 1) .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.mult,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = math.fmod(G.GAME.hands_played - card.ability.hands_played_at_create, card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter >= card.ability.extra.limit - 1 and card.ability.extra.counter < card.ability.extra.limit
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter >= card.ability.extra.limit then
                return {
                    mult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Even Faster Firing
    key = 'even_faster_firing',
    name = 'Even Faster Firing',
	loc_txt = {
        name = 'Even Faster Firing',
        text = {
            '{C:mult}+#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 7 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { mult = 20, limit = 2, counter = 2 } --Variables: mult = +mult, limit = number of hands for +mult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                return {
                    mult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Semi Automatic
    key = 'semi_automatic',
    name = 'Semi Automatic',
	loc_txt = {
        name = 'Semi Automatic',
        text = {
            '{X:mult,C:white}X#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 7 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { Xmult = 2, limit = 2, counter = 2 } --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.Xmult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Full Auto Rifle
    key = 'full_auto_rifle',
    name = 'Full Auto Rifle',
	loc_txt = {
        name = 'Full Auto Rifle',
        text = {
            '{X:mult,C:white}X#1#{} Mult after',
            '{C:attention}first hand{} of round',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 7 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { Xmult = 2, limit = 2, counter = 2 } --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played > 0 then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Elite Defender
    key = 'elite_defender',
    name = 'Elite Defender',
    loc_txt = {
        name = 'Elite Defender',
        text = {
            '{X:mult,C:white}X#1#{} after {C:attention}first hand{} of round',
            '{X:mult,C:white}X#2#{} on {C:attention}final hand{} of round,',
            '{X:mult,C:white}X#3#{} on {C:attention}final hand{} of round if',
            'chips scored are under',
            '{C:attention}25%{} of required chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 7 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sniper Monkey", category = "military" },
        extra = { Xmult1 = 1.5, Xmult2 = 2, Xmult3 = 4 } --Variables: Xmult1 = Xmult after first hand, Xmult2 = Xmult on final hand, Xmult3 = XMult if under 25%
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult1, card.ability.extra.Xmult2, card.ability.extra.Xmult3 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.current_round.hands_left == 0 then
                if G.GAME.chips/G.GAME.blind.chips <= to_big(0.25) then
                    return {
                        x_mult = card.ability.extra.Xmult3
                    }
                else
                    return {
                        x_mult = card.ability.extra.Xmult2
                    }
                end
            elseif G.GAME.current_round.hands_played > 0 then
                return {
                    x_mult = card.ability.extra.Xmult1
                }
            end
        end
    end
}
