
SMODS.Joker { --Dart Monkey
    key = 'dart_monkey',
    name = 'Dart Monkey',
	loc_txt = {
        name = 'Dart Monkey',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 0 },
    rarity = 1,
	cost = 2,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { chips = 30, mult = 2 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Sharp Shots
    key = 'sharp_shots',
    name = 'Sharp Shots',
    loc_txt = {
        name = 'Sharp Shots',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 0 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { chips = 30, mult = 4 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Razor Sharp Shots
    key = 'razor_sharp_shots',
    name = 'Razor Sharp Shots',
    loc_txt = {
        name = 'Razor Sharp Shots',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { chips = 30, mult = 6 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Spike-o-pult
    key = 'spike_o_pult',
    name = 'Spike-o-pult',
	loc_txt = {
        name = 'Spike-o-pult',
        text = {
            'Each played card gives',
            '{C:mult}+#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 0 },
    rarity = 2,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { mult = 4 } --Variables: mult = +mult for each card scored
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Juggernaut
    key = 'juggernaut',
    name = 'Juggernaut',
	loc_txt = {
        name = 'Juggernaut',
        text = {
            'Each played card gives',
            '{C:mult}+#1#{} more Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 0 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { mult = 2, current = 0 } --Variables: mult = +mult for each card scored, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                if not context.blueprint then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                end
                return {
                    mult = card.ability.extra.current
                }
            end
		elseif context.after then
            card.ability.extra.current = 0
        end
    end
}

SMODS.Joker { --Ultra-Juggernaut
    key = 'ultra_juggernaut',
    name = 'Ultra-Juggernaut',
	loc_txt = {
        name = 'Ultra-Juggernaut',
        text = {
            'Each played card gives',
            '{X:mult,C:white}X#1#{} more Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 0 },
    rarity = 3,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult for each card scored, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                if not context.blueprint then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                end
                return {
                    x_mult = card.ability.extra.current
                }
            end
		elseif context.after then
            card.ability.extra.current = 1
        end
    end
}

SMODS.Joker { --Quick Shots
    key = 'quick_shots',
    name = 'Quick Shots',
    loc_txt = {
        name = 'Quick Shots',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 6, y = 0 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { chips = 45, mult = 2 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Very Quick Shots
    key = 'very_quick_shots',
    name = 'Very Quick Shots',
    loc_txt = {
        name = 'Very Quick Shots',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { chips = 60, mult = 2 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Triple Shot
    key = 'triple_shot',
    name = 'Triple Shot',
	loc_txt = {
        name = 'Triple Shot',
        text = {
            '{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult',
            'if played hand has',
            'exactly {C:attention}#3#{} cards',
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 0 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { chips = 60, mult = 12, number = 3 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand == card.ability.extra.number then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Super Monkey Fan Club
    key = 'super_monkey_fan_club',
    name = 'Super Monkey Fan Club',
	loc_txt = {
        name = 'Super Monkey Fan Club',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            'Common {C:attention}Dart Monkeys',
            'and {C:attention}Fan Club{} members',
            'give {X:mult,C:white}X#1#{} Mult',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 0 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { Xmult = 1.5 } --Variables: Xmult = Xmult for each transformed Dart
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and (context.other_joker.ability.tower_info.base == "Dart Monkey" and context.other_joker:is_rarity('Common') or
                context.other_joker.ability.name == "Triple Shot" or
                context.other_joker.ability.name == "Super Monkey Fan Club" or
                context.other_joker.ability.name == "Plasma Monkey Fan Club") then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Plasma Monkey Fan Club
    key = 'plasma_monkey_fan_club',
    name = 'Plasma Monkey Fan Club',
	loc_txt = {
        name = 'Plasma Monkey Fan Club',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            'Common {C:attention}Dart Monkeys',
            'and {C:attention}Fan Club{} members',
            'give {X:mult,C:white}X#1#{} Mult',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 0 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { Xmult = 2 } --Variables: Xmult = Xmult for each transformed Dart
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and (context.other_joker.ability.tower_info.base == "Dart Monkey" and context.other_joker:is_rarity('Common') or
                context.other_joker.ability.name == "Triple Shot" or
                context.other_joker.ability.name == "Super Monkey Fan Club" or
                context.other_joker.ability.name == "Plasma Monkey Fan Club") then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Long Range Darts
    key = 'long_range_darts',
    name = 'Long Range Darts',
    loc_txt = {
        name = 'Long Range Darts',
        text = {
            '{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult',
            'double chips and mult after',
            '{C:attention}first hand{} of round'
        }
    },
    atlas = 'Joker',
	pos = { x = 11, y = 0 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { chips = 30, mult = 2, current_chips = 30, current_mult = 2 } --Variables: chips = +chips, mult = +mult, current_chips = chips if doubled, current_mult = mult if doubled
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_chips, card.ability.extra.current_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.current_chips,
                mult = card.ability.extra.current_mult
            }
        elseif context.after and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            card.ability.extra.current_chips = card.ability.extra.chips * 2
            card.ability.extra.current_mult = card.ability.extra.mult * 2
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current_chips = card.ability.extra.chips
            card.ability.extra.current_mult = card.ability.extra.mult
        end
    end
}

SMODS.Joker { --Enhanced Eyesight
    key = 'enhanced_eyesight',
    name = 'Enhanced Eyesight',
    loc_txt = {
        name = 'Enhanced Eyesight',
        text = {
            '{C:attention}+#1#{} consumable slot'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    config = { 
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { slots = 1 } --Variables: slots = extra consumable slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
    end,
}

SMODS.Joker { --Crossbow
    key = 'crossbow',
    name = 'Crossbow',
	loc_txt = {
        name = 'Crossbow',
        text = {
            '{C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult if you',
            'have a consumable'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 0 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { chips = 60, mult = 12 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #G.consumeables.cards + G.GAME.consumeable_buffer > 0 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Sharp Shooter
    key = 'sharp_shooter',
    name = 'Sharp Shooter',
	loc_txt = {
        name = 'Sharp Shooter',
        text = {
            '{C:attention}CRITS{} for {C:mult}+#1#{} Mult',
            'every {C:attention}#2#{} cards scored',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 0 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { mult = 40, limit = 10, counter = 1 } --Variables: mult = mult, limit = number of cards scored for mult, counter = card index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap then
				return 'Next!'
			end
			return cap - count%cap .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.before then
            self.pre_sshooter_blueprints = self.pre_sshooter_blueprints or {}

            for _, joker in ipairs(G.jokers.cards) do
                if joker == card then break end
                if context.blueprint_card and joker == context.blueprint_card then
                    table.insert(self.pre_sshooter_blueprints, joker)
                end
            end
        end

        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.counter = (card.ability.extra.counter == card.ability.extra.limit) and 1
                                        or (card.ability.extra.counter + 1)
        end

        if context.individual and context.cardarea == G.play then
            for _, joker in ipairs(self.pre_sshooter_blueprints or {}) do
                if joker == context.blueprint_card then
                    if card.ability.extra.counter ~= card.ability.extra.limit then return end
                    return {
                        mult = card.ability.extra.mult,
                        message_card = context.other_card
                    }
                end
            end

            if card.ability.extra.counter == 1 then
                return {
                    mult = card.ability.extra.mult,
                    message_card = context.other_card
                }
            end
        end

        if context.after then
            self.pre_sshooter_blueprints = {}
        end
    end
}

SMODS.Joker { --Crossbow Master
    key = 'crossbow_master',
    name = 'Crossbow Master',
	loc_txt = {
        name = 'Crossbow Master',
        text = {
            '{C:attention}CRITS{} for {X:mult,C:white}X#1#{} Mult',
            'every {C:attention}#2#{} cards scored',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 0 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { Xmult = 3, limit = 5, counter = 1 } --Variables: Xmult = Xmult, limit = number of cards scored for Xmult, counter = card index
    }, 

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap then
				return 'Next!'
			end
			return cap - count%cap .. ' remaining'
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
        if context.before then
            self.pre_xbm_blueprints = self.pre_xbm_blueprints or {}

            for _, joker in ipairs(G.jokers.cards) do
                if joker == card then break end
                if context.blueprint_card and joker == context.blueprint_card then
                    table.insert(self.pre_xbm_blueprints, joker)
                end
            end
        end

        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.counter = (card.ability.extra.counter == card.ability.extra.limit) and 1
                                        or (card.ability.extra.counter + 1)
        end

        if context.individual and context.cardarea == G.play then
            for _, joker in ipairs(self.pre_xbm_blueprints or {}) do
                if joker == context.blueprint_card then
                    if card.ability.extra.counter ~= card.ability.extra.limit then return end
                    return {
                        x_mult = card.ability.extra.Xmult,
                        message_card = context.other_card
                    }
                end
            end

            if card.ability.extra.counter == 1 then
                return {
                    x_mult = card.ability.extra.Xmult,
                    message_card = context.other_card
                }
            end
        end

        if context.after then
            self.pre_xbm_blueprints = {}
        end
    end
}