SMODS.Joker { --Bomb Shooter
    key = 'bomb',
    name = 'Bomb Shooter',
	loc_txt = {
        name = 'Bomb Shooter',
        text = {
            '{C:gray}Steel{} cards give',
            '{X:mult,C:white}X#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_steel',
    config = {
        base = 'bomb',
        extra = { Xmult = 1.5 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        return { vars = { card.ability.extra.Xmult} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Steel Card' then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Missile Launcher
    key = 'missile',
    name = 'Missile Launcher',
    loc_txt = {
        name = 'Missile Launcher',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'earn {C:money}$#3#{} for each',
            'discarded {C:attention}4{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 2 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'bomb',
        extra = { num = 1, denom = 2, money = 5 } --Variables: num/denom = probability fraction, money = dollars
    },

    loc_vars = function(self, info_queue, card) 
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'missile')
        return { vars = { n, d, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card:get_id() == 4 and not context.other_card.debuff and
                SMODS.pseudorandom_probability(card, 'missile', card.ability.extra.num, card.ability.extra.denom, 'missile') then
            ease_dollars(card.ability.extra.money)
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('$')..(card.ability.extra.money),colour = G.C.MONEY, delay = 0.45})
        end
    end
}

SMODS.Joker { --Frag Bombs
    key = 'frags',
    name = 'Frag Bombs',
	loc_txt = {
        name = 'Frag Bombs',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'create a {C:planet}Planet{} card',
            'for each discarded {C:attention}4{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 3 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'bomb',
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'frags')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card:get_id() == 4 and not context.other_card.debuff and
                SMODS.pseudorandom_probability(card, 'frags', card.ability.extra.num, card.ability.extra.denom, 'frags') and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'frags')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
        end
    end
}

SMODS.Joker { --MOAB Mauler
    key = 'mauler',
    name = 'MOAB Mauler',
	loc_txt = {
        name = 'MOAB Mauler',
        text = {
            '{X:mult,C:white}X#1#{} Mult against',
            '{C:attention}Boss Blinds{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 6 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'bomb',
        extra = { Xmult = 2.5 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.blind.boss then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Bloon Impact
    key = 'blimpact',
    name = 'Bloon Impact',
    loc_txt = {
        name = 'Bloon Impact',
        text = {
            '{C:attention}Stun{} all cards in',
            '{C:attention}first discard{} of round',
            'Gain {C:mult}+#1#{} Mult when a',  
            '{C;attention}Stunned{} card wears off',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 9 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'bomb',
        extra = { mult = 1, current = 0 } --Variables: mult = +mult for each stunned, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.discard and not context.other_card.debuff then
            if context.other_card.ability.name == 'Stunned Card' then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
            elseif G.GAME.current_round.discards_used == 0 then
                context.other_card:set_ability('m_bloons_stunned', nil, true)
                return {
                    message = 'Stunned!',
                    colour = G.C.RED
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Bomb Blitz
    key = 'blitz',
    name = 'Bomb Blitz',
	loc_txt = {
        name = 'Bomb Blitz',
        text = {
            'Prevents Death if chips scored',
            'are at least {C:attention}#1#%{} of required chips',
            'and destroy all cards held in hand',
            '{S:1.1,C:red,E:2}self destructs{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 12 },
    rarity = 3,
	cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        base = 'bomb',
        extra = { scored_percent = 50 } --Variables: scored_percent = percent of required chips scored
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.scored_percent } }
    end,
    calculate = function(self, card, context)
        if context.game_over and G.GAME.chips/G.GAME.blind.chips >= to_big(card.ability.extra.scored_percent / 100.0) and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.saved_text = "Saved by Bomb Blitz!"
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve({G.C.RED}, nil)
                    return true
                end
            }))
            local destroyed_cards = {}
            for k, v in ipairs(G.hand.cards) do
                destroyed_cards[#destroyed_cards+1] = v
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    for i=#destroyed_cards, 1, -1 do
                        local card = destroyed_cards[i]
                        if card.ability.name == 'Glass Card' then 
                            card:shatter()
                        else
                            card:start_dissolve(nil, i == #destroyed_cards)
                        end
                    end
                    return true
                end
            }))
            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        end
    end
}