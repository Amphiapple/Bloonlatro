SMODS.Joker { --Glaive Dominus
    key = 'glaive_dominus',
    name = 'Glaive Dominus',
	loc_txt = {
        name = 'Glaive Dominus',
        text = {
            'Play each {C:attention}Boss Blind{} twice,',
            'This Joker gains {X:mult,C:white}X#1#{} Mult',
            'when {C:attention}Boss Blind{} is defeated',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive}){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 27 },
    soul_pos = { x = 1, y = 28 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { Xmult = 0.25, current = 1, active = true } --Variables = Xmult = Xmult per boss defeated the second time, current = current Xmult, active = if next boss will be repeated
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        elseif context.end_of_round and context.beat_boss and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            card.ability.extra.active = true
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED,
                delay = 0.45,
            }
        end            
    end
}

SMODS.Joker { --Goliath Doomship
    key = 'goliath_doomship',
    name = 'Goliath Doomship',
	loc_txt = {
        name = 'Goliath Doomship',
        text = {
            'Apply the effects',
            'of all {C:attention}Seals{} to {C:attention}Aces{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 27 },
    soul_pos = { x = 10, y = 28 },
    rarity = 4,
	cost = 20,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Ace", category = "military" },
        extra = { retrigger = 1, money = 3 } --Variables: retrigger = retrigger amount (red), money = dollars (gold)

    },

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
    end,
    calculate = function(self, card, context)
        if context.repetition and (context.cardarea == G.play or context.cardarea == G.hand) and context.other_card:get_id() == 14 and not context.blueprint then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
        if context.individual and context.other_card:get_id() == 14 and not context.blueprint then
            if context.cardarea == G.play then
                return {
                    p_dollars = card.ability.extra.money
                }
            end
        end
        if context.discard and context.other_card:get_id() == 14 and not context.other_card.debuff and not context.blueprint then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
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
                    end)
                }))
                card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            end
        end
        if context.end_of_round and context.cardarea == G.hand and context.other_card:get_id() == 14 and not context.other_card.debuff and not context.blueprint then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        if G.GAME.last_hand_played then
                            local _planet = 0
                            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                                if v.config.hand_type == G.GAME.last_hand_played then
                                    _planet = v.key
                                end
                            end
                            local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        end
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_planet'),
                    colour = G.C.SECONDARY_SET.Planet
                }
            end
        end
    end
}

