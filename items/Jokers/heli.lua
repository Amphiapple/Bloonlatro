SMODS.Joker { --Heli Pilot
    key = 'heli_pilot',
    name = 'Heli Pilot',
	atlas = 'Joker',
	pos = { x = 0, y = 11 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { mult = 4 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Quad Darts
    key = 'quad_darts',
    name = 'Quad Darts',
    atlas = 'Joker',
	pos = { x = 1, y = 11 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { mult = 6 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Pursuit
    key = 'pursuit',
    name = 'Pursuit',
    atlas = 'Joker',
	pos = { x = 2, y = 11 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { Xmult = 2 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local last_face = nil
            for k, v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    last_face = v
                end
            end
            if context.other_card == last_face then
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Razor Rotors
    key = 'razor_rotors',
    name = 'Razor Rotors',
    atlas = 'Joker',
	pos = { x = 3, y = 11 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { mult = 1, number = 4, loss = 1, current = 0 } --Variables: mult = +mult gain or loss, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.number, card.ability.extra.loss, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if #context.full_hand == card.ability.extra.number then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "current",
                    scalar_value = "mult"
                })
                return nil, true
            elseif card.ability.extra.current > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "current",
                    scalar_value = "loss",
                    operation = function(ref_table, ref_value, initial, change)
                        ref_table[ref_value] = math.max(0, initial - change)
                    end,
                    message_key = 'a_mult_minus',
                    message_colour = G.C.RED
                })
                return nil, true
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Apache Dartship
    key = 'apache_dartship',
    name = 'Apache Dartship',
	atlas = 'Joker',
	pos = { x = 4, y = 11 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { mult = 10 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 2 or context.other_card:get_id() == 3 or context.other_card:get_id() == 5 or context.other_card:get_id() == 7 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

SMODS.Joker { --Apache Prime
    key = 'apache_prime',
    name = 'Apache Prime',
	atlas = 'Joker',
	pos = { x = 5, y = 11 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { Xmult1 = 1.2, Xmult2 = 1.3, Xmult3 = 1.5, Xmult4 = 1.7 } --Variables: Xmult = Xmult for each rank
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult1, card.ability.extra.Xmult2, card.ability.extra.Xmult3, card.ability.extra.Xmult4 } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 2 then
                return {
                    x_mult = card.ability.extra.Xmult1
                }
            elseif context.other_card:get_id() == 3 then
                return {
                    x_mult = card.ability.extra.Xmult2
                }
            elseif context.other_card:get_id() == 5 then
                return {
                    x_mult = card.ability.extra.Xmult3
                }
            elseif context.other_card:get_id() == 7 then
                return {
                    x_mult = card.ability.extra.Xmult4
                }
            end
        end
    end
}

SMODS.Joker { --Bigger Jets
    key = 'bigger_jets',
    name = 'Bigger Jets',
	atlas = 'Joker',
	pos = { x = 6, y = 11 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { mult = 1, current = 0 } --Variables: mult = +mult gain if hand contains a face, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint_card then
            local has_faces = false
            for k, v in ipairs(context.full_hand) do
                if v:is_face() then
                    has_faces = true
                end
            end
            if has_faces then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "current",
                    scalar_value = "mult",
                })
                return nil, true
            elseif card.ability.extra.current > 0 then
                card.ability.extra.current = 0
                return {
                    message = localize('k_reset')
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --IFR
    key = 'ifr',
    name = 'IFR',
    atlas = 'Joker',
	pos = { x = 7, y = 11 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
    },

    calculate = function(self, card, context)
        if context.joker_main and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local has_j, has_q, has_k = false, false, false
            for k, v in ipairs(context.scoring_hand) do
                if not v.debuff then
                    if v:get_id() == 11 then
                        has_j = true
                    elseif v:get_id() == 12 then
                        has_q = true
                    elseif v:get_id() == 13 then
                        has_k = true
                    end
                end
            end
            if has_j and has_q and has_k then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'ifr')
                        tarot:add_to_deck()
                        G.consumeables:emplace(tarot)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            end
        end
    end
}

SMODS.Joker { --Downdraft
    key = 'downdraft',
    name = 'Downdraft',
    atlas = 'Joker',
	pos = { x = 8, y = 11 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { ready = true, active = false, hands = 0, discards = 0 } --Variables: ready = ready to combine hands and discards, active = hands merged with discards, hands = added hands, discards = added discards
    },

    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.active then
            if G.GAME.round_resets.hands - G.GAME.current_round.hands_played <= 0 then
                ease_hands_played(1 - G.GAME.current_round.hands_left)
            else
                ease_hands_played(G.GAME.round_resets.hands - G.GAME.current_round.hands_played - G.GAME.current_round.hands_left)
            end
            if G.GAME.round_resets.discards - G.GAME.current_round.discards_used < 0 then
                ease_discard(-G.GAME.current_round.discards_left)
            else
                ease_discard(G.GAME.round_resets.discards - G.GAME.current_round.discards_used - G.GAME.current_round.discards_left)
            end
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and card.ability.extra.ready and not context.getting_sliced and not context.blueprint then
            local downdrafts = find_joker('Downdraft')
            for k, v in pairs(downdrafts) do
                if v ~= card then
                    v.ability.extra.ready = false
                end
            end
            card.ability.extra.active = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.ability.extra.hands = G.GAME.current_round.discards_left
                    card.ability.extra.discard = G.GAME.current_round.hands_left
                    ease_hands_played(G.GAME.current_round.discards_left)
                    ease_discard(G.GAME.current_round.hands_left)
                    return true
                end 
            }))
        elseif context.before and card.ability.extra.active and G.GAME.current_round.discards_left > G.GAME.current_round.hands_left and not context.blueprint then
            ease_discard(-1)
        elseif context.pre_discard and card.ability.extra.active and G.GAME.current_round.hands_left >= G.GAME.current_round.discards_left then
            ease_hands_played(-1)
            if G.GAME.current_round.hands_left <= 1 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        G.STATE = G.STATES.GAME_OVER
                        G.STATE_COMPLETE = false
                        return true
                    end
                }))
            end
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.active = false
            card.ability.extra.ready = true
        end
    end
}

