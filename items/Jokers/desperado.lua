SMODS.Joker { --Desperado
    key = 'desp',
    name = 'Desperado',
    loc_txt = {
        name = 'Desperado',
        text = {
            '{C:attention}First #1#{} played',
            'cards give {C:chips}+#2#{}',
            'Chips when scored'
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 2 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { number = 2, chips = 20 } --Variables: number = number of cards, chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            for i = 1, card.ability.extra.number do
                if context.other_card == context.scoring_hand[i] then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED
                        }
                    else
                        return {
                            chips = card.ability.extra.chips
                        }
                    end
                end
            end
		end
    end
}

SMODS.Joker { --Nomad
    key = 'nomad',
    name = 'Nomad',
	loc_txt = {
        name = 'Nomad',
        text = {
            'This {C:attention}Joker{} gains {C:chips}+#1#{} Chips ',
            'if {C:attention}poker hand{} is different from',
            'the previous {C:attention}poker hand {C:inactive}#3#{}',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 5 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'desperado',
        extra = { chips = 4, current = 0, poker_hand = '' } --Variables: chips = +chips gain, current = current +chips, poker_hand = previous poker hand
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.current, card.ability.extra.poker_hand } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if '[' .. context.scoring_name .. ']' ~= card.ability.extra.poker_hand then
                card.ability.extra.poker_hand = '[' .. context.scoring_name .. ']'
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}}
                }
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Enforcer
    key = 'enforcer',
    name = 'Enforcer',
	loc_txt = {
        name = 'Enforcer',
        text = {
            'This Joker gains',
            '{X:mult,C:white}X#1#{} Mult when each',
            'played {C:attention}Stone Card{} is scored',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 8 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_stone',
    config = {
        base = 'desperado',
        extra = { Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult gain for each stone, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.end_of_round and not context.blueprint then
            if context.other_card.ability.name == 'Stone Card' then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Twin Sixes
    key = 'twix',
    name = 'Twin Sixes',
	loc_txt = {
        name = 'Twin Sixes',
        text = {
            '{X:mult,C:white}X#1#{} Mult if',
            'scoring hand contains',
            'at least {C:attention}#2# 6{}s'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 11 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { Xmult = 3, number = 2 } --Variables: Xmult = Xmult, number = required 6s for Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:get_id() == 6 and not v.debuff then
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

SMODS.Joker { --Golden Justice
    key = 'gustice',
    name = 'Golden Justice',
	loc_txt = {
        name = 'Golden Justice',
        text = {
            '{C:attention}Gold{} cards give {X:mult,C:white}X#1#{} Mult and',
            '{C:green}#2# in #3#{} chance to be destroyed',
            '{C:attention}Glass{} cards give {C:money}$#4#{} if',
            'held in hand at end of round',
            'Both give {C:money}$#5#{} when destroyed',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 14 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        base = 'desperado',
        extra = { Xmult = 2, num = 1, denom = 4, gold_money = 3, destroy_money = 15 } --Variables = Xmult = glass Xmult, num/denom = probability fraction, gold_money = gold dollars, destroy money = dollars when destroyed
    },

    in_pool = function(self, args)
        for k, v in pairs(G.playing_cards) do
            if v.ability.name == 'Gold Card' or v.ability.name == 'Glass Card' then
                return true
            end
        end
        return false
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'gustice')
        return { vars = { card.ability.extra.Xmult, n, d, card.ability.extra.gold_money, card.ability.extra.destroy_money } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Gold Card' and not context.other_card.debuff and not context.blueprint then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.destroying_card and context.destroying_card.ability.name == 'Gold Card' and not context.destroying_card.debuff and SMODS.pseudorandom_probability(card, 'gustice', card.ability.extra.num, card.ability.extra.denom, 'gustice') and not context.blueprint then
            local other_card = context.destroying_card
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    other_card:shatter()
                    return true
                end
            }))
            return true
        elseif context.end_of_round and context.individual and context.cardarea == G.hand and context.other_card.ability.name == 'Glass Card' and not context.other_card.debuff and not context.blueprint then
            ease_dollars(card.ability.extra.gold_money)
            card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.gold_money,colour = G.C.MONEY, delay = 0.45})
            delay(0.3)
        elseif context.cards_destroyed and not context.blueprint then
            local glass = 0
            for k, v in ipairs(context.glass_shattered) do
                if v.ability.name == 'Glass Card' or v.ability.name == 'Gold Card' then
                    glass = glass + 1
                end
            end
            if glass > 0 then
                ease_dollars(card.ability.extra.destroy_money*glass)
                card_eval_status_text(create_dynatext_pips, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.destroy_money*glass,colour = G.C.MONEY, delay = 0.45})
            end
        elseif context.remove_playing_cards and not context.blueprint then
            local glass = 0
            for k, v in ipairs(context.removed) do
                if v.ability.name == 'Glass Card' or v.ability.name == 'Gold Card' then
                    glass = glass + 1
                end
            end
            if glass > 0 then
                ease_dollars(card.ability.extra.destroy_money*glass)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.destroy_money*glass,colour = G.C.MONEY, delay = 0.45})
            end
        end
    end
}