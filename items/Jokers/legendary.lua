SMODS.Joker { --Apex Plasma Master
    key = 'apex_plasma_master',
    name = 'Apex Plasma Master',
	atlas = 'Joker',
	pos = { x = 0, y = 26 },
    soul_atlas = 'Soul',
    soul_pos = { x = 0, y = 2 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dart Monkey", category = "primary" },
        extra = { Xmult_scaling = 0.1, Xmult = 0.1, current = 1, limit = 15, counter = 15 } --Variables = Xmult_scaling = scaling increase, Xmult = Xmult gain, current = current Xmult, limit = required card count, counter = current card count
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.limit, card.ability.extra.counter, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            card.ability.extra.counter = card.ability.extra.counter - 1
            if card.ability.extra.counter <= 0 then
                card.ability.extra.counter = card.ability.extra.limit
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_scaling
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Glaive Dominus
    key = 'glaive_dominus',
    name = 'Glaive Dominus',
	atlas = 'Joker',
	pos = { x = 1, y = 26 },
    soul_atlas = 'Soul',
    soul_pos = { x = 1, y = 2 },
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

SMODS.Joker { --Ballistic Obliteration Missile Bunker
    key = 'ballistic_obliteration_missile_bunker',
    name = 'Ballistic Obliteration Missile Bunker',
	atlas = 'Joker',
	pos = { x = 2, y = 26 },
    soul_atlas = 'Soul',
    soul_pos = { x = 2, y = 2 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { Xmult = 1.5 }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not SMODS.has_no_rank(context.other_card) then
            local paired = false
            local id = context.other_card:get_id()
            for k, v in ipairs(context.scoring_hand) do
                if id == v:get_id() and context.other_card ~= v and not SMODS.has_no_rank(v) and not v.debuff then
                    paired = true
                end
            end
            if paired then
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        end
    end
}

SMODS.Joker { --Crucible of Steel and Flame
    key = 'crucible_of_steel_and_flame',
    name = 'Crucible of Steel and Flame',
	atlas = 'Joker',
	pos = { x = 3, y = 26 },
    soul_atlas = 'Soul',
    soul_pos = { x = 3, y = 2 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Tack Shooter", category = "primary" },
        extra = { number = 2 } --Variables = number = meteor cards added
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number } }
    end,
    add_to_deck = function(self, card, from_debuff)
        for i = 1, card.ability.extra.number do
            local front = pseudorandom_element(G.P_CARDS, 'crucible_of_steel_and_flame')
            local meteor = SMODS.add_card({
                set = 'Playing Card',
                front = front,
                area = G.deck,
                skip_materialize = false,
            })
            meteor:set_ability('m_bloons_meteor', nil, true)
            card_eval_status_text(meteor, 'extra', nil, nil, nil, {message = '+1 Meteor', colour = G.C.SECONDARY_SET.Enhanced})

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

SMODS.Joker { --Herald of Everfrost
    key = 'herald_of_everfrost',
    name = 'Herald of Everfrost',
	atlas = 'Joker',
	pos = { x = 4, y = 26 },
    soul_atlas = 'Soul',
    soul_pos = { x = 4, y = 2 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ice Monkey", category = "primary" },
        extra = { number = 2, percent = 80, hands = 3, counter = 3 } --Variables = number = nuimber of cards frozen, percent = blind requirement reduction percent, hands = hands required to disable blind, counter = hands until blind disabled
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, 100 - card.ability.extra.percent, card.ability.extra.hands, card.ability.extra.counter } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local valid_cards = {}
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.effect ~= 'Frozen_card' and not v.debuff then
                    valid_cards[#valid_cards+1] = v
                end
            end
            pseudoshuffle(valid_cards, 'herald_of_everfrost')
            for i = 1, card.ability.extra.number do
                local frozen_card = valid_cards[i]
                if frozen_card then
                    frozen_card:set_ability('m_bloons_frozen', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            frozen_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if card.ability.extra.counter == 1 and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                G.GAME.blind:disable_blind_modifiers()
                G.GAME.blind:disable()
            end
            return {
                xblindsize = card.ability.extra.percent / 100
            }
        elseif context.after then
            card.ability.extra.counter = math.max(0, card.ability.extra.hands - G.GAME.current_round.hands_played)
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.counter = card.ability.extra.hands
        end
    end
}

SMODS.Joker { --Nautic Siege Core
    key = 'nautic_siege_core',
    name = 'Nautic Siege Core',
    atlas = 'Joker',
    pos = { x = 8, y = 26 },
    soul_atlas = 'Soul',
    soul_pos = { x = 8, y = 2 },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,

    config = {
        tower_info = { base = "Monkey Sub", category = "military" },
        extra = { submerged = false, Xmult = 2, money = 2, hands = 6, charge = 6, Xmult_nuke = 6 },
        button = { text = "SUB", colour = G.C.BLUE }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.money, card.ability.extra.hands, card.ability.extra.charge, card.ability.extra.Xmult_nuke } }
    end,

    can_use = function(card)
        return true
    end,

    use = function(card)
        if not card or not card.children or not card.children.center then return end
        card.ability.extra.submerged = not card.ability.extra.submerged
        if card.ability.extra.submerged then
            card.children.center:set_sprite_pos({ x = 15, y = 26 })
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - card.ability.extra.money
                    G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.money)
                    return true
                end
            }))
        else
            card.children.center:set_sprite_pos({ x = 8, y = 26 })
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + card.ability.extra.money
                    G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost + card.ability.extra.money)
                    return true
                end
            }))
        end
    end,

    set_sprites = function(self, card, front)
        if not card or not card.ability or not card.ability.extra then return end
        if card.ability.extra.submerged then
            card.children.center:set_sprite_pos({ x = 15, y = 26 })
        else
            card.children.center:set_sprite_pos({ x = 8, y = 26 })
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and not card.ability.extra.submerged then
            if card.ability.extra.charge == 0 then
                card.ability.extra.charge = card.ability.extra.hands
                return {
                    x_mult = card.ability.extra.Xmult_nuke
                }
            else
                card.ability.extra.charge = card.ability.extra.hands
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        elseif context.after and card.ability.extra.submerged and card.ability.extra.charge > 0 then
            card.ability.extra.charge = card.ability.extra.charge - 1
            if card.ability.extra.charge == 0 then
                local eval = function()
                    return card.ability.extra.charge == 0
                end
                juice_card_until(card, eval, true)
            end
        end
    end
}

