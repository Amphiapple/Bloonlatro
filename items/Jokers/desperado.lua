SMODS.Joker { --Desperado
    key = 'desperado',
    name = 'Desperado',
    loc_txt = {
        name = 'Desperado',
        text = {
            '{C:attention}First #1#{} played',
            'cards give {C:mult}+#2#{}',
            'Mult when scored'
        }
    },
    atlas = 'Joker',
	pos = { x = 0, y = 6 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { number = 2, mult = 3 } --Variables: number = number of cards, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[2]) then
            return {
                mult = card.ability.extra.mult
            }
		end
    end
}

SMODS.Joker { --Quickdraw
    key = 'quickdraw',
    name = 'Quickdraw',
    loc_txt = {
        name = 'Quickdraw',
        text = {
            '{C:attention}First #1#{} played cards',
            'give {C:mult}+#2#{} Mult for',
            'each unscoring card'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 6 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { number = 2, mult = 3 } --Variables: number = number of cards, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[2]) then
            local temp_mult = card.ability.extra.mult * (#context.full_hand - #context.scoring_hand)
            if temp_mult > 0 then
                return {
                    mult = temp_mult
                }
            end
		end
    end
}

SMODS.Joker { --Standoff
    key = 'standoff',
    name = 'Standoff',
    loc_txt = {
        name = 'Standoff',
        text = {
            '{C:attention}First #1#{} played cards',
            'give {C:mult}+#2#{} Mult for',
            'each card under',
            '{C:attention}5{} played cards',
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 6 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { number = 2, mult = 4 } --Variables: number = number of cards, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[2]) then
            local temp_mult = card.ability.extra.mult * (5 - #context.full_hand)
            if temp_mult > 0 then
                return {
                    mult = temp_mult
                }
            end
		end
    end
}

SMODS.Joker { --Big Iron
    key = 'big_iron',
    name = 'Big Iron',
	loc_txt = {
        name = 'Big Iron',
        text = {
            '{C:mult}+#1#{} Mult if',
            'scoring hand',
            'contains a {C:attention}6{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 6 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { mult = 20 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(context.scoring_hand) do
                if v:get_id() == 6 and not v.debuff then
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Twin Sixes
    key = 'twin_sixes',
    name = 'Twin Sixes',
	loc_txt = {
        name = 'Twin Sixes',
        text = {
            '{X:mult,C:white}X#1#{} Mult if',
            'scoring hand contains',
            'at least {C:attention}#2# 6{}s',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 6 },
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

SMODS.Joker { --The Blazing Sun
    key = 'the_blazing_sun',
    name = 'The Blazing Sun',
	loc_txt = {
        name = 'The Blazing Sun',
        text = {
            'Each played {C:attention}#2#{}',
            'of {C:hearts}Hearts{} gives',
            '{X:mult,C:white}X#1#{} Mult when scored,',
            'rank changes every round',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 6 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { Xmult = 2 } --Variables: Xmult = Xmult, number = required 6s for Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, localize(G.GAME.current_round.desperado_card.rank, 'ranks') } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == G.GAME.current_round.desperado_card.id and context.other_card:is_suit('Hearts') then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Eagle Eye
    key = 'eagle_eye',
    name = 'Eagle Eye',
    loc_txt = {
        name = 'Eagle Eye',
        text = {
            '{C:attention}First #1#{} played cards',
            'give {C:mult}+#2#{} Mult when scored,',
            '{C:mult}+#3#{} if rank is {C:attention}#4#{}',
            'rank changes every round',
        }
    },
    atlas = 'Joker',
	pos = { x = 6, y = 6 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { number = 2, mult = 3, mark_mult = 6 } --Variables: number = number of cards, mult = +mult, mark_mult = mult for marked card
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, card.ability.extra.mult, card.ability.extra.mark_mult, localize(G.GAME.current_round.desperado_card.rank, 'ranks') } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[2]) then
            if context.other_card:get_id() == G.GAME.current_round.desperado_card.id then
                return {
                    mult = card.ability.extra.mark_mult
                }
            else
                return {
                    mult = card.ability.extra.mult
                }
            end
		end
    end
}

SMODS.Joker { --Bullseye
    key = 'bullseye',
    name = 'Bullseye',
    loc_txt = {
        name = 'Bullseye',
        text = {
            '{C:attention}First #1#{} played cards',
            'give {C:mult}+#2#{} Mult when scored,',
            '{C:mult}+#3#{} if rank is {C:attention}#4#{}',
            'rank changes every round',
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 6 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { number = 2, mult = 3, mark_mult = 12 } --Variables: number = number of cards, mult = +mult, mark_mult = mult for marked card
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, card.ability.extra.mult, card.ability.extra.mark_mult, localize(G.GAME.current_round.desperado_card.rank, 'ranks') } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[2]) then
            if context.other_card:get_id() == G.GAME.current_round.desperado_card.id then
                return {
                    mult = card.ability.extra.mark_mult
                }
            else
                return {
                    mult = card.ability.extra.mult
                }
            end
		end
    end
}

SMODS.Joker { --Deadeye
    key = 'deadeye',
    name = 'Deadeye',
    loc_txt = {
        name = 'Deadeye',
        text = {
            'Played {C:attention}#1#s{} give',
            '{X:mult,C:white}X#2#{} Mult when scored,',
            'rank changes every round',
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 6 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { Xmult = 1.5 } --Variables: number = number of cards, mult = +mult, mark_mult = mult for marked card
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { localize(G.GAME.current_round.desperado_card.rank, 'ranks'), card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == G.GAME.current_round.desperado_card.id then
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
		end
    end
}

SMODS.Joker { --Bounty Hunter
    key = 'bounty_hunter',
    name = 'Bounty Hunter',
    loc_txt = {
        name = 'Bounty Hunter',
        text = {
            'Played {C:attention}#1#s{} give',
            '{C:money}$#2#{} when scored,',
            'rank changes every round',
        }
    },
    atlas = 'Joker',
	pos = { x = 9, y = 6 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { money = 3 } --Variables: number = number of cards, mult = +mult, mark_mult = mult for marked card
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { localize(G.GAME.current_round.desperado_card.rank, 'ranks'), card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == G.GAME.current_round.desperado_card.id then
                return {
                    dollars = card.ability.extra.money
                }
            end
		end
    end
}

SMODS.Joker { --Golden Justice
    key = 'golden_justice',
    name = 'Golden Justice',
	loc_txt = {
        name = 'Golden Justice',
        text = {
            '{C:attention}Gold Cards{} and {C:attention}Glass Cards{}',
            "inherit each others' abilities,",
            'both give {C:money}$#5#{} when destroyed',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 6 },
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
        elseif context.destroying_card and not context.blueprint then
            if context.destroying_card.ability.name == 'Gold Card' and not context.destroying_card.debuff and SMODS.pseudorandom_probability(card, 'gustice', card.ability.extra.num, card.ability.extra.denom, 'gustice') then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        context.destroying_card:shatter()
                        return true
                    end
                }))
                return true
            end
            return nil
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

SMODS.Joker { --Wanderer
    key = 'wanderer',
    name = 'Wanderer',
	loc_txt = {
        name = 'Wanderer',
        text = {
            '{C:chips}+#1#{} Chips for each',
            'empty {C:attention}Joker{} slot',
            '{s:0.8}Wanderer included',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
    atlas = 'Joker',
	pos = { x = 11, y = 6 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { chips = 30, current = 0 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = card.ability.extra.chips * (G.jokers.config.card_limit - #G.jokers.cards)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'Wanderer' then card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips end
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.current
            }
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
	pos = { x = 12, y = 6 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'desperado',
        extra = { chips = 4, current = 0, poker_hand = '' } --Variables: chips = +chips gain, current = current +chips, poker_hand = previous poker hand
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(poker_hand)
            return poker_hand ~= '' and '[' .. poker_hand .. ']' or poker_hand
        end
		return { vars = { card.ability.extra.chips, card.ability.extra.current, process_var(card.ability.extra.poker_hand) } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.scoring_name ~= card.ability.extra.poker_hand then
                card.ability.extra.poker_hand = context.scoring_name
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
            'This Joker gains {X:mult,C:white}X#1#{}',
            'Mult if scoring hand',
            'contains {C:attention}#2#{} cards',
            '{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 6 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'desperado',
        extra = { Xmult = 0.1, number = 5, current = 1 } --Variables: Xmult = Xmult gain, number = required scoring cards, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.number, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and #context.scoring_hand == card.ability.extra.number and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Avenger
    key = 'avenger',
    name = 'Avenger',
	loc_txt = {
        name = 'Avenger',
        text = {
            'This Joker gains {X:mult,C:white}X#1#{} Mult',
            'if scoring hand contains',
            'ranks in previous hand',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)',
            '{C:inactive}(#3#){}',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 6 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'desperado',
        extra = { Xmult = 0.1, current = 1, ranks = {} } --Variables: Xmult = Xmult gain, number = required scoring cards, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(ranks)
			if next(ranks) == nil then
				return 'None'
			end
            local rank_string = ' '
            for k, v in pairs(ranks) do
                rank_string = rank_string .. v .. ' '
            end
			return rank_string
		end
		return {
			vars = {
				card.ability.extra.Xmult,
                card.ability.extra.current,
                process_var(card.ability.extra.ranks)
			},
        }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                local id = v:get_id()
                if card.ability.extra.ranks[id] and not v.debuff then
                    card.ability.extra.ranks = {}
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
                        colour = G.C.MULT,
                        delay = 0.45,
                    }
                end
            end
            card.ability.extra.ranks = {}
        elseif context.individual and context.cardarea == G.play and not SMODS.has_no_rank(context.other_card) and not context.blueprint then
            local id = context.other_card:get_id()
            local rank = id
            if rank < 10 then rank = tostring(rank)
            elseif rank == 10 then rank = 'T'
            elseif rank == 11 then rank = 'J'
            elseif rank == 12 then rank = 'Q'
            elseif rank == 13 then rank = 'K'
            elseif rank == 14 then rank = 'A'
            end
            card.ability.extra.ranks[id] = rank
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --The Desert Phantom
    key = 'the_desert_phantom',
    name = 'The Desert Phantom',
	loc_txt = {
        name = 'The Desert Phantom',
        text = {
            '{C:spectral}Spectral{} cards may',
            'appear in the shop,',
            '{X:mult,C:white}X#1#{} Mult for each',
            '{C:spectral}Spectral{} card used',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)',
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 6 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'desperado',
        extra = { spectral_rate = 2, Xmult = 0.25, current = 1 } --Variables: Xmult = Xmult gain, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.spectral_rate = G.GAME.spectral_rate + 2
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.spectral_rate = G.GAME.spectral_rate - 2
    end,
    update = function(self, card, dt)
        local count = G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral or 0
        card.ability.extra.current = 1 + card.ability.extra.Xmult * count
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Spectral" then
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.joker_main and card.ability.extra.current > 1 then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}