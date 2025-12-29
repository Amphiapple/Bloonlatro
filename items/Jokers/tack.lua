SMODS.Joker { --Tack Shooter
    key = 'tack',
    name = 'Tack Shooter',
	loc_txt = {
        name = 'Tack Shooter',
        text = {
            'Each played {C:attention}8{}',
            'gives {C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 3 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { chips = 24, mult = 4 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Faster Shooting
    key = 'fasttack',
    name = 'Faster Shooting',
	loc_txt = {
        name = 'Faster Shooting',
        text = {
            'Each played {C:attention}8{}',
            'gives {C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 3 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { chips = 48, mult = 2 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Even Faster Shooting
    key = 'eventack',
    name = 'Even Faster Shooting',
	loc_txt = {
        name = 'Faster Shooting',
        text = {
            'Each played {C:attention}8{}',
            'gives {X:mult,C:white}X#1#{} Mult',
            'when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 3 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { Xmult = 1.3 } --Variables: Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 then
            return {
                x_mult = card.ability.extra.Xmult,
            }
        end
    end
}

SMODS.Joker { --Hot Shots
    key = 'hotshots',
    name = 'Hot Shots',
	loc_txt = {
        name = 'Hot Shots',
        text = {
            'If {C:attention}first hand{}',
            'of round is a single',
            '{C:attention}8{}, transform it into',
            'a {C:attention}Meteor{} card',
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 3 },
    rarity = 2,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'tack',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_meteor
    end,
    calculate = function(self, card, context)
        if context.after and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.full_hand[1].debuff and not context.blueprint then
            context.full_hand[1]:set_ability('m_bloons_meteor', nil, true)
        end
    end
}

SMODS.Joker { --Ring of Fire
    key = 'rof',
    name = 'Ring of Fire',
	loc_txt = {
        name = 'Ring of Fire',
        text = {
            '{C:attention}Meteor{} cards may',
            'appear in the shop',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 3 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    config = {
        base = 'tack',
        extra = { rate = 4 } --Variables: rate = meteor card rate
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_meteor
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.playing_card_rate = G.GAME.playing_card_rate + card.ability.extra.rate
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.playing_card_rate = G.GAME.playing_card_rate - card.ability.extra.rate
                return true
            end
        }))
    end
}

SMODS.Joker { --Inferno Ring
    key = 'iring',
    name = 'Inferno Ring',
	loc_txt = {
        name = 'Inferno Ring',
        text = {
            "Adds one {C:attention}Meteor{} card",
            "to deck when",
            "{C:attention}Blind{} is selected",
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 3 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'tack',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_meteor
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('iring'))
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_bloons_meteor, {playing_card = G.playing_card})
                    card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                    G.play:emplace(card)
                    table.insert(G.playing_cards, card)
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1 Meteor', colour = G.C.SECONDARY_SET.Enhanced})

            G.E_MANAGER:add_event(Event({
                func = function() 
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    return true
                end
            }))
            draw_card(G.play,G.deck, 90,'up', nil)
            playing_card_joker_effects({true})
        end
    end
}

SMODS.Joker { --Long Range Tacks
    key = 'rangetack',
    name = 'Long Range Tacks',
	loc_txt = {
        name = 'Long Range Tacks',
        text = {
            'This {C:attention}Joker{} gains',
            '{C:mult}+#1#{} Mult if scoring hand',
            'contains an {C:attention}8{}',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 3 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'tack',
        extra = { mult = 1, current = 0 } --Variables: mult = +mult gain if scoring hand contains 8, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local has_789 = false
            for k, v in ipairs(context.scoring_hand) do
                if v:get_id() == 8 and not v.debuff then
                    has_789 = true
                    break
                end
            end
            if has_789 then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Super Range Tacks
    key = 'supertack',
    name = 'Super Range Tacks',
	loc_txt = {
        name = 'Super Range Tacks',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{}',
            'Mult if scoring hand',
            'contains a {C:attention}7{}, {C:attention}8{}, or {C:attention}9{}',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 3 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'tack',
        extra = { mult = 1, current = 0 } --Variables: mult = +mult gain if scoring hand contains 7, 8, 9, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local has_789 = false
            for k, v in ipairs(context.scoring_hand) do
                if (v:get_id() == 7 or v:get_id() == 8 or v:get_id() == 9) and not v.debuff then
                    has_789 = true
                    break
                end
            end
            if has_789 then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Blade Shooter
    key = 'blade',
    name = 'Blade Shooter',
	loc_txt = {
        name = 'Blade Shooter',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{} Mult',
            'if scoring hand contains',
            'at least {C:attention}#2# number{} cards',
            '{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 3 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'tack',
        extra = { mult = 2, number = 3, current = 0 } --Variables: mult = +mult gain if scoring hand contains 3 numbers, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.number, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local count = 0
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:get_id() >= 0 and
                        (v:get_id() <= 10 or
                        v:get_id() == 14) and
                        not v.debuff then
                        count = count + 1
                    end
                end
            end
            if count >= card.ability.extra.number then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Blade Maelstrom
    key = 'mael',
    name = 'Blade Maelstrom',
	loc_txt = {
        name = 'Blade Maelstrom',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played {C:attention}number{} cards to give',
            '{X:mult,C:white}X#3#{} Mult when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 3 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { num = 1, denom = 2, Xmult = 1.5 } --Variables: num/denom = probability fraction, Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
		local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mael')
        return { vars = { n, d, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:get_id() >= 0 and (context.other_card:get_id() <= 10 or context.other_card:get_id() == 14) and
            SMODS.pseudorandom_probability(card, 'mael', card.ability.extra.num, card.ability.extra.denom, 'mael') then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Super Maelstrom
    key = 'smael',
    name = 'Super Maelstrom',
	loc_txt = {
        name = 'Super Maelstrom',
        text = {
            '{X:mult,C:white}X#1#{} Mult after',
            'scoring every card rank',
            '{C:inactive}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 3 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { Xmult = 2, ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'} } --Variables: mult = +mult gain if scoring hand contains 3 numbers, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(ranks)
			if next(ranks) == nil then
				return 'Active!'
			end
            local rank_string = ''
            for k, v in ipairs(ranks) do
                rank_string = rank_string .. ' ' .. v
            end
			return '(Remaining:' .. rank_string .. ')'
		end
		return {
			vars = {
				card.ability.extra.Xmult,
                process_var(card.ability.extra.ranks)
			},
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local rank = context.other_card:get_id()
            if rank < 10 then rank = tostring(rank)
            elseif rank == 10 then rank = 'T'
            elseif rank == 11 then rank = 'J'
            elseif rank == 12 then rank = 'Q'
            elseif rank == 13 then rank = 'K'
            elseif rank == 14 then rank = 'A'
            end
            for k, v in ipairs(card.ability.extra.ranks) do
                if v == rank then
                    table.remove(card.ability.extra.ranks, k)
                end
            end   
        elseif context.joker_main and next(card.ability.extra.ranks) == nil then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --More Tacks
    key = 'moretacks',
    name = 'More Tacks',
	loc_txt = {
        name = 'More Tacks',
        text = {
            'Each played {C:attention}10{}',
            'gives {C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 3 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { chips = 25, mult = 5 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 10 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Even More Tacks
    key = 'evenmore',
    name = 'Even More Tacks',
	loc_txt = {
        name = 'Even More Tacks',
        text = {
            'Each played {C:attention}Queen{}',
            'gives {C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 3 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { chips = 24, mult = 6 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 12 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Tack Sprayer
    key = 'sprayer',
    name = 'Tack Sprayer',
	loc_txt = {
        name = 'Tack Sprayer',
        text = {
            'Each played {C:attention}8{}, {C:attention}10{}, or',
            '{C:attention}Queen{} gives {C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 3 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { chips = 40, mult = 8 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 12 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Overdrive
    key = 'od',
    name = 'Overdrive',
    loc_txt = {
        name = 'Overdrive',
        text = {
            'This Joker gains',
            '{X:mult,C:white}X#1#{} Mult for every {C:attention}8{}',
            'played this round',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 3 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { Xmult = 0.5, current = 1 } --Variables: Xmult = Xmult gain for each 8, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v:get_id() == 8 and not v.debuff then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                end
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        elseif context.end_of_round and card.ability.extra.current > 1 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --The Tack Zone
    key = 'tz',
    name = 'The Tack Zone',
    loc_txt = {
        name = 'The Tack Zone',
        text = {
            '{X:mult,C:white}X#1#{} Mult if the',
            'ranks of all played',
            'cards sum to {C:attention}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 3 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { Xmult = 4, sum = 32 } --Variables: Xmult = Xmult if target is hit, sum = target sum
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.sum } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local sum = 0
            for k, v in ipairs(context.full_hand) do
                if not SMODS.has_no_rank(v) then
                    sum = sum + v.base.nominal
                end
            end
            if sum == 32 then
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}