SMODS.Joker { --Navarch of the Seas
    key = 'navarch_of_the_seas',
    name = 'Navarch of the Seas',
    atlas = 'Joker',
    pos = { x = 9, y = 26 },
    soul_atlas = 'Soul',
    soul_pos = { x = 9, y = 2 },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,

    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { num = 1, denom = 3, Xmult = 1.5, money = 5, planes = 1 }
    },
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'navarch_of_the_seas')
        return { vars = { n, d, card.ability.extra.Xmult, card.ability.extra.money, card.ability.extra.planes } }
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint then
            local count = #context.removed
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'planes',
                operation = function(ref_table, ref_value, initial, change)
                    ref_table[ref_value] = initial + count
                end,
            })
            return{
                dollars = card.ability.extra.money * count
            }
        elseif context.joker_main then
            for i = 1, card.ability.extra.planes do
                if SMODS.pseudorandom_probability(card, 'navarch_of_the_seas', card.ability.extra.num, card.ability.extra.denom, 'navarch_of_the_seas') then
                    mult = mod_mult(mult * card.ability.extra.Xmult)
                    update_hand_text( { delay = 0 }, { mult = mult } )
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('multhit2')
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = localize{
                            type = 'variable',
                            key = 'a_xmult',
                            vars = {card.ability.extra.Xmult}
                        }
                    })
                else
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot2', 1, 0.4)
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = localize('k_nope_ex')
                    })
                end
            end
        end
    end
}

