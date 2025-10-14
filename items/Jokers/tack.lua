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
	pos = { x = 3, y = 0 },
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
	pos = { x = 3, y = 3 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'tack',
        extra = { chips = 20, mult = 5 } --Variables: chips = +chips, mult = +mult
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
	pos = { x = 7, y = 2 },
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

SMODS.Joker { --Blade Shooter
    key = 'blade',
    name = 'Blade Shooter',
	loc_txt = {
        name = 'Blade Shooter',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{} ',
            'Mult if scoring hand',
            'contains a {C:attention}7{}, {C:attention}8{}, or {C:attention}9{}',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 6 },
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
                if v:get_id() == 7 or v:get_id() == 8 or v:get_id() == 9 then
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
	pos = { x = 3, y = 9 },
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
                if v:get_id() == 8 then
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
	pos = { x = 3, y = 12 },
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