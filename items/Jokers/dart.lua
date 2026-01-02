
SMODS.Joker { --Dart Monkey
    key = 'dart',
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
        base = 'dart',
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
    key = 'sharp',
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
        base = 'dart',
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
    key = 'razor',
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
        base = 'dart',
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
    key = 'spult',
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
        base = 'dart',
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
    key = 'jugg',
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
        base = 'dart',
        extra = { mult = 2, current = 0 } --Variables: mult = +mult for each card scored, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
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
    key = 'ujugg',
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
        base = 'dart',
        extra = { Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult for each card scored, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
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
    key = 'quick',
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
        base = 'dart',
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
    key = 'veryquick',
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
        base = 'dart',
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
    key = 'tripshot',
    name = 'Triple Shot',
	loc_txt = {
        name = 'Triple Shot',
        text = {
            'Create {C:attention}#1# {C:tarot}Tarot{} cards',
            'if {C:attention}poker hand{} is a',
            '{C:attention}Three of a Kind #2#{} times',
            '{C:inactive}(#3# remaining){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 0 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'dart',
        extra = { tarots = 3, limit = 3, counter = 3 } --Variables: tarots = number of tarots, limit = number of 3oaks for tarots, counter = current count index
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.tarots, card.ability.extra.limit, card.ability.extra.counter } }
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == 'Three of a Kind' then
            if not context.blueprint then
                card.ability.extra.counter = card.ability.extra.counter - 1
                local eval = function()
                    return card.ability.extra.counter == 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == 0 then
                card.ability.extra.counter = card.ability.extra.limit
                for i = 1, card.ability.extra.tarots do
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'tripshot')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)
                        }))
                    end
                end
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+3 Tarots', colour = G.C.PURPLE})
            end
        end
    end
}

SMODS.Joker { --Super Monkey Fan Club
    key = 'smfc',
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
        base = 'dart',
        extra = { Xmult = 1.5 } --Variables: Xmult = Xmult for each transformed Dart
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and (context.other_joker.ability.base == 'dart' and context.other_joker:is_rarity('Common') or
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
    key = 'pmfc',
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
        base = 'dart',
        extra = { Xmult = 2 } --Variables: Xmult = Xmult for each transformed Dart
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and (context.other_joker.ability.base == 'dart' and context.other_joker:is_rarity('Common') or
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
    key = 'rangedart',
    name = 'Long Range Darts',
    loc_txt = {
        name = 'Long Range Darts',
        text = {
            '{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult',
            'Double chips and mult',
            'after {C:attention}first hand{} of round'
        }
    },
    atlas = 'Joker',
	pos = { x = 11, y = 0 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'dart',
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
    key = 'eyesight',
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
        base = 'dart',
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
    key = 'xbow',
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
        base = 'dart',
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
    key = 'sshooter',
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
        base = 'dart',
        extra = { mult = 30, limit = 10, counter = 1 } --Variables: mult = mult, limit = number of cards scored for mult, counter = card index
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
    key = 'xbm',
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
        base = 'dart',
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