SMODS.Joker { --Goliath Doomship
    key = 'goliath_doomship',
    name = 'Goliath Doomship',
	atlas = 'Joker',
	pos = { x = 10, y = 26 },
    soul_atlas = 'Soul',
    soul_pos = { x = 10, y = 2 },
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
	atlas = 'Joker',
	pos = { x = 0, y = 27 },
    soul_atlas = 'Soul',
    soul_pos = { x = 0, y = 4 },
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

SMODS.Joker { --Ascended Shadow
    key = 'ascended_shadow',
    name = 'Ascended Shadow',
	atlas = 'Joker',
	pos = { x = 2, y = 27 },
    soul_atlas = 'Soul',
    soul_pos = { x = 2, y = 4 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Ninja Monkey", category = "magic" },
        extra = { Xmult = 4 } --Variables: Xmult = Xmult, stickied = stickied card
    },

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    update = function(self, card, dt)
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if v.facing == 'back' then
                    v:flip()
                end
                if v.debuff then
                    v.debuff = false
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if (context.hand_drawn or context.first_hand_drawn) and not context.blueprint then
            local any_forced = nil
            for k, v in ipairs(G.hand.cards) do
                if v.ability.forced_selection then
                    v.ability.ascended_shadow = true
                    any_forced = true
                end
            end
            if not any_forced then
                G.hand:unhighlight_all()
                local forced_card = pseudorandom_element(G.hand.cards, 'ascended_shadow')
                forced_card.ability.forced_selection = true
                forced_card.ability.ascended_shadow = true
                G.hand:add_to_highlighted(forced_card)
            end
        elseif context.individual and context.cardarea == G.play and context.other_card.ability.ascended_shadow then
            return {
                Xmult = card.ability.extra.Xmult,
            }
        elseif context.after and not context.blueprint then
            for k, v in ipairs(context.full_hand) do
                if v.ability.ascended_shadow then
                    v.ability.ascended_shadow = false
                end
            end
        elseif context.discard and context.other_card.ability.ascended_shadow and not context.blueprint then
            context.other_card.ability.ascended_shadow = false
        end
    end
}

SMODS.Joker { --Root of All Nature
    key = 'root_of_all_nature',
    name = 'Root of All Nature',
	atlas = 'Joker',
	pos = { x = 4, y = 27 },
    soul_atlas = 'Soul',
    soul_pos = { x = 4, y = 4 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { money = 3, Xmult = 0.1, rate = 5, current = 1 } --Variables: money = dollars per hand, Xmult = Xmult increase per rate
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.money,
                card.ability.extra.Xmult,
                card.ability.extra.rate,
                card.ability.extra.current,
            }
        }
    end,
    update = function(self, card, dt)
        if G.GAME.dollars then
            card.ability.extra.current = 1 + card.ability.extra.Xmult * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.rate)
        end
    end,
    calculate = function(self, card, context)
        if context.before then
            return {
                dollars = card.ability.extra.money
            }
        elseif context.joker_main and math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.rate) > 1 then
            return {
                Xmult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Mega Massive Munitions Factory
    key = 'mega_massive_munitions_factory',
    name = 'Mega Massive Munitions Factory',
	atlas = 'Joker',
	pos = { x = 7, y = 27 },
    soul_atlas = 'Soul',
    soul_pos = { x = 7, y = 4 },
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

SMODS.Joker { --Master Builder
    key = 'master_builder',
    name = 'Master Builder',
	atlas = 'Joker',
	pos = { x = 9, y = 27 },
    soul_atlas = 'Soul',
    soul_pos = { x = 9, y = 4 },
    rarity = 4,
	cost = 20,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { sentries = { 'j_bloons_mega_green_sentry', 'j_bloons_mega_red_sentry', 'j_bloons_mega_blue_sentry' }, counter = 1, Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult gain, current = current Xmult
    },

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_mega_green_sentry
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_mega_red_sentry
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_mega_blue_sentry
        return {
            vars = {
                localize({type = 'name_text', key = card.ability.extra.sentries[card.ability.extra.counter], set = 'Joker'}),
                card.ability.extra.Xmult,
                card.ability.extra.current,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            local sentry = card.ability.extra.sentries[card.ability.extra.counter]
            local duplicates = find_joker(localize({type = 'name_text', key = sentry, set = 'Joker'}))
            if #duplicates > 0 then
                for k, v in ipairs(duplicates) do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.destroy_cards(v, nil, nil, false)
                            v:remove()
                            return true
                        end
                    }))
                end
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker = create_card(sentry, G.jokers, nil, 0, nil, nil, sentry, 'master_builder')
                    joker:add_to_deck()
                    G.jokers:emplace(joker)
                    joker:start_materialize()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            card.ability.extra.counter = math.fmod(card.ability.extra.counter, 3) + 1
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        elseif context.selling_self and not context.blueprint then
            for k, v in ipairs(G.jokers.cards) do
                if v.ability.tower_info and v.ability.tower_info.base == 'Sentry' and v:is_rarity('Legendary') then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.destroy_cards(v, nil, nil, false)
                            v:remove()
                            return true
                        end
                    }))
                end
            end
        end
    end
}

