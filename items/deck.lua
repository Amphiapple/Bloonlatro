SMODS.Atlas {
    key = 'Back',
    path = 'decks.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'Boss_challenge_back',
    path = 'boss_challenge_decks.png',
    px = 71,
    py = 95,
}

SMODS.Back { --Quincy
    key = "quincy",
    name = "Quincy Deck",
    atlas = "Back",
    pos = { x = 0, y = 0 },
    config = { extra = { num = 1, denom = 4 }, ante_scaling = 0.75 }, --Variables: num/denom = probability fraction, ante_scaling = score requirement multiplier

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(self, self.config.extra.num, self.config.extra.denom, 'quincy')
        return { vars = { n, d, self.config.ante_scaling } }
    end,
    calculate = function(self, back, context)
        if context.final_scoring_step and SMODS.pseudorandom_probability(self, 'quincy', self.config.extra.num, self.config.extra.denom, 'quincy') then
            hand_chips = mod_chips(hand_chips / 2.0)
            update_hand_text({ delay = 0 }, { chips = hand_chips })
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("timpani", 1)
                    attention_text({
                        scale = 1.4,
                        text = "MISS",
                        hold = 2,
                        align = "cm",
                        offset = { x = 0, y = -2.7 },
                        major = G.play,
                    })
                    return true
                end,
            }))
        end
    end
}

SMODS.Back { --Gwendolin
    key = "gwendolin",
    name = "Gwendolin Deck",
    atlas = "Back",
    pos = { x = 1, y = 0 },
    config = { consumables = { 'c_immolate' }, hands = -1 }
}

SMODS.Back { --Jones
    key = "jones",
    name = "Jones Deck",
    atlas = "Back",
    pos = { x = 2, y = 0 },

    calculate = function(self, back, context)
        if context.end_of_round and context.beat_boss and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not context.individual and not context.repetition then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    local power = create_card('c_bloons_artillery_command', G.consumeables, nil, nil, nil, nil,
                        'c_bloons_artillery_command', 'jones')
                    power:add_to_deck()
                    G.consumeables:emplace(power)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
        end
    end
}

SMODS.Back { --Obyn
    key = "obyn",
    name = "Obyn Deck",
    atlas = "Back",
    pos = { x = 3, y = 0 },
    config = { vouchers = { 'v_seed_money', 'v_money_tree' } }
}

SMODS.Back { --Churchill
    key = "churchill",
    name = "Churchill Deck",
    atlas = "Back",
    pos = { x = 4, y = 0 },
    config = { extra = { Xmult = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.Xmult } }
    end,
    calculate = function(self, back, context)
        if context.final_scoring_step and G.GAME.blind.boss then
            mult = mod_mult(mult * self.config.extra.Xmult)
            update_hand_text({ delay = 0 }, { mult = mult })
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("multhit2", 1)
                    attention_text({
                        scale = 1.4,
                        text = "Try This!",
                        color = G.C.MULT,
                        hold = 0.45,
                        align = "cm",
                        offset = { x = 0, y = -2.7 },
                        major = G.play,
                    })
                    return true
                end,
            }))
        end
    end
}

SMODS.Back { --Benjamin
    key = "benjamin",
    name = "Benjamin Deck",
    atlas = "Back",
    pos = { x = 0, y = 1 },
    config = { jokers = { 'j_bloons_monkey_bank' }, dollars = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.dollars } }
    end
}

SMODS.Back { --Ezili
    key = "ezili",
    name = "Ezili Deck",
    atlas = "Back",
    pos = { x = 1, y = 1 },
    config = { vouchers = { 'v_magic_trick', 'v_illusion', 'v_hone', 'v_glow_up' } }
}

SMODS.Back { --Pat Fusty
    key = "pat_fusty",
    name = "Pat Fusty Deck",
    atlas = "Back",
    pos = { x = 2, y = 1 },
    config = { hand_size = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.hand_size } }
    end
}

