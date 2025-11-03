SMODS.Joker { --Engineer Monkey
    key = 'engi',
    name = 'Engineer Monkey',
	loc_txt = {
        name = 'Engineer Monkey',
        text = {
            'Earn {C:money}$#1#{} if {C:attention}poker hand{}',
            'contains a {C:attention}Straight{}',
            'or a {C:attention}Flush{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 23 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'engi',
        extra = { money = 3 } --Variables: money = dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
		if context.before and context.poker_hands then
            if next(context.poker_hands['Straight']) and next(context.poker_hands['Flush']) then
                return {
                    dollars = card.ability.extra.money * 2,
                    colour = G.C.MONEY
                }
            elseif next(context.poker_hands['Straight']) or next(context.poker_hands['Flush']) then
                return {
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            end
        end
	end
}

SMODS.Joker { --Sentry Gun
    key = 'sentries',
    name = 'Sentry Gun',
    loc_txt = {
        name = 'Sentry Gun',
        text = {
            'When {C:attention}Blind{} is selected,',
            'create a {C:attention}Nail Sentry{}',
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 23 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'engi',
        extra = { number = 2 } --Variables: number = required bonus cards for planet
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_sentry
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = create_card('j_bloons_sentry', G.jokers, nil, 0, nil, nil, 'j_bloons_sentry', 'sentries')
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:start_materialize()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
        end
    end
}

SMODS.Joker { --Double Gun
    key = 'doublegun',
    name = 'Double Gun',
	loc_txt = {
        name = 'Double Gun',
        text = {
            'Each {C:attention}Pair{}',
            'held in hand',
            'gives {C:money}$#1#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 23 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'engi',
        extra = { money = 1, pairs = {} } --Variables: money = money per held pair, pairs = held pairs
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local idx_by_id = {}
            for k, v in ipairs(G.hand.cards) do
                local id = v:get_id()
                if idx_by_id[id] then
                    card.ability.extra.pairs[#card.ability.extra.pairs+1] = v
                    idx_by_id[id] = nil
                else
                    idx_by_id[id] = k
                end
            end
        elseif context.individual and context.cardarea == G.hand and not context.other_card.debuff and not context.end_of_round then
            for k, v in pairs(card.ability.extra.pairs) do
                if context.other_card == v then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.GAME.dollar_buffer = 0;
                            return true
                        end)
                    }))
                    return {
                        dollars = card.ability.extra.money,
                    }
                end
            end
        elseif context.after then
            card.ability.extra.pairs = {}
        end
    end
}

SMODS.Joker { --Sentry Expert
    key = 'sexpert',
    name = 'Sentry Expert',
	loc_txt = {
        name = 'Sentry Expert',
        text = {
            'When {C:attention}Blind{} is selected,',
            'create a random {C:attention}Sentry{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 23 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'engi',
        extra = { sentries = { 'j_bloons_crushing_sentry', 'j_bloons_boom_sentry', 'j_bloons_cold_sentry', 'j_bloons_energy_sentry' } }
    },

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_crushing_sentry
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_boom_sentry
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_cold_sentry
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_energy_sentry
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.getting_sliced then
            local sentry = pseudorandom_element(card.ability.extra.sentries, pseudoseed('sexpert'))
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = create_card(sentry, G.jokers, nil, 0, nil, nil, sentry, 'sexpert')
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:start_materialize()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
        end
    end
}

SMODS.Joker { --Ultraboost
    key = 'uboost',
    name = 'Ultraboost',
	loc_txt = {
        name = 'Ultraboost',
        text = {
            'Played {C:attention}cards{}',
            'permanently gain {X:mult,C:white}X#1#{}',
            'Mult when scored',
            '{C:inactive}(Maximum of {X:mult,C:white}X#2#{C:inactive})'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 23 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        base = 'engi',
        extra = { Xmult = 0.1, Xmult_max = 1 } --Variables: Xmult = permanent Xmult on cards, Xmult_max = maximum Xmult,
    }, 

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_max + 1 } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1
            if context.other_card.ability.perma_x_mult + card.ability.extra.Xmult > card.ability.extra.Xmult_max then
                context.other_card.ability.perma_x_mult = card.ability.extra.Xmult_max
            else
                context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult + card.ability.extra.Xmult
            end
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.CMULT,
            }
        end
    end

}