SMODS.Joker { --Vengeful True Sun God
    key = 'vengeful_true_sun_god',
    name = 'Vengeful True Sun God',
	atlas = 'Joker',
	pos = { x = 15, y = 27 },
    soul_atlas = 'Soul',
    soul_pos = { x = 15, y = 4 },
    rarity = 4,
	cost = 20,
	blueprint_compat = true,
    in_pool = function(self, args)
        return false
    end,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        --Variables: chips = +chips, mult = +mult, Xmult = Xmult, consumables = consumable amount, discount = discount amount, Xmult support = other joker Xmult
        extra = { sacrifices = {}, chips = 20, mult = 5, Xmult = 0.25, retrigger = 1, consumable = 1, money = 3, discount = 1 },
        button = { text = "SAC", colour = HEX("383C76") }
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

    can_use = function(card)
        local sacrifices = card.ability and card.ability.extra and card.ability.extra.sacrifices
        if not sacrifices then return false end

        local no_sacs =
            (sacrifices.primary or 0) == 0 and
            (sacrifices.military or 0) == 0 and
            (sacrifices.magic or 0) == 0 and
            (sacrifices.support or 0) == 0
        if not no_sacs then return false end

        local has_valid_target = false
        for _, joker in pairs(G.jokers.cards or {}) do
            if joker ~= card then
                local tower = joker.ability and joker.ability.tower_info
                local base = tower and tower.base
                local category = tower and tower.category

                local valid_base = base and base ~= "Sentry" and base ~= "Marine"
                local valid_category = category and string.lower(tostring(category)) ~= "misc"

                if valid_base and valid_category then
                    has_valid_target = true
                    break
                end
            end
        end
        return has_valid_target
    end,

    use = function(card)
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

    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.sacrifices['primary'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['primary']) or 0
        card.ability.extra.sacrifices['military'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['military']) or 0
        card.ability.extra.sacrifices['magic'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['magic']) or 0
        card.ability.extra.sacrifices['support'] = (card.ability.extra.sacrifices and card.ability.extra.sacrifices['support']) or 0
    end,
    remove_from_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local chips = math.floor(card.ability.extra.sacrifices['primary'] / 2) + math.floor(card.ability.extra.sacrifices['military'] / 2)
            local mult = math.ceil(card.ability.extra.sacrifices['primary'] / 2) + math.floor(card.ability.extra.sacrifices['magic'] / 2)
            local Xmult = math.floor(card.ability.extra.sacrifices['primary'] * 2 / 9) + math.ceil(card.ability.extra.sacrifices['military'] / 2) +
                    math.ceil(card.ability.extra.sacrifices['magic'] / 2) + math.floor(card.ability.extra.sacrifices['support'] / 3)
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
