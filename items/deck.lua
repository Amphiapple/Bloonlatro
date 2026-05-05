SMODS.Atlas {
    key = 'Back',
    path = 'decks.png',
    px = 71,
    py = 95,
}

SMODS.Back { --Quincy
    key = "quincy",
    name = "Quincy Deck",
	loc_txt = {
        name = 'Quincy Deck',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'halve Chips',
            '{C:mult}X#3#{} base Blind size'
        }
    },
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
            update_hand_text( { delay = 0 }, { chips = hand_chips } )
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
	loc_txt = {
        name = 'Gwendolin Deck',
        text = {
            'Start run with',
            'an {C:spectral,T:c_immolate}Immolate{} card',
            '{C:blue}-1{} hand every round'
        }
    },
	atlas = "Back",
	pos = { x = 1, y = 0 },
    config = { consumables = {'c_immolate'}, hands = -1 }
}

SMODS.Back { --Jones
    key = "jones",
    name = "Jones Deck",
	loc_txt = {
        name = 'Jones Deck',
        text = {
            'Create an {C:power,T:c_bloons_artillery_command}Artillery Command{}',
            'card after defeating',
            'each {C:attention}Boss Blind{}'
        }
    },
	atlas = "Back",
	pos = { x = 2, y = 0 },

    calculate = function(self, back, context)
        if context.end_of_round and context.beat_boss and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not context.individual and not context.repetition then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    local power = create_card('c_bloons_artillery_command', G.consumeables, nil, nil, nil, nil, 'c_bloons_artillery_command', 'jones')
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
	loc_txt = {
        name = 'Obyn Deck',
        text = {
            'Start run with {C:money,T:v_seed_money}Seed Money{}',
            'and {C:money,T:v_money_tree}Money Tree{}'
        }
    },
	atlas = "Back",
	pos = { x = 3, y = 0 },
    config = { vouchers = {'v_seed_money','v_money_tree'} }
}

SMODS.Back { --Churchill
    key = "churchill",
    name = "Churchill Deck",
	loc_txt = {
        name = 'Churchill Deck',
        text = {
            '{X:mult,C:white}X#1#{} Mult against',
            '{C:attention}Boss Blinds{}'
        }
    },
	atlas = "Back",
	pos = { x = 4, y = 0 },
    config = { extra = { Xmult = 2 } },

    loc_vars = function(self, info_queue, card)
		return { vars = { self.config.extra.Xmult } }
	end,
    calculate = function(self, back, context)
		if context.final_scoring_step and G.GAME.blind.boss then
            mult = mod_mult(mult * self.config.extra.Xmult)
            update_hand_text( { delay = 0 }, { mult = mult } )
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
	loc_txt = {
        name = 'Benjamin Deck',
        text = {
            'Start with {C:attention,T:j_bloons_monkey_bank}Monkey Bank{}',
            'and extra {C:money}$#1#'
        }
    },
	atlas = "Back",
	pos = { x = 0, y = 1 },
    config = { jokers = {'j_bloons_monkey_bank'}, dollars = 1 },

    loc_vars = function(self, info_queue, card)
		return { vars = { self.config.dollars } }
	end
}

SMODS.Back { --Ezili
    key = "ezili",
    name = "Ezili Deck",
	loc_txt = {
        name = 'Ezili Deck',
        text = {
            'Start run with',
            '{C:attention,T:v_magic_trick}Magic Trick{}, {C:enhanced,T:v_illusion}Illusion{},',
            '{C:dark_edition,T:v_hone}Hone{}, and {C:dark_edition,T:v_glow_up}Glow Up{}'
        }
    },
	atlas = "Back",
	pos = { x = 1, y = 1 },
    config = { vouchers = {'v_magic_trick','v_illusion','v_hone','v_glow_up'} }
}

SMODS.Back { --Pat Fusty
    key = "pat_fusty",
    name = "Pat Fusty Deck",
	loc_txt = {
        name = 'Pat Fusty Deck',
        text = {
            '{C:attention}+#1#{} hand size'
        }
    },
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
    loc_txt = {
        name = 'Adora Deck',
        text = {
            'Sacrifice cards instead of',
            'selling them to upgrade level',
            'of {C:attention}#1# poker hands{}'
        }
    },
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
                { handname = localize(hand, 'poker_hands'),
                    chips = G.GAME.hands[hand].chips,
                    mult = G.GAME.hands[hand].mult,
                    level = G.GAME.hands[hand].level
                }
            )
            level_up_hand(card, hand)
            update_hand_text(
                {sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''}
            )
        end
        card:sell_card()
        SMODS.calculate_context({selling_card = true, card = card})
    end
}

