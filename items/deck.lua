SMODS.Atlas{
    key = 'Back',
    path = 'decks.png',
    px = 71,
    py = 95,
}

SMODS.Back { --Quincy Deck
    name = "Quincy Deck",
	key = "quincy",
	loc_txt = {
        name = 'Quincy Deck',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'halve Chips',
            '{C:mult}X#3#{} base Blind size',
        }
    },
	order = 17,
	atlas = "Back",
	pos = { x = 0, y = 0 },
    unlocked = true,

    config = { extra = { odds = 4}, ante_scaling = 0.75 },
    loc_vars = function(self, info_queue, center)
		return { vars = { G.GAME.probabilities.normal or 1, self.config.extra.odds, self.config.ante_scaling } }
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step then
			if pseudorandom('cry_critical') < G.GAME.probabilities.normal/self.config.extra.odds then
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
	end,
}

SMODS.Back { --Gwen Deck
    name = "Gwendolin Deck",
	key = "gwen",
	loc_txt = {
        name = 'Gwendolin Deck',
        text = {
            'Start run with',
            'an {C:spectral}Immolate{} card',
            '{C:attention}-1{} hand size',
        }
    },
	order = 18,
	atlas = "Back",
	pos = { x = 1, y = 0 },
    unlocked = true,

    config = { consumables = {'c_immolate'}, hand_size = -1 },
}

SMODS.Back { --Striker Deck
    name = "Striker Deck",
	key = "striker",
	loc_txt = {
        name = 'Striker Deck',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'each card in your deck',
            'to start as {C:spades}Spades{}',
        }
    },
	order = 19,
	atlas = "Back",
	pos = { x = 2, y = 0 },
    unlocked = true,
    
    config = { extra = {odds = 3} },
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

SMODS.Back { --Obyn Deck
    name = "Obyn Deck",
	key = "obyn",
	loc_txt = {
        name = 'Obyn Deck',
        text = {
            'Start run with {C:money}Seed Money{}',
            'and {C:money}Money Tree{}',
        }
    },
	order = 20,
	atlas = "Back",
	pos = { x = 3, y = 0 },
    unlocked = true,

    config = { vouchers = {'v_seed_money','v_money_tree'}},
    
}

