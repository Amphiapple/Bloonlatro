--Psi function
local get_boss_old = get_new_boss
get_new_boss = function()
    local ret = get_boss_old()
    if G.GAME.selected_back.name ~= 'Psi Deck' or G.GAME.round_resets.ante%G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2 then
        return ret
    else
        return "bl_psychic"
    end
end

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
    config = { extra = { odds = 4 }, ante_scaling = 0.75 },

    loc_vars = function(self, info_queue, center)
		return { vars = { G.GAME.probabilities.normal or 1, self.config.extra.odds, self.config.ante_scaling } }
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step and pseudorandom('cry_critical') < G.GAME.probabilities.normal/self.config.extra.odds then
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

SMODS.Back { --Striker
    key = "striker",    
    name = "Striker Deck",
	loc_txt = {
        name = 'Striker Deck',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'each card in your deck',
            'to start as {C:spades}Spades{}'
        }
    },
	atlas = "Back",
	pos = { x = 2, y = 0 },
	order = 19,
    config = { extra = { odds = 3 } },

    loc_vars = function(self, info_queue, center)
		return { vars = { G.GAME.probabilities.normal or 1, self.config.extra.odds - 1 } }
	end,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if pseudorandom('erratic') < G.GAME.probabilities.normal/self.config.extra.odds then
                        v:change_suit('Spades')
                    end
                end
            return true
            end
        }))
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
    config = { vouchers = {'v_seed_money','v_money_tree'}}
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

    loc_vars = function(self, info_queue, center)
		return { vars = { self.config.extra.Xmult } }
	end,
    calculate = function(self, card, context)
		if G.GAME.blind.boss and context.final_scoring_step then
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
            '{C:money}+$#1#{} each round',
            '{C:money}+$#2# on {C:attention}Boss Blinds{}',
            '{C:inactive}unimplemented{}'
        }
    },
	atlas = "Back",
	pos = { x = 0, y = 1 },
    order = 22,
    config = { extra = { money = 1, boss_money = 2 } },

    loc_vars = function(self, info_queue, center)
		return { vars = { self.config.extra.money, self.config.extra.boss_money } }
	end
}

SMODS.Back { --Ezili
    key = "ezili",
    name = "Ezili Deck",
	loc_txt = {
        name = 'Ezili Deck',
        text = {
            '{C:spectral}Spectral{} packs appear ',
            '{C:attention}2x{} more frequently',
            'in the shop',
            'Start run with a {C:spectral}Hex{} card',
            '{C:inactive}unimplemented{}'
        }
    },
	atlas = "Back",
	pos = { x = 1, y = 1 },
    order = 23,
    config = { consumables = {'c_hex'} }
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

    loc_vars = function(self, info_queue, center)
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

    calculate = function(self, card, context)
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
            'Start on Ante {C:attention}#1#{} with',
            '{C:blue}+#2#{} hand and {C:red}#3#{} discards'
        }
    },
	atlas = "Back",
	pos = { x = 4, y = 1 },
    order = 26,
    config = { extra = { ante = 0 }, hands = 1, discards = -3 },

    loc_vars = function(self, info_queue, center)
        return { vars = { self.config.extra.ante, self.config.hands, 3 + self.config.discards } }
    end,
    apply = function(self)
        ease_ante(self.config.extra.ante - 1)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = self.config.extra.ante
    end
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

    loc_vars = function(self, info_queue, center)
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
            'All {C:attention}Boss Blinds{} are {C:attention}The Psychic{}'
        }
    },
	atlas = "Back",
	pos = { x = 2, y = 2 },
    order = 29
}

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
            'Switch between {X:mult,C:white}X#1#{} Mult and',
            'retriggering {C:attention}first{} played',
            'card each hand',
            '{C:inactive}unimplemented{}'
        }
    },
	atlas = "Back",
	pos = { x = 0, y = 3 },
    order = 32
}