SMODS.Joker { --Support Chinook
    key = 'support_chinook',
    name = 'Support Chinook',
    atlas = 'Joker',
	pos = { x = 9, y = 11 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { slots = 1, hands = 1 } --Variables: slots = extra consumable slots, hands = extra hands
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, card.ability.extra.hands } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.consumeable_slot_buffer = G.GAME.consumeable_slot_buffer or 0

        G.GAME.consumeable_slot_buffer = G.GAME.consumeable_slot_buffer + card.ability.extra.slots
        G.consumeables.config.card_limit = G.GAME.consumeable_slot_buffer + G.consumeables.config.card_limit
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.consumeable_slot_buffer = G.GAME.consumeable_slot_buffer - card.ability.extra.slots
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.consumeable_slot_buffer = G.GAME.consumeable_slot_buffer or 0

        G.GAME.consumeable_slot_buffer = G.GAME.consumeable_slot_buffer - card.ability.extra.slots
        G.consumeables.config.card_limit = G.GAME.consumeable_slot_buffer + G.consumeables.config.card_limit
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.consumeable_slot_buffer = G.GAME.consumeable_slot_buffer + card.ability.extra.slots
                return true
            end
        }))
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(card.ability.extra.hands)
                    return true
                end 
            }))
        end
    end
}

