SMODS.Joker { --MOAB Domination
    key = 'mdom',
    name = 'MOAB Domination',
	loc_txt = {
        name = 'MOAB Domination',
        text = {
            'Play each {C:attention}Boss Blind{} twice,',
            'This Joker gains {X:mult,C:white}X#1#{} Mult',
            'when {C:attention}Boss Blind{} is defeated',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive}){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 14 },
    soul_pos = { x = 5, y = 15 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { Xmult = 1, current = 1, active = true } --Variables = Xmult = Xmult per boss defeated the second time, current = current Xmult, active = if next boss will be repeated
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

SMODS.Joker { --Flying Fortress
    key = 'fortress',
    name = 'Flying Fortress',
	loc_txt = {
        name = 'Flying Fortress',
        text = {
            'Apply the effects',
            'of all {C:attention}Seals{} to {C:attention}Aces{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 14 },
    soul_pos = { x = 6, y = 15 },
    rarity = 4,
	cost = 20,
    blueprint_compat = false,
    config = {
        base = 'ace',
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
        if context.discard and context.other_card:get_id() == 14 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not context.blueprint then
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

SMODS.Joker { --Permanent Brew
    key = 'pbrew',
    name = 'Permanent Brew',
	loc_txt = {
        name = 'Permanent Brew',
        text = {
            'Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or',
            '{C:dark_edition}Polychrome{} to all scoring cards',
            'Cards with {C:dark_edition}Foil{} or {C:dark_edition}Holographic{}',
            'always become {C:dark_edition}Polychrome{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 14 },
    soul_pos = { x = 7, y = 15 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        base = 'alch',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
    end,
    calculate = function(self, card, context)
        if context.before then
            for k, v in pairs(context.scoring_hand) do
                if not v.edition then
                    local edition = poll_edition('pbrew', nil, true, true)
                    v:set_edition(edition, true)
                elseif v.edition.foil or v.edition.holo then
                    v:set_edition('e_polychrome', true)
                end
            end
            return {
                message = 'Brewed!',
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Super Mines
    key = 'smines',
    name = 'Super Mines',
	loc_txt = {
        name = 'Super Mines',
        text = {
            'Creates a {C:attention}Mine{} every {C:attention}#1#{C:inactive}#2#{} hands',
            'Spend mines to give {X:mult,C:white}X#3#{} Mult until',
            'chips scored exceeds required',
            'chips on {C:attention}final hand{} of round',
            '{C:inactive}(Currently {C:attention}#4#{C:inactive} mines){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 14 },
    soul_pos = { x = 8, y = 15 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        base = 'spac',
        extra = { limit = 3, counter = 3, Xmult = 3, mines = 0 } --Variables: limit = hands required for mine, counter = current hands, Xmult = Xmult per mine, mines = mines stored
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
            while (G.GAME.chips + hand_chips*mult)/G.GAME.blind.chips < to_big(1) and card.ability.extra.mines > 0 do
                mult = mod_mult(mult * card.ability.extra.Xmult)
                update_hand_text( { delay = 0 }, { mult = mult } )
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('multhit2')
                        delay(0.5)
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
    key = 'vtsg',
    name = 'Vengeful True Sun God',
	loc_txt = {
        name = 'Vengeful True Sun God',
        text = {
            'Sacrifice {C:attention}ALL{} other {C:attention}Jokers{}',
            'to the {C:legendary,E:1,S:1.1}Vengeful True Sun God{}',
            '{C:inactive}[#1# #2# #3# #4# #5# #6#]{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 14 },
    soul_pos = { x = 9, y = 15 },
    rarity = 4,
	cost = 20,
	blueprint_compat = true,
    config = {
        base = 'super',
        extra = { sacrifices = {}, chips = 200, mult = 40, Xmult = 2, consumable = 1, discount = 2, Xmult_support = 0.2 } --Variables: chips = +chips, mult = +mult, Xmult = Xmult, consumables = consumable amount, discount = discount amount, Xmult support = other joker Xmult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.sacrifices['+chips'] or 0,
            card.ability.extra.sacrifices['+mult'] or 0,
            card.ability.extra.sacrifices['Xmult'] or 0,
            card.ability.extra.sacrifices['econ'] or 0,
            card.ability.extra.sacrifices['value'] or 0,
            card.ability.extra.sacrifices['support'] or 0
        } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.sacrifices['+chips']  = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['+chips'])  or 0
        card.ability.extra.sacrifices['+mult']   = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['+mult'])   or 0
        card.ability.extra.sacrifices['Xmult']   = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['Xmult'])   or 0
        card.ability.extra.sacrifices['econ']    = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['econ'])    or 0
        card.ability.extra.sacrifices['value']   = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['value'])   or 0
        card.ability.extra.sacrifices['support'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['support']) or 0
    end,
    sac_to_vtsg = function(card)
        local deletable_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v ~= card then
                local category = v:get_effects_vtsg()
                local weight = v:get_effect_weight_vtsg()
                for i, j in pairs(category) do
                    card.ability.extra.sacrifices[j] = card.ability.extra.sacrifices[j] + weight
                end
                deletable_jokers[#deletable_jokers + 1] = v
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
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips * card.ability.extra.sacrifices['+chips'],
                mult = card.ability.extra.mult * card.ability.extra.sacrifices['+mult'],
                x_mult = 1 + card.ability.extra.Xmult * card.ability.extra.sacrifices['Xmult'],
            }
        elseif context.other_joker and context.other_joker ~= card and card.ability.extra.sacrifices['support'] > 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                x_mult = 1 + card.ability.extra.Xmult_support * card.ability.extra.sacrifices['support']
            }
        elseif context.ending_shop and card.ability.extra.sacrifices['value'] >= 1 then
            for i = 1, card.ability.extra.consumable * card.ability.extra.sacrifices['value'] do
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = create_card('Consumeables',G.consumeables, nil, nil, nil, nil, nil, 'vtsg')
                        card:set_edition({negative = true}, true)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        return true
                    end
                }))
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'..card.ability.extra.consumable*card.ability.extra.sacrifices['value'], colour = G.C.DARK_EDITION})
        end
    end
}