SMODS.Back { --Church Deck
    name = "Churchill Deck",
	key = "church",
	loc_txt = {
        name = 'Churchill Deck',
        text = {
            '{X:mult,C:white}X2{} Mult against',
            '{C:attention}Boss Blinds{}',
        }
    },
	order = 21,
	atlas = "Back",
	pos = { x = 4, y = 0 },
    unlocked = true,

    config = { extra = { Xmult = 2 } },
    calculate = function(self, card, context)
		if G.GAME.blind.boss then
            if context.final_scoring_step then
                mult = mod_mult(mult * 2)
                update_hand_text( { delay = 0 }, { mult = mult } )
                G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("multhit2", 1)
                        attention_text({
							scale = 1.4,
							text = "Try This!",
                            color = G.C.MULT,
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
	end,
}

SMODS.Back { --Ben Deck
    name = "Benjamin Deck",
	key = "ben",
	loc_txt = {
        name = 'Benjamin Deck',
        text = {
            '{C:money}+$#1#{} Blind reward',
            '{C:money}+$#2# {C:attention}Boss Blind{} reward',
            '{C:inactive}unimplemented{}',
        }
    },
	order = 22,
	atlas = "Back",
	pos = { x = 0, y = 1 },
    unlocked = true,

    config = { extra = {money = 1, boss_money = 2} },
    loc_vars = function(self, info_queue, center)
		return { vars = { self.config.extra.money, self.config.extra.boss_money } }
	end,
    calc_dollar_bonus = function(self, card)
        if G.GAME.blind.boss then
            return self.config.extra.boss_money
        else
            return self.config.extra.money
        end
    end,
}

SMODS.Back { --Ezili Deck
    name = "Ezili Deck",
	key = "ezili",
	loc_txt = {
        name = 'Ezili Deck',
        text = {
            '{C:spectral}Spectral{} packs appear ',
            '{C:attention}2x{} more frequently',
            'in the shop',
            'Start run with a {C:spectral}Hex{} card',
            '{C:inactive}unimplemented{}',
        }
    },
	order = 23,
	atlas = "Back",
	pos = { x = 1, y = 1 },
    unlocked = true,
    
    config = { consumables = {'c_hex'} },

}

SMODS.Back { --Pat Deck
    name = "Pat Fusty Deck",
	key = "pat",
	loc_txt = {
        name = 'Pat Fusty Deck',
        text = {
            '{C:attention}+1{} hand size',
        }
    },
	order = 24,
	atlas = "Back",
	pos = { x = 2, y = 1 },
    unlocked = true,

    config = { hand_size = 1 },
}

SMODS.Back { --Adora Deck
    name = "Adora Deck",
	key = "adora",
	loc_txt = {
        name = 'Adora Deck',
        text = {
            'Selling cards sacrifices',
            'them to level up a random',
            '{C:attention}poker hand{} instead',
            '{C:inactive}unimplemented{}',
        }
    },
	order = 25,
	atlas = "Back",
	pos = { x = 3, y = 1 },
    unlocked = true,

    config = {  },
    calculate = function(self, card, context)
        if context.selling_card then
            local visible = {}
            for k, v in pairs(G.handlist) do
                if G.GAME.hands[v].visible then
				    table.insert(visible, v)
                end
			end
            level_up_hand(self, pseudorandom_element(visible, pseudoseed('')), true)
            
        end
    end,
}

SMODS.Back { --Brick Deck
    name = "Brickell Deck",
	key = "brick",
	loc_txt = {
        name = 'Brickell Deck',
        text = {
            'Start on Ante {C:attention}0{} with',
            '{C:blue}+1{} hand and {C:red}0{} discards',
        }
    },
	order = 26,
	atlas = "Back",
	pos = { x = 4, y = 1 },
    unlocked = true,

    config = { extra = { ante = 0 }, hands = 1, discards = -3 },
    apply = function(self)
        ease_ante(self.config.extra.ante - 1)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = self.config.extra.ante
    end
}

SMODS.Back { --French Deck
    name = "Etienne Deck",
	key = "french",
	loc_txt = {
        name = 'Etienne Deck',
        text = {
            '{C:attention}+#1#{} Booster Pack slot',
        }
    },
	order = 27,
	atlas = "Back",
	pos = { x = 0, y = 2 },
    unlocked = true,

    config = { extra = {booster_slots = 1} },
    loc_vars = function(self, info_queue, center)
        return { vars = {self.config.extra.booster_slots} }
    end,
    apply = function(self)
        SMODS.change_booster_limit(self.config.extra.booster_slots)
    end,
}

SMODS.Back { --Sauda Deck
    name = "Sauda Deck",
	key = "sauda",
	loc_txt = {
        name = 'Sauda Deck',
        text = {
            'Start run with all',
            '{C:attention}poker hands{} leveled up',
        }
    },
	order = 28,
	atlas = "Back",
	pos = { x = 1, y = 2 },
    unlocked = true,

    config = { },
    apply = function(self)
        for k, v in pairs(G.GAME.hands) do
            level_up_hand(self, k, true)
        end
    end,
}

SMODS.Back { --Psi Deck
    name = "Psi Deck",
	key = "psi",
	loc_txt = {
        name = 'Psi Deck',
        text = {
            'All {C:attention}Boss Blinds{} are {C:attention}The Psychic{}',
            '{C:inactive}unimplemented{}',
        }
    },
	order = 29,
	atlas = "Back",
	pos = { x = 2, y = 2 },
    unlocked = true,

    config = { },
}

SMODS.Back { --Gerry Deck
    name = "Geraldo Deck",
	key = "gerry",
	loc_txt = {
        name = 'Geraldo Deck',
        text = {
            '{C:red}G{C:green}a{C:blue}y{}',
        }
    },
	order = 30,
	atlas = "Back",
	pos = { x = 3, y = 2 },
    unlocked = true,

    config = { },
}

SMODS.Back { --Corvus Deck
    name = "Corvus Deck",
	key = "corvus",
	loc_txt = {
        name = 'Corvus Deck',
        text = {
            'Earn {C:attention}1{} mana for each',
            'played card that scores',
            'Enables Corvus\' {C:spectral}Spellbook{}',
            '{C:inactive}unimplemented{}',
        }
    },
	order = 31,
	atlas = "Back",
	pos = { x = 4, y = 2 },
    unlocked = true,

    config = { },
}

SMODS.Back { --Rose Deck
    name = "Rosalia Deck",
	key = "rose",
	loc_txt = {
        name = 'Rosalia Deck',
        text = {
            '{C:tarot}Tarot{} cards and',
            '{C:attention}Arcana{} packs cost {C:money}$1{} less',
            '{C:inactive}unimplemented{}',
        }
    },
	order = 32,
	atlas = "Back",
	pos = { x = 0, y = 3 },
    unlocked = true,

    config = { },
}