SMODS.Back { --Brickell
    key = "brickell",
    name = "Brickell Deck",
	loc_txt = {
        name = 'Brickell Deck',
        text = {
            'Start on Ante {C:attention}#1#{}',
            'with {C:blue}+#2#{} hand',
            '{C:red}#3#{} discards'
        }
    },
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
	loc_txt = {
        name = 'Etienne Deck',
        text = {
            '{C:attention}+#1#{} Booster Pack slot'
        }
    },
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
	loc_txt = {
        name = 'Sauda Deck',
        text = {
            'Start run with all',
            '{C:attention}poker hands{} leveled up'
        }
    },
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
	loc_txt = {
        name = 'Psi Deck',
        text = {
            'All {C:attention}Boss Blinds{}',
            'are {C:attention}The Psychic{}'
        }
    },
	atlas = "Back",
	pos = { x = 2, y = 2 },
}

SMODS.Back { --Geraldo
    key = "geraldo",
    name = "Geraldo Deck",
	loc_txt = {
        name = 'Geraldo Deck',
        text = {
            'Start run with',
            '{C:attention,T:v_bloons_power_merchant}Power Merchant{} and',
            '{C:attention,T:v_crystal_ball}Crystal Ball{}'
        }
    },
	atlas = "Back",
	pos = { x = 3, y = 2 },
    config = { vouchers = {'v_bloons_power_merchant', 'v_crystal_ball'} }
}

SMODS.Back { --Corvus
    key = "corvus",
    name = "Corvus Deck",
	loc_txt = {
        name = 'Corvus Deck',
        text = {
            'Played cards give',
            '{C:attention}#1#{} mana when scored',
            'Consume {C:attention}#2#{} mana to',
            'create a {C:spectral}Spectral{} card',
        }
    },
	atlas = "Back",
	pos = { x = 4, y = 2 },
    config = { extra = { max_mana = 25, mana_per_card = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.mana_per_card, self.config.extra.max_mana } }
    end,

    apply = function(self)
        G.GAME.corvus_mana = { current_mana = 0, max_mana = self.config.extra.max_mana, mana_per_card = self.config.extra.mana_per_card }
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
	loc_txt = {
        name = 'Rosalia Deck',
        text = {
            'Toggle Rosalia\'s weapons',
            '{C:attention}Laser{}: {X:mult,C:white}X#1#{} Mult after scoring',
            '{C:blue}Grenade{}: {C:attention}Retrigger{} first card'
        }
    },
	atlas = "Back",
	pos = { x = 0, y = 3 },
    config = { extra = { Xmult = 1.2, retrigger = 1 } }, --Variables = Xmult = Xmult on odd hands, retrigger = retrigger count on even hands

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.Xmult } }
    end,
    apply = function (self, back)
        G.GAME.rosalia_weapon = "laser"
    end,
    calculate = function (self, back, context)
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
	loc_txt = {
        name = 'Silas Deck',
        text = {
            '{C:attention,T:m_bloons_frozen}Freeze #1#{} cards',
            'held in hand at',
            'end of round'
        }
    },
	atlas = "Back",
	pos = { x = 1, y = 3 },
    config = { extra = { number = 2 } },

    loc_vars = function (self, info_queue, card)
        return { vars = { self.config.extra.number } }
    end,
    calculate = function (self, back, context)
        if context.end_of_round and not context.individual and not context.repetition then
            local valid_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if v.ability.effect ~= 'Frozen_card' and not v.debuff then
                    valid_cards[#valid_cards+1] = v
                end
            end
            for i = 1, self.config.extra.number do
                if valid_cards[1] then
                    local frozen_card = pseudorandom_element(valid_cards, pseudoseed('silas'..G.GAME.round_resets.ante))
                    frozen_card:set_ability('m_bloons_frozen', nil, true)
                    for k, v in pairs(valid_cards) do
                        if v == frozen_card then
                            table.remove(valid_cards,i)
                            break
                        end
                    end
                end
            end
        end
    end
}