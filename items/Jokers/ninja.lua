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
	pos = { x = 5, y = 1 },
    soul_pos = { x = 0, y = 15 },
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

SMODS.Joker { --Counter Espionage
    key = 'espionage',
    name = 'Counter Espionage',
    loc_txt = {
        name = 'Counter Espionage',
        text = {
            'When {C:attention}Blind{} is selected,',
            'combine hands and discards'
        }
    },
    atlas = 'Joker',
	pos = { x = 5, y = 4 },
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
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.ability.extra.hands = G.GAME.current_round.discards_left
                    ease_hands_played(G.GAME.current_round.discards_left)
                    card.ability.extra.discard = G.GAME.current_round.hands_left
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
            card.ability.extra.ready = true
            card.ability.extra.active = false
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
            '{C:attention}Stun{} all scoring {C:spades}Spades{}',
            'every {C:attention}#2#{} hands',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 7 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
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
                    if v:is_suit('Spades', true) then
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

SMODS.Joker { --Shinobi Tactics
    key = 'shinobi',
    name = 'Shinobi Tactics',
	loc_txt = {
        name = 'Shinobi Tactics',
        text = {
            '{C:attention}Ninjas{} give {X:mult,C:white}X#1#{} Mult',
            '{C:dark_edition}+#2#{} Joker Slot',
            'All {C:attention}Ninjas{} may appear',
            'multiple times'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 8 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ninja',
        extra = { Xmult = 1.2, slots = 1 } --Variables: Xmult = Xmult for each ninja, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
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
            'gain {C:red}+#3#{} discard if',
            'played hand has a scoring',
            '{C:hearts}Heart{} and a scoring',
            'card of any other {C:attention}suit{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 10 },
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
            local suits = {
                ['Hearts'] = 0,
                ['Diamonds'] = 0,
                ['Spades'] = 0,
                ['Clubs'] = 0
            }
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name ~= 'Wild Card' then
                    if v:is_suit('Hearts') then suits["Hearts"] = suits["Hearts"] + 1 end
                    if v:is_suit('Diamonds') then suits["Diamonds"] = suits["Diamonds"] + 1 end
                    if v:is_suit('Spades') then suits["Spades"] = suits["Spades"] + 1 end
                    if v:is_suit('Clubs') then suits["Clubs"] = suits["Clubs"] + 1 end
                end
            end
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Wild Card' then
                    if v:is_suit('Clubs') and suits["Clubs"] == 0 then suits["Clubs"] = suits["Clubs"] + 1
                    elseif v:is_suit('Diamonds') and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
                    elseif v:is_suit('Spades') and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
                    elseif v:is_suit('Hearts') and suits["Hearts"] == 0  then suits["Hearts"] = suits["Hearts"] + 1 end
                end
            end
            if suits["Hearts"] > 0 and
            (suits["Diamonds"] > 0 or
            suits["Spades"] > 0 or
            suits["Clubs"] > 0) then
                ease_discard(card.ability.extra.discards)
                return {
                    message = '+1 Discard'
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
	pos = { x = 5, y = 13 },
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