SMODS.Back { --Adora
    key = "adora",
    name = "Adora Deck",
    atlas = "Back",
    pos = { x = 3, y = 1 },
    config = {
        extra = { sac_levels = 2 },
        button = { text = "SAC", colour = HEX("FFCE00") }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.sac_levels } }
    end,

    can_use = function(card)
        if card.ability and card.ability.eternal then return false end
        return true
    end,

    use = function(card)
        local visible = {}
        for k, v in pairs(G.handlist) do
            if G.GAME.hands[v].visible then
                table.insert(visible, v)
            end
        end
        for i = 1, G.GAME.selected_back.effect.config.extra.sac_levels do
            local hand = pseudorandom_element(visible, pseudoseed(''))
            update_hand_text(
                { sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                {
                    handname = localize(hand, 'poker_hands'),
                    chips = G.GAME.hands[hand].chips,
                    mult = G.GAME.hands[hand].mult,
                    level = G.GAME.hands[hand].level
                }
            )
            level_up_hand(card, hand)
            update_hand_text(
                { sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                { mult = 0, chips = 0, handname = '', level = '' }
            )
        end
        card:sell_card()
        SMODS.calculate_context({ selling_card = true, card = card })
    end
}

SMODS.Back { --Brickell
    key = "brickell",
    name = "Brickell Deck",
    atlas = "Back",
    pos = { x = 4, y = 1 },
    config = { extra = { ante = 0, discards = 0 }, hands = 1, },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.ante, self.config.hands, self.config.extra.discards } }
    end,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_ante(-1)
                ease_discard(-G.GAME.round_resets.discards)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = self.config.extra.ante
                G.GAME.round_resets.discards = self.config.extra.discards
                return true
            end
        }))
    end,
}

SMODS.Back { --Etienne
    key = "etienne",
    name = "Etienne Deck",
    atlas = "Back",
    pos = { x = 0, y = 2 },
    config = { extra = { slots = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.slots } }
    end,
    apply = function(self)
        SMODS.change_booster_limit(self.config.extra.slots)
    end
}

SMODS.Back { --Sauda
    key = "sauda",
    name = "Sauda Deck",
    atlas = "Back",
    pos = { x = 1, y = 2 },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.GAME.hands) do
                    level_up_hand(G.deck.cards[1], k, true, 1)
                end
                return true
            end
        }))
    end
}

SMODS.Back { --Psi
    key = "psi",
    name = "Psi Deck",
    atlas = "Back",
    pos = { x = 2, y = 2 },
    config = { extra = { number = 2 } },

    loc_vars = function(self, info_queue, card)
        local function process_var(pos)
            if G.GAME.selected_back.name == 'Psi Deck' then
                return '#@' .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards - pos + 1].base.id or 11) ..
                    (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards - pos + 1].base.suit:sub(1, 1) or 'D')
            end
            return '#@'
        end
        return {
            vars = {
                self.config.extra.number,
                process_var(1),
                process_var(2)
            }
        }
    end
}

SMODS.Back { --Geraldo
    key = "geraldo",
    name = "Geraldo Deck",
    atlas = "Back",
    pos = { x = 3, y = 2 },
    config = { vouchers = { 'v_bloons_power_merchant' } }
}

SMODS.Back { --Corvus
    key = "corvus",
    name = "Corvus Deck",
    atlas = "Back",
    pos = { x = 4, y = 2 },
    config = { extra = { max_mana = 25, mana_per_card = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.mana_per_card, self.config.extra.max_mana } }
    end,

    apply = function(self)
        G.GAME.corvus_mana = { current_mana = 0, max_mana = self.config.extra.max_mana, mana_per_card = self.config
        .extra.mana_per_card }
    end,

    calculate = function(self, back, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.corvus_mana.current_mana = G.GAME.corvus_mana.current_mana + G.GAME.corvus_mana.mana_per_card
                    if G.GAME.corvus_mana.current_mana >= G.GAME.corvus_mana.max_mana then
                        G.GAME.corvus_mana.current_mana = 0
                        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            local spectral = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'acid')
                            spectral:add_to_deck()
                            G.consumeables:emplace(spectral)
                            G.GAME.consumeable_buffer = 0
                        end
                    end
                    return true
                end,
            }))
        end
    end
}