SMODS.Joker { --Special Poperations
    key = 'special_poperations',
    name = 'Special Poperations',
	atlas = 'Joker',
	pos = { x = 10, y = 11 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = {marine = 5, cash = 9, counter = 0 } --Variables: hands = extra hands, marine = hands for marine, cash = hands for cash drop, current = current hands
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_bloons_marine
        info_queue[#info_queue+1] = G.P_CENTERS.c_bloons_cash_drop
        local function process_var(count, cap)
			return count % cap
		end
		return {
			vars = {
                card.ability.extra.marine,
                process_var(card.ability.extra.counter, card.ability.extra.marine),
                card.ability.extra.cash,
                process_var(card.ability.extra.counter, card.ability.extra.cash),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = G.GAME.hands_played - card.ability.hands_played_at_create + 1
            if card.ability.extra.counter % card.ability.extra.marine == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card = create_card('j_bloons_marine', G.jokers, nil, 0, nil, nil, 'j_bloons_marine', 'special_poperations')
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
            elseif card.ability.extra.counter % card.ability.extra.cash == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('c_bloons_cash_drop', G.consumeables, nil, nil, nil, nil, 'c_bloons_cash_drop', 'special_poperations')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1 Power', colour = G.C.POWER})
            end
        end
    end
}

SMODS.Joker { --Faster Darts
    key = 'faster_darts',
    name = 'Faster Darts',
	atlas = 'Joker',
	pos = { x = 11, y = 11 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { chips = 25 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --Faster Firing
    key = 'faster_firing',
    name = 'Faster Firing',
	atlas = 'Joker',
	pos = { x = 12, y = 11 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { chips = 35 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --MOAB Shove
    key = 'moab_shove',
    name = 'MOAB Shove',
	atlas = 'Joker',
	pos = { x = 13, y = 11 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { hands = 3, counter = 0 } --Variables: hands = extra hands, scored_chips = chips for first hands, counter = amount of blowback hands left
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands, card.ability.extra.counter } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            if G.GAME.blind.boss then
                card.ability.extra.counter = card.ability.extra.counter + card.ability.extra.hands
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_hands_played(card.ability.extra.hands)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hands}}})
                        return true
                    end
                }))
            end
        elseif context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (card.ability.extra.counter > 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.final_scoring_step and card.ability.extra.counter > 0 and not context.blueprint then
            hand_chips = mod_chips(0)
            hand_mult = mod_mult(0)
            card.ability.extra.counter = card.ability.extra.counter - 1
            update_hand_text( { delay = 0 }, { chips = hand_chips, mult = hand_mult } )
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("timpani", 1)
					attention_text({
						scale = 1.4,
						text = "Shoved",
						hold = 0.45,
						align = "cm",
						offset = { x = 0, y = -2.7 },
						major = G.play,
					})
					return true
				end,
			}))
            delay(0.6)
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.counter = 0
        end
    end
}

SMODS.Joker { --Comanche Defense
    key = 'comanche_defense',
    name = 'Comanche Defense',
	atlas = 'Joker',
	pos = { x = 14, y = 11 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { number = 3, chips = 20, current = 0, counter = 0 } --Variables: numebr = max number of face cards, chips = +chips, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.number, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:is_face() and card.ability.extra.counter < card.ability.extra.number then
                        card.ability.extra.counter = card.ability.extra.counter + 1
                        card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
                    end
                end
            end
            return {
                chips = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.counter = 0
        elseif context.end_of_round and card.ability.extra.current > 0 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Comanche Commander
    key = 'comanche_commander',
    name = 'Comanche Commander',
	atlas = 'Joker',
	pos = { x = 15, y = 11 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Heli Pilot", category = "military" },
        extra = { number = 3, Xmult = 1.5, faces = {} } --Variables: number = number of cards retriggered, Xmult = Xmult per face
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            local triggered = false
            for k, v in ipairs(card.ability.extra.faces) do
                if context.other_card == v then
                    triggered = true
                end
            end
            if triggered then
                return {
                    x_mult = card.ability.extra.Xmult
                }
            elseif #card.ability.extra.faces < card.ability.extra.number then
                table.insert(card.ability.extra.faces, context.other_card)
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        elseif context.after and not context.blueprint then
            card.ability.extra.faces = {}
        end
    end
}
