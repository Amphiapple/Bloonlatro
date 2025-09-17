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
    order = 17,
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

SMODS.Back { --Gwen
    key = "gwen",
    name = "Gwendolin Deck",
	loc_txt = {
        name = 'Gwendolin Deck',
        text = {
            'Start run with',
            'an {C:spectral}Immolate{} card',
            '{C:attention}-1{} hand size'
        }
    },
	atlas = "Back",
	pos = { x = 1, y = 0 },
    order = 18,
    config = { consumables = {'c_immolate'}, hand_size = -1 }
}

SMODS.Back { --Jones
    key = "jones",
    name = "Jones Deck",
	loc_txt = {
        name = 'Jones Deck',
        text = {
            '{C:attention}Stun{} all {C:spades}Spades{}',
            'when drawn to hand'
        }
    },
	atlas = "Back",
	pos = { x = 2, y = 0 },
	order = 19,

    calculate = function(self, back, context)
        if context.hand_drawn then
            for k, v in pairs(G.hand.cards) do
                if v:is_suit('Spades') and v.ability.name ~= 'Stunned Card' then
                    v:set_ability(G.P_CENTERS.m_bloons_stunned, nil, true)
                    v:juice_up()
                end
            end
        end
    end
}

SMODS.Back { --Obyn
    key = "obyn",
    name = "Obyn Deck",
	loc_txt = {
        name = 'Obyn Deck',
        text = {
            'Start run with {C:money}Seed Money{}',
            'and {C:money}Money Tree{}'
        }
    },
	atlas = "Back",
	pos = { x = 3, y = 0 },
    order = 20,
    config = { vouchers = {'v_seed_money','v_money_tree'} }
}

SMODS.Back { --Church
    key = "church",
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
    order = 21,
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

SMODS.Back { --Ben
    key = "ben",
    name = "Benjamin Deck",
	loc_txt = {
        name = 'Benjamin Deck',
        text = {
            'Start with {C:attention}Monkey Bank{}',
            'and extra {C:money}$#1#'
        }
    },
	atlas = "Back",
	pos = { x = 0, y = 1 },
    order = 22,
    config = { jokers = {'j_bloons_bank'}, dollars = 1 },

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
            '{C:attention}Magic Trick{}, {C:enhanced}Illusion{},',
            '{C:dark_edition}Hone{}, and {C:dark_edition}Glow Up{}'
            
        }
    },
	atlas = "Back",
	pos = { x = 1, y = 1 },
    order = 23,
    config = { vouchers = {'v_magic_trick','v_illusion','v_hone','v_glow_up'} }
}

SMODS.Back { --Pat
    key = "pat",
    name = "Pat Fusty Deck",
	loc_txt = {
        name = 'Pat Fusty Deck',
        text = {
            '{C:attention}+#1#{} hand size'
        }
    },
	atlas = "Back",
	pos = { x = 2, y = 1 },
    order = 24,
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
            'Selling cards sacrifices',
            'them to level up a random',
            '{C:attention}poker hand{} instead'
        }
    },
	atlas = "Back",
	pos = { x = 3, y = 1 },
    order = 25,

    calculate = function(self, back, context)
        if context.selling_card then
            context.card.sell_cost = 0
            local visible = {}
            for k, v in pairs(G.handlist) do
                if G.GAME.hands[v].visible then
				    table.insert(visible, v)
                end
			end
            local hand = pseudorandom_element(visible, pseudoseed(''))
            update_hand_text(
                { sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                { handname = localize(hand, 'poker_hands'),
                    chips = G.GAME.hands[hand].chips,
                    mult = G.GAME.hands[hand].mult,
                    level = G.GAME.hands[hand].level
                }
            )
            level_up_hand(context.card, hand)
            update_hand_text(
                {sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''}
            )
        end
    end
}

SMODS.Back { --Brick
    key = "brick",
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
    order = 26,
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

SMODS.Back { --French
    key = "french",
    name = "Etienne Deck",
	loc_txt = {
        name = 'Etienne Deck',
        text = {
            '{C:attention}+#1#{} Booster Pack slot'
        }
    },
	atlas = "Back",
	pos = { x = 0, y = 2 },
    order = 27,
    config = { extra = { booster_slots = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.booster_slots } }
    end,
    apply = function(self)
        SMODS.change_booster_limit(self.config.extra.booster_slots)
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
    order = 28,

    apply = function(self)
        for k, v in pairs(G.GAME.hands) do
            level_up_hand(self, k, true)
        end
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
    order = 29
}

--[[
SMODS.Back { --Gerry
    key = "gerry",
    name = "Geraldo Deck",
	loc_txt = {
        name = 'Geraldo Deck',
        text = {
            '{C:red}G{C:green}a{C:blue}y{}'
        }
    },
	atlas = "Back",
	pos = { x = 3, y = 2 },
    order = 30
}

SMODS.Back { --Corvus
    key = "corvus",
    name = "Corvus Deck",
	loc_txt = {
        name = 'Corvus Deck',
        text = {
            'Earn {C:attention}1{} mana for each',
            'played card that scores',
            "Enables Corvus' {C:spectral}Spellbook{}",
            '{C:inactive}unimplemented{}'
        }
    },
	atlas = "Back",
	pos = { x = 4, y = 2 },
    order = 31
}

SMODS.Back { --Rose
    key = "rose",
    name = "Rosalia Deck",
	loc_txt = {
        name = 'Rosalia Deck',
        text = {
            'Switch between {X:mult,C:white}X1{} Mult and',
            'retriggering {C:attention}first{} played',
            'card each hand',
            '{C:inactive}unimplemented{}'
        }
    },
	atlas = "Back",
	pos = { x = 0, y = 3 },
    order = 32
}
]]

SMODS.Back { --Silas
    key = "silas",
    name = "Silas Deck",
	loc_txt = {
        name = 'Silas Deck',
        text = {
            'After {C:attention}Blind{} is defeated,',
            '{C:attention}Freeze #1#{} cards in your deck',
        }
    },
	atlas = "Back",
	pos = { x = 1, y = 3 },
    order = 33,
    config = { extra = { number = 3 } },

    loc_vars = function (self, info_queue, card)
        return { vars = { self.config.extra.number } }
    end,
    calculate = function (self, back, context)
        if context.end_of_round and not context.individual and not context.repetition then
            local valid_cards = {}
            for k, v in ipairs(G.playing_cards) do
                if v.ability.effect ~= 'Frozen_card' then
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