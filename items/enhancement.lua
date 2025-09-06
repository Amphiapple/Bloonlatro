SMODS.Atlas {
    key = 'Enhancement',
    path = 'enhancements.png',
    px = 71,
    py = 95,
}

SMODS.Enhancement ({ --Frozen
    key = 'frozen',
    name = 'Frozen Card',
    loc_txt = {
        name = 'Frozen Card',
        text = {
            '{C:chips}+#1#{} Chips and',
            'thaws when held in hand',
            'no rank or suit'
        }
    },
	atlas = "Enhancement",
	pos = { x = 0, y = 0 },
    order = 10,
    no_rank = true,
    no_suit = true,
    shatters = true,
    config = { h_chips = 40 }, --Variables: h_chips = +chips when held in hand
    
    loc_vars = function(self, info_queue, center)
        return { vars = { self.config.h_chips } }
    end,
    calculate = function(self, card, context)
        if context.after and context.cardarea == G.hand then
            card:set_ability(G.P_CENTERS.c_base, nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    return true
                end
            })) 
        end
    end
})

SMODS.Enhancement ({ --Glued
    key = 'glued',
    name = 'Glued Card',
    loc_txt = {
        name = 'Glued Card',
        text = {
            '{C:mult}+#1#{} Mult and',
            'wears off when scored',
            'Lose {C:money}$#2#{} when discarded'
        }
    },
	atlas = 'Enhancement',
	pos = { x = 1, y = 0 },
    order = 11,
    config = { mult = 5, cost = 1 }, --Variables: mult = +mult, cost = money loss when discarded
    
    loc_vars = function(self, info_queue, center)
        local function process_var(cost)
			if #find_joker('Glue Hose') > 0 then
                cost = 0
            elseif G.GAME.modifiers.sticky_situation then
                cost = 5
            end
            return cost
		end
        return { vars = { self.config.mult, process_var(self.config.cost) } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring and #find_joker('Relentless Glue') == 0 then
            card:set_ability(G.P_CENTERS.c_base, nil, true)
        elseif context.discard and context.other_card == card and #find_joker('Glue Hose') == 0 then
            if G.GAME.modifiers.sticky_situation then
                ease_dollars(-5*card.ability.cost)
            else
                ease_dollars(-1*card.ability.cost)
            end
            delay(0.3)
        end
    end
})

SMODS.Enhancement ({ --Stunned
    key = 'stunned',
    name = 'Stunned Card',
    loc_txt = {
        name = 'Stunned Card',
        text = {
            'Wears off and is',
            'discarded if held in hand'
        }
    },
	atlas = "Enhancement",
	pos = { x = 2, y = 0 },
    order = 12,

    in_pool = function()
        return false
    end,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.hand then
            stop_use()
            G.CONTROLLER.interrupt.focus = true
            G.CONTROLLER:save_cardarea_focus('hand')
            for k, v in ipairs(G.playing_cards) do
                v.ability.forced_selection = nil
            end
            local stunned = {}
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Stunned Card' then
                    stunned[#stunned+1] = v
                end
            end
            if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
            local count = math.min(#stunned, G.discard.config.card_limit - #G.play.cards)
            if count > 0 then 
                table.sort(stunned, function(a,b) return a.T.x < b.T.x end)
                inc_career_stat('c_cards_discarded', count)
                for j = 1, #G.jokers.cards do
                    G.jokers.cards[j]:calculate_joker({pre_discard = true, full_hand = stunned, hook = hook})
                end
                local cards = {}
                local destroyed_cards = {}
                for i=1, count do
                    stunned[i]:calculate_seal({discard = true})

                    if stunned[i].seal == 'Purple' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
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
                            end)}))
                        card_eval_status_text(stunned[i], 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                    end

                    local removed = false
                    for j = 1, #G.jokers.cards do
                        local eval = nil
                        eval = G.jokers.cards[j]:calculate_joker({discard = true, other_card =  stunned[i], full_hand = stunned})
                        if eval then
                            if eval.remove then removed = true end
                            card_eval_status_text(G.jokers.cards[j], 'jokers', nil, 1, nil, eval)
                        end
                    end
                    table.insert(cards, stunned[i])
                    if removed then
                        destroyed_cards[#destroyed_cards + 1] = stunned[i]
                        stunned[i]:start_dissolve()
                    else 
                        stunned[i].ability.discarded = true
                        stunned[i]:set_ability(G.P_CENTERS.c_base, nil, true)
                        draw_card(G.hand, G.discard, i*100/count, 'down', false, stunned[i])
                    end
                end

                if destroyed_cards[1] then 
                    for j=1, #G.jokers.cards do
                        eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = destroyed_cards})
                    end
                end

                G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
                check_for_unlock({type = 'discard_custom', cards = cards})
            end
        end
    end
})

SMODS.Enhancement ({ --Meteor
    key = 'meteor',
    name = 'Meteor Card',
    loc_txt = {
        name = 'Meteor Card',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            'destroys card',
            'no rank or suit'
        }
    },
	atlas = "Enhancement",
	pos = { x = 3, y = 0 },
    order = 13,
	replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    config = { Xmult = 3 }, --Variables: x_mult = Xmult

    in_pool = function()
        return #find_joker('Inferno Ring') > 0 or #find_joker('Wizard Lord Phoenix') > 0
    end,
    loc_vars = function(self, info_queue, center)
        return { vars = { self.config.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            return {
                x_mult = card.ability.Xmult
            }
        elseif context.destroying_card then
            return { remove = context.destroying_card.ability.name == 'Meteor Card' }
        end
    end
})