SMODS.Back { --Rosalia
    key = "rosalia",
    name = "Rosalia Deck",
    atlas = "Back",
    pos = { x = 0, y = 3 },
    config = { extra = { Xmult = 1.2, retrigger = 1 } }, --Variables = Xmult = Xmult on odd hands, retrigger = retrigger count on even hands

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.Xmult } }
    end,
    apply = function(self, back)
        G.GAME.rosalia_weapon = "laser"
    end,
    calculate = function(self, back, context)
        if G.GAME.rosalia_weapon == "laser" and context.final_scoring_step then
            return {
                x_mult = self.config.extra.Xmult,
            }
        elseif G.GAME.rosalia_weapon == "grenade" and context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
            return {
                repetitions = self.config.extra.retrigger,
            }
        end
    end
}

SMODS.Back { --Silas
    key = "silas",
    name = "Silas Deck",
    atlas = "Back",
    pos = { x = 1, y = 3 },
    config = { extra = { number = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.number } }
    end,
    calculate = function(self, back, context)
        if context.end_of_round and not context.individual and not context.repetition then
            local valid_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if v.ability.effect ~= 'Frozen_card' and not v.debuff then
                    valid_cards[#valid_cards + 1] = v
                end
            end
            for i = 1, self.config.extra.number do
                if valid_cards[1] then
                    local frozen_card = pseudorandom_element(valid_cards, pseudoseed('silas' .. G.GAME.round_resets.ante))
                    frozen_card:set_ability('m_bloons_frozen', nil, true)
                    for k, v in pairs(valid_cards) do
                        if v == frozen_card then
                            table.remove(valid_cards, i)
                            break
                        end
                    end
                end
            end
        end
    end
}

SMODS.Back {
    key = "boss_challenge",
    name = "Boss Challenge Deck",
    atlas = "Boss_challenge_back",
    pos = { x = 0, y = 0 },
    omit = true,

    config = {
        vouchers = {},
        extra = {
            boss_challenge_key = nil,
            win_ante = 8,
            banned_keys = {},
        }
    },

    load_params = function(self)
        local params = G.PROFILES[G.SETTINGS.profile].bloons_boss_challenge_params
        if not params then return end
        self.config.extra.boss_challenge_key = params.boss_challenge
        self.config.vouchers = params.vouchers or {}
        self.config.extra.win_ante = params.win_ante or 8
        self.config.extra.banned_keys = params.banned_keys or {}
    end,

    set_params = function(self, params)
        params = params or {}

        if params.boss_challenge then self.config.extra.boss_challenge_key = params.boss_challenge end
        if params.vouchers then self.config.vouchers = params.vouchers end
        if params.win_ante then self.config.extra.win_ante = params.win_ante end
        if params.banned_keys then self.config.extra.banned_keys = params.banned_keys end

        G.PROFILES[G.SETTINGS.profile].bloons_boss_challenge_params = params
    end,

    apply = function(self)
        G.GAME.win_ante = self.config.extra.win_ante
        G.GAME.banned_keys = G.GAME.banned_keys or {}
        for _, v in ipairs(self.config.extra.banned_keys) do
            G.GAME.banned_keys[v.id] = true
            if v.ids then
                for _, vv in ipairs(v.ids) do
                    G.GAME.banned_keys[vv] = true
                end
            end
        end
    end,

    get_boss_blind = function(self)
        local key = self.config and self.config.extra and self.config.extra.boss_challenge_key or G.PROFILES[G.SETTINGS.profile].bloons_boss_challenge_params.boss_challenge
        if not key then return nil end
        return G.P_BLINDS and G.P_BLINDS[key]
    end,

    get_boss_segments = function(self)
        local blind = self:get_boss_blind()
        if not blind then return {} end

        local parts = blind.bloonlatro_boss and blind.bloonlatro_boss.parts

        if not parts or not parts.main then return end

        local segments = {}

        for _, v in pairs(G.P_BLINDS or {}) do
            if v.boss and v.boss.showdown and v.bloonlatro_boss then
                local p = v.bloonlatro_boss.parts
                if p and p.main == parts.main then
                    segments[#segments + 1] = v
                end
            end
        end

        table.sort(segments, function(a, b)
            return (a.bloonlatro_boss.parts.order or 0)
                < (b.bloonlatro_boss.parts.order or 0)
        end)

        return segments
    end
}
