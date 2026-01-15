SMODS.Joker { --Ninja Monkey
    key = 'ninja',
    name = 'Ninja Monkey',
	loc_txt = {
        name = 'Ninja Monkey',
        text = {
            '{C:mult}+#1#{} Mult',
            '{C:dark_edition}+#2#{} Joker Slot'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 16 },
    soul_pos = { x = 5, y = 27 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { mult = 4, slots = 1 } --Variables: mult = +mult, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Ninja Discipline
    key = 'discipline',
    name = 'Ninja Discipline',
	loc_txt = {
        name = 'Ninja Discipline',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:dark_edition}+#2#{} Joker Slot'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 16 },
    soul_pos = { x = 6, y = 27 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { chips = 30, slots = 1 } --Variables: chips = +chips, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --Sharp Shurikens
    key = 'sharpshur',
    name = 'Sharp Shurikens',
	loc_txt = {
        name = 'Sharp Shurikens',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult',
            '{C:dark_edition}+#3#{} Joker Slot'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 16 },
    soul_pos = { x = 7, y = 27 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { chips = 30, mult = 4, slots = 1 } --Variables: chips = +chips, mult = +mult, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Double Shot
    key = 'doubleshur',
    name = 'Double Shot',
	loc_txt = {
        name = 'Double Shot',
        text = {
            '{X:mult,C:white}X#1#{} Mult if',
            'scoring hand contains',
            'at least {C:attention}#2#',
            '{C:diamonds}Diamond{} cards'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 16 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { Xmult = 2, number = 2 } --Variables: Xmult = Xmult, number = required diamonds for Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:is_suit('Diamonds', true) and not v.debuff then
                        count = count + 1
                    end
                end
            end
            if count >= card.ability.extra.number then
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        end
    end
}

SMODS.Joker { --Bloonjitsu
    key = 'jitsu',
    name = 'Bloonjitsu',
	loc_txt = {
        name = 'Bloonjitsu',
        text = {
            '{X:mult,C:white}X#1#{} Mult if',
            'scoring hand contains',
            'a {C:diamonds}Diamond{} card'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 16 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { Xmult = 2 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local has_diamond = false
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:is_suit('Diamonds', true) and not v.debuff then
                        has_diamond = true
                    end
                end
            end
            if has_diamond then
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        end
    end
}

SMODS.Joker { --Grandmaster Ninja
    key = 'gmn',
    name = 'Grandmaster Ninja',
	loc_txt = {
        name = 'Grandmaster Ninja',
        text = {
            'Gives {X:mult,C:white}X#1#{} Mult for',
            'each scoring {C:diamonds}Diamond{}',
            'in played {C:attention}poker hand{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 16 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = { 
        base = 'ninja',
        extra = { Xmult = 0.5 }--Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total = 1
            for k, v in ipairs(context.scoring_hand) do
                if v:is_suit('Diamonds', true) and not v.debuff then
                    total = total + card.ability.extra.Xmult
                end
            end
            if total > 1 then
                return {
                    x_mult = total
                }
            end
		end
    end
}

SMODS.Joker { --Distraction
    key = 'distract',
    name = 'Distraction',
	loc_txt = {
        name = 'Distraction',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'retrigger {C:attention}first{}',
            'scoring card',
            '{C:dark_edition}+#3#{} Joker Slot'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 16 },
    soul_pos = { x = 8, y = 27 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { num = 1, denom = 2, slots = 1, retrigger = 1 } --Variables: num/denom = probability fraction, slots = extra joker slots, retrigger = retrigger count
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'distract')
        return { vars = { n, d, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] and SMODS.pseudorandom_probability(card, 'distract', card.ability.extra.num, card.ability.extra.denom, 'distract') then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}
--[[
SMODS.Joker { --Counter Espionage
    key = 'espionage',
    name = 'Counter Espionage',
    loc_txt = {
        name = 'Counter Espionage',
        text = {
            'When {C:attention}Blind{} is selected,',
            'combine hands and discards',
            'Lose all hands and discards',
            'at the end of round'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 16 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'ninja',
        extra = { ready = true, active = false, hands = 0, discards = 0 } --Variables: ready = ready to combine hands and discards, active = hands merged with discards, hands = added hands, discards = added discards
    },

    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.active then
            if G.GAME.round_resets.hands - G.GAME.current_round.hands_played <= 0 then
                ease_hands_played(1 - G.GAME.current_round.hands_left)
            else
                ease_hands_played(G.GAME.round_resets.hands - G.GAME.current_round.hands_played - G.GAME.current_round.hands_left)
            end
            if G.GAME.round_resets.discards - G.GAME.current_round.discards_used < 0 then
                ease_discard(-G.GAME.current_round.discards_left)
            else
                ease_discard(G.GAME.round_resets.discards - G.GAME.current_round.discards_used - G.GAME.current_round.discards_left)
            end
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and card.ability.extra.ready and not context.getting_sliced and not context.blueprint then
            local espionages = find_joker('Counter Espionage')
            for k, v in pairs(espionages) do
                if v ~= card then
                    v.ability.extra.ready = false
                end
            end
            card.ability.extra.active = true
            card.ability.extra.hands = G.GAME.current_round.discards_left
            card.ability.extra.discard = G.GAME.current_round.hands_left
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(G.GAME.current_round.discards_left)
                    ease_discard(G.GAME.current_round.hands_left)
                    return true
                end 
            }))
        elseif context.before and card.ability.extra.active and G.GAME.current_round.discards_left > G.GAME.current_round.hands_left and not context.blueprint then
            ease_discard(-1)
        elseif context.pre_discard and card.ability.extra.active and G.GAME.current_round.hands_left >= G.GAME.current_round.discards_left then
            ease_hands_played(-1)
            if G.GAME.current_round.hands_left <= 1 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        G.STATE = G.STATES.GAME_OVER
                        G.STATE_COMPLETE = false
                        return true
                    end
                }))
            end
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if card.ability.extra.active then
                ease_hands_played(-G.GAME.current_round.hands_left)
                ease_discard(-G.GAME.current_round.discards_left)
            end
            card.ability.extra.active = false
            card.ability.extra.ready = true
        end
    end
}
]]
SMODS.Joker { --Counter Espionage
    key = 'espionage',
    name = 'Counter Espionage',
    loc_txt = {
        name = 'Counter Espionage',
        text = {
            'When {C:attention}Blind{} is selected,',
            'balance hands and discards',
            '{C:dark_edition}+#1#{} Joker Slot'

        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 16 },
    soul_pos = { x = 9, y = 27 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    config = {
        base = 'ninja',
        extra = { slots = 1 } --Variables: slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.getting_sliced and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local total = G.GAME.current_round.hands_left + G.GAME.current_round.discards_left
                    local hands = math.ceil(total / 2)
                    local discards = math.floor(total / 2)
                    ease_hands_played(hands - G.GAME.current_round.hands_left)
                    ease_discard(discards - G.GAME.current_round.discards_left)
                    return true
                end 
            }))
        end
    end
}

SMODS.Joker { --Shinobi Tactics
    key = 'shinobi',
    name = 'Shinobi Tactics',
	loc_txt = {
        name = 'Shinobi Tactics',
        text = {
            '{C:attention}Ninjas{} give {X:mult,C:white}X#1#{} Mult',
            'All {C:attention}Ninjas{} may appear',
            'multiple times'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 16 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { Xmult = 1.25 } --Variables: Xmult = Xmult for each ninja
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.slots } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.ability.base == 'ninja' then
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

SMODS.Joker { --Bloon Sabotage
    key = 'sabo',
    name = 'Bloon Sabotage',
	loc_txt = {
        name = 'Bloon Sabotage',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'gain {C:red}+#3#{} discard if scoring',
            'hand contains a {C:hearts}Heart{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 16 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { num = 1, denom = 2, discards = 1 } --Variables: num/denom = probability fraction, discards = number of discards gained
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'sabo')
        return { vars = { n, d, card.ability.extra.discards } }
    end,

    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'sabo', card.ability.extra.num, card.ability.extra.denom, 'sabo') then
            local hasheart = false
            for k, v in ipairs(context.scoring_hand) do
                if (v.ability.name == 'Wild Card' or v:is_suit('Hearts')) and not v.debuff then
                    hasheart = true
                end
            end
            if hasheart then
                ease_discard(card.ability.extra.discards)
                return {
                    message = '+1 Discard'
                }
            end
        end
    end
}

SMODS.Joker { --Grand Saboteur
    key = 'gsabo',
    name = 'Grand Saboteur',
	loc_txt = {
        name = 'Grand Saboteur',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'create a {C:attention}Sabotage Tag{}',
            'if scoring hand contains',
            'at least {C:attention}#3# {C:hearts}Heart{} cards'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 16 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { num = 1, denom = 2, number = 2 } --Variables: num/denom = probability fraction, number = number of hearts for sabotage
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.tag_bloons_sabotage
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'gsabo')
        return { vars = { n, d, card.ability.extra.number } }
    end,

    calculate = function(self, card, context)
        if context.before then
            local count = 0
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:is_suit('Hearts', true) and not v.debuff then
                        count = count + 1
                    end
                end
            end
            if count >= card.ability.extra.number and SMODS.pseudorandom_probability(card, 'gsabo', card.ability.extra.num, card.ability.extra.denom, 'gsabo') then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_bloons_sabotage'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                       return true
                   end)
                }))
            end
        end
    end
}

SMODS.Joker { --Seeking Shuriken
    key = 'seeking',
    name = 'Seeking Shuriken',
	loc_txt = {
        name = 'Seeking Shuriken',
        text = {
            'First played card',
            'gives {C:mult}+#1#{} Mult',
            'when scored',
            '{C:dark_edition}+#2#{} Joker Slot'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 16 },
    soul_pos = { x = 10, y = 27 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { mult = 4, slots = 1 } --Variables: num/denom = probability fraction slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] and not context.other_card.debuff then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Caltrops
    key = 'caltrops',
    name = 'Caltrops',
	loc_txt = {
        name = 'Caltrops',
        text = {
            'This Joker gains {C:mult}+#1#{} Mult',
            'when {C:attention}Blind{} is selected',
            '{C:dark_edition}+#2#{} Joker Slot',
            '{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)'

        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 16 },
    soul_pos = { x = 11, y = 27 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { mult = 1, current = 0, slots = 1 } --Variables: mult = +mult each round, current = current +mult, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.slots, card.ability.extra.current } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.getting_sliced and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
            }
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Flash Bomb
    key = 'flash',
    name = 'Flash Bomb',
	loc_txt = {
        name = 'Flash Bomb',
        text = {
            '{C:mult}+#1#{} Mult and',
            '{C:attention}Stun{} all scoring cards',
            'every {C:attention}#2#{} hands',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 16 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { mult = 40, limit = 3, counter = 3 } --Variables: mult = +mult, limit = number of hands for Xmult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
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
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            local eval = function()
                return card.ability.extra.counter == card.ability.extra.limit - 1
            end
            juice_card_until(card, eval, true)
            if card.ability.extra.counter == card.ability.extra.limit then
                for k, v in ipairs(context.scoring_hand) do
                    if not v.debuff then
                        v:set_ability(G.P_CENTERS.m_bloons_stunned)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
            end
        elseif context.joker_main and card.ability.extra.counter == card.ability.extra.limit then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Sticky Bomb
    key = 'sticky',
    name = 'Sticky Bomb',
	loc_txt = {
        name = 'Sticky Bomb',
        text = {
            '{C:attention}Stun{} a held {C:spades}Spade{}',
            'each hand played',
            '{X:mult,C:white}X#1#{} Mult when',
            'it wears off',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 16 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { Xmult = 2, stickied = nil, active = false } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.hook and not context.other_card.debuff and not context.blueprint then
            if context.other_card == card.ability.extra.stickied and context.stun then
                card.ability.extra.active = true
            end
        elseif context.initial_scoring_step and not context.blueprint then
            local eligible_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if v:is_suit('Spades', true) and v ~= card.ability.extra.stickied and not v.debuff then
                    eligible_cards[#eligible_cards+1] = v
                end
            end
            if next(eligible_cards) then
                card.ability.extra.stickied = pseudorandom_element(eligible_cards, pseudoseed('sticky'))
                card.ability.extra.stickied:set_ability(G.P_CENTERS.m_bloons_stunned)
                return {
                    message = 'Stickied!',
                    colour = G.C.RED
                }
            else
                card.ability.extra.stickied = nil
            end
        elseif context.joker_main and card.ability.extra.active then
            card.ability.extra.active = false
            return {
                Xmult = card.ability.extra.Xmult,
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.stickied = nil
        end
    end
}

SMODS.Joker { --Master Bomber
    key = 'mbomber',
    name = 'Master Bomber',
	loc_txt = {
        name = 'Master Bomber',
        text = {
            '{C:attention}Stun{} all held {C:spades}Spades{}',
            'each hand played',
            '{X:mult,C:white}X#1#{} Mult for each {C:attention}Stunned{}',
            'card that wears off'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 16 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { Xmult = 1, current = 1 } --Variables: Xmult = Xmult per stickied, current = 
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.hook and not context.other_card.debuff and not context.blueprint then
            if context.other_card.ability.name == 'Stunned Card' and context.stun then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            end
        elseif context.initial_scoring_step and not context.blueprint then
            local has_spades = false
            for k, v in ipairs(G.hand.cards) do
                if v:is_suit('Spades', true) then
                    v:set_ability(G.P_CENTERS.m_bloons_stunned)
                    has_spades = true
                end
            end
            if has_spades then
                return {
                    message = 'Stickied!',
                    colour = G.C.RED
                }
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.current = 1
        end
    end
}
