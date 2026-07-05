SMODS.Joker { --Ninja Monkey
    key = 'ninja_monkey',
    name = 'Ninja Monkey',
	atlas = 'Joker',
	pos = { x = 0, y = 16 },
    soul_atlas = 'Soul',
    soul_pos = { x = 0, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { mult = 4, slots = 1 } --Variables: mult = +mult, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra + card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra - card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
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
    key = 'ninja_discipline',
    name = 'Ninja Discipline',
	atlas = 'Joker',
	pos = { x = 1, y = 16 },
    soul_atlas = 'Soul',
    soul_pos = { x = 1, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { chips = 20, slots = 1 } --Variables: chips = +chips, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra + card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra - card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
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
    key = 'sharp_shurikens',
    name = 'Sharp Shurikens',
	atlas = 'Joker',
	pos = { x = 2, y = 16 },
    soul_atlas = 'Soul',
    soul_pos = { x = 2, y = 0 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { chips = 20, mult = 4, slots = 1 } --Variables: chips = +chips, mult = +mult, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra + card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra - card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
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
    key = 'double_shot_ninja',
    name = 'Double Shot (Ninja)',
	atlas = 'Joker',
	pos = { x = 3, y = 16 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { Xmult = 2, number = 2 } --Variables: Xmult = Xmult, number = required diamonds for Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for k, v in ipairs(context.scoring_hand) do
                if v:is_suit('Diamonds') then
                    count = count + 1
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
    key = 'bloonjitsu',
    name = 'Bloonjitsu',
	atlas = 'Joker',
	pos = { x = 4, y = 16 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { Xmult = 3, number = 3 } --Variables: Xmult = Xmult, number = required diamonds for Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for k, v in ipairs(context.scoring_hand) do
                if v:is_suit('Diamonds') then
                    count = count + 1
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

SMODS.Joker { --Grandmaster Ninja
    key = 'grandmaster_ninja',
    name = 'Grandmaster Ninja',
	atlas = 'Joker',
	pos = { x = 5, y = 16 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { Xmult = 0.5 }--Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total = 1
            for k, v in ipairs(context.scoring_hand) do
                if v:is_suit('Diamonds') then
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
    key = 'distraction',
    name = 'Distraction',
	atlas = 'Joker',
	pos = { x = 6, y = 16 },
    soul_atlas = 'Soul',
    soul_pos = { x = 6, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { num = 1, denom = 2, slots = 1, retrigger = 1 } --Variables: num/denom = probability fraction, slots = extra joker slots, retrigger = retrigger count
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'distraction')
        return { vars = { n, d, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra + card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra - card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] and SMODS.pseudorandom_probability(card, 'distraction', card.ability.extra.num, card.ability.extra.denom, 'distraction') then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --Counter Espionage
    key = 'counter_espionage',
    name = 'Counter Espionage',
    atlas = 'Joker',
	pos = { x = 7, y = 16 },
    soul_atlas = 'Soul',
    soul_pos = { x = 7, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { slots = 1 } --Variables: slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra + card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra - card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
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
    key = 'shinobi_tactics',
    name = 'Shinobi Tactics',
	atlas = 'Joker',
	pos = { x = 8, y = 16 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { Xmult = 1.25 } --Variables: Xmult = Xmult for each ninja
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.ability.tower_info and context.other_joker.ability.tower_info.base == 'Ninja Monkey' then
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
    key = 'bloon_sabotage',
    name = 'Bloon Sabotage',
	atlas = 'Joker',
	pos = { x = 9, y = 16 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { num = 1, denom = 2, discards = 1 } --Variables: num/denom = probability fraction, discards = number of discards gained
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'bloon_sabotage')
        return { vars = { n, d, card.ability.extra.discards } }
    end,

    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'bloon_sabotage', card.ability.extra.num, card.ability.extra.denom, 'bloon_sabotage') then
            local hasclub = false
            for k, v in ipairs(context.scoring_hand) do
                if v:is_suit('Clubs') then
                    hasclub = true
                end
            end
            if hasclub then
                ease_discard(card.ability.extra.discards)
                return {
                    message = '+1 Discard'
                }
            end
        end
    end
}

SMODS.Joker { --Grand Saboteur
    key = 'grand_saboteur',
    name = 'Grand Saboteur',
	atlas = 'Joker',
	pos = { x = 10, y = 16 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { num = 1, denom = 2, number = 2 } --Variables: num/denom = probability fraction, number = number of hearts for sabotage
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_bloons_sabotage
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'grand_saboteur')
        return { vars = { n, d, card.ability.extra.number } }
    end,

    calculate = function(self, card, context)
        if context.before then
            local count = 0
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:is_suit('Clubs') then
                        count = count + 1
                    end
                end
            end
            if count >= card.ability.extra.number and SMODS.pseudorandom_probability(card, 'grand_saboteur', card.ability.extra.num, card.ability.extra.denom, 'grand_saboteur') then
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
    key = 'seeking_shuriken',
    name = 'Seeking Shuriken',
	atlas = 'Joker',
	pos = { x = 11, y = 16 },
    soul_atlas = 'Soul',
    soul_pos = { x = 11, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { mult = 4, slots = 1 } --Variables: num/denom = probability fraction slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.joker_buffer = G.GAME.joker_buffer - card.ability.extra.slots
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
        G.E_MANAGER:add_event(Event({
            func = function()
                
            end
        }))
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
	atlas = 'Joker',
	pos = { x = 12, y = 16 },
    soul_atlas = 'Soul',
    soul_pos = { x = 12, y = 0 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { mult = 1, current = 0, slots = 1 } --Variables: mult = +mult each round, current = current +mult, slots = extra joker slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.slots, card.ability.extra.current } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra + card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra or 0
        G.GAME.joker_slot_base = G.GAME.joker_slot_base or G.jokers.config.card_limit

        G.GAME.joker_slot_extra = G.GAME.joker_slot_extra - card.ability.extra.slots
        G.jokers.config.card_limit = G.GAME.joker_slot_base + G.GAME.joker_slot_extra
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
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
    key = 'flash_bomb',
    name = 'Flash Bomb',
	atlas = 'Joker',
	pos = { x = 13, y = 16 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
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
    key = 'sticky_bomb',
    name = 'Sticky Bomb',
	atlas = 'Joker',
	pos = { x = 14, y = 16 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { Xmult = 3, active = false } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card.ability.sticky_bomb and not card.ability.extra.active and not context.blueprint then
            context.other_card.ability.sticky_bomb = false
            if context.stun and not context.other_card.debuff and not card.ability.extra.active then
                card.ability.extra.active = true
            end
        elseif context.joker_main then
            for k, v in ipairs(context.full_hand) do
                if v.ability.sticky_bomb then
                    v.ability.sticky_bomb = false
                end
            end
            for k, v in ipairs(G.hand.cards) do
                if v.ability.sticky_bomb then
                    v.ability.sticky_bomb = false
                end
            end
            if card.ability.extra.active then
                return {
                    Xmult = card.ability.extra.Xmult,
                }
            end
        elseif context.after and not context.blueprint then
            card.ability.extra.active = false
            local eligible_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if v:is_suit('Spades') and not v.debuff and not v.ability.sticky_bomb then
                    eligible_cards[#eligible_cards+1] = v
                end
            end
            if next(eligible_cards) and G.GAME.chips/G.GAME.blind.chips < to_big(1) then
                local stickied_card = pseudorandom_element(eligible_cards, 'sticky_bomb')
                stickied_card:set_ability(G.P_CENTERS.m_bloons_stunned)
                stickied_card.ability.sticky_bomb = true
                card_eval_status_text(stickied_card, 'extra', nil, nil, nil, {
                    message = 'Stickied!'
                })
            end
        end
    end
}

SMODS.Joker { --Master Bomber
    key = 'master_bomber',
    name = 'Master Bomber',
	atlas = 'Joker',
	pos = { x = 15, y = 16 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { Xmult = 1, current = 1 } --Variables: Xmult = Xmult per stickied, current = current stickied cards
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
        elseif context.joker_main and card.ability.extra.current > 1 then
            return {
                x_mult = card.ability.extra.current,
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.current = 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    for k, v in ipairs(G.hand.cards) do
                        if v:is_suit('Spades') then
                            v:set_ability(G.P_CENTERS.m_bloons_stunned)
                            card_eval_status_text(v, 'extra', nil, nil, nil, {
                                message = 'Stickied!'
                            })
                        end
                    end
                    return true
                end
            }))
        end
    end
}