SMODS.Joker { --Magus Perfectus
    key = 'magus_perfectus',
    name = 'Magus Perfectus',
	loc_txt = {
        name = 'Magus Perfectus',
        text = {
            'When round begins,',
            'add a random {C:enhanced}Enhancement{},',
            '{C:dark_edition}Edition{}, and a {C:attention}Seal{} to a',
            'random card in hand',
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 29 },
    soul_pos = { x = 0, y = 30 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local eligible_cards = {}
                    for k, v in ipairs(G.hand.cards) do
                        if not v.debuff then
                            table.insert(eligible_cards, v)
                        end
                    end
                    local card = pseudorandom_element(eligible_cards, 'magus_perfectus') or G.hand.cards[1]
                    local enhancement_pool = G.P_CENTER_POOLS['Enhanced']
                    local enhancement = pseudorandom_element(enhancement_pool, 'magus_perfectus')
                    local edition = poll_edition('magus_perfectus', nil, true, true)
                    local seal = SMODS.poll_seal({type_key = 'magus_perfectus', guaranteed = true})
                    local flip = card.facing == 'back'
                    if flip then
                        card:flip()
                    end
                    card:set_ability(enhancement, nil, true)
                    card:set_edition(edition, true)
                    card:set_seal(seal, nil, true)
                    if flip then
                        card:flip()
                    end
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Mega Massive Munitions Factory
    key = 'mega_massive_munitions_factory',
    name = 'Mega Massive Munitions Factory',
	loc_txt = {
        name = 'Mega Massive Munitions Factory',
        text = {
            'Creates a {C:attention}Mine{} every {C:attention}#1#{C:inactive}#2#{} hands',
            'Spend mines to give {X:mult,C:white}X#3#{} Mult until',
            'chips scored exceeds required',
            'chips on {C:attention}final hand{} of round',
            '{C:inactive}(Currently {C:attention}#4#{C:inactive} mines){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 29 },
    soul_pos = { x = 9, y = 30 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { limit = 3, counter = 3, Xmult = 2, mines = 0 } --Variables: limit = hands required for mine, counter = current hands, Xmult = Xmult per mine, mines = mines stored
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap then
				return ''
			end
			return ' [' .. count .. ']'
		end
		return {
			vars = {
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
                card.ability.extra.Xmult,
                card.ability.extra.mines
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
                card.ability.extra.mines = card.ability.extra.mines + 1
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1 Mine', colour = G.C.RED})
            end
        elseif context.final_scoring_step and G.GAME.current_round.hands_left == 0 and not context.blueprint then
            while card.ability.extra.mines > 0 and
                    ((G.GAME.selected_back.name ~= 'Plasma Deck' and (G.GAME.chips + hand_chips*mult)/G.GAME.blind.chips < to_big(1)) or
                    (G.GAME.selected_back.name == 'Plasma Deck' and (G.GAME.chips + ((hand_chips+mult)/2)^2)/G.GAME.blind.chips < to_big(1))) do
                mult = mod_mult(mult * card.ability.extra.Xmult)
                update_hand_text( { delay = 0 }, { mult = mult } )
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('multhit2')
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize{
                        type = 'variable',
                        key = 'a_xmult',
                        vars = {card.ability.extra.Xmult}
                    }
                })
                card.ability.extra.mines = card.ability.extra.mines - 1
            end
        end
    end
}

SMODS.Joker { --Vengeful True Sun God
    key = 'vengeful_true_sun_god',
    name = 'Vengeful True Sun God',
	loc_txt = {
        name = 'Vengeful True Sun God',
        text = {
            'Sacrifice {C:attention}ALL{} other {C:attention}Jokers{}',
            'to the {C:legendary,E:1,s:1.1}Vengeful True Sun God{}',
            '{C:inactive}(#1# #2# #3# #4#){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 29 },
    soul_pos = { x = 15, y = 30 },
    rarity = 4,
	cost = 20,
	blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { sacrifices = {}, chips = 20, mult = 5, Xmult = 0.25, retrigger = 1, consumable = 1, money = 3, discount = 1 } --Variables: chips = +chips, mult = +mult, Xmult = Xmult, consumables = consumable amount, discount = discount amount, Xmult support = other joker Xmult
    },

    loc_vars = function(self, info_queue, card)
		return {
            vars = {
                card.ability.extra.sacrifices['primary'] or 0,
                card.ability.extra.sacrifices['military'] or 0,
                card.ability.extra.sacrifices['magic'] or 0,
                card.ability.extra.sacrifices['support'] or 0,
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.sacrifices['primary'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['primary']) or 0
        card.ability.extra.sacrifices['military'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['military']) or 0
        card.ability.extra.sacrifices['magic'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['magic']) or 0
        card.ability.extra.sacrifices['support'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['support']) or 0
    end,
    sac_to_vtsg = function(card)
        local deletable_jokers = {}
        for _, joker in pairs(G.jokers.cards) do
            if joker ~= card and joker.ability.tower_info and joker.ability.tower_info.base and joker.ability.tower_info.category then
                if joker.ability.tower_info.base ~= "Sentry" and joker.ability.tower_info.base ~= "Marine" and joker.ability.tower_info.category ~= "misc" then
                    local category = joker.ability.tower_info.category
                    if category and card.ability.extra.sacrifices[category] then
                        card.ability.extra.sacrifices[category] = math.min(card.ability.extra.sacrifices[category] + joker.base_cost, 9)
                    end
                    deletable_jokers[#deletable_jokers + 1] = joker
                end
            end
        end
        local _first_dissolve = nil
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.75,
            func = function()
                for k, v in pairs(deletable_jokers) do
                    v:start_dissolve(nil, _first_dissolve)
                end
                return true
            end
        }))
        recalc_all_costs()
    end,
    remove_from_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local chips = math.floor(card.ability.extra.sacrifices['primary'] / 2) + math.floor(card.ability.extra.sacrifices['military'] / 2)
            local mult = math.ceil(card.ability.extra.sacrifices['primary'] / 2) + math.floor(card.ability.extra.sacrifices['magic'] / 2)
            local Xmult = math.floor(card.ability.extra.sacrifices['primary'] * 2 / 9) + math.ceil(card.ability.extra.sacrifices['military'] / 2) + math.ceil(card.ability.extra.sacrifices['magic'] / 2) + math.floor(card.ability.extra.sacrifices['support'] / 3)
            return {
                chips = card.ability.extra.chips * chips,
                mult = card.ability.extra.mult * mult,
                x_mult = 1 + card.ability.extra.Xmult * Xmult
            }
        elseif context.repetition and context.cardarea == G.play then
            local retrigger = math.floor(card.ability.extra.sacrifices['military'] * 2 / 9)
            if retrigger >= 1 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger * retrigger,
                }
            end
        elseif context.ending_shop then
            local count = math.floor(card.ability.extra.sacrifices['magic'] * 2 / 9)
            for i = 1, count do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card = create_card('Consumeables',G.consumeables, nil, nil, nil, nil, nil, 'vengeful_true_sun_god')
                        card:set_edition({negative = true}, true)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        return true
                    end
                }))
            end
            if count > 0 then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'..card.ability.extra.consumable*count, colour = G.C.DARK_EDITION})
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        local money = math.ceil(card.ability.extra.sacrifices['support'] / 3)
        if money > 0 then
            return card.ability.extra.money * money
        end
    end
}
