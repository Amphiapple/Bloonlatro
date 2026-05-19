return {
	descriptions = {
		Joker = {
			j_bloons_desperado = {
                name = 'Desperado',
                text = {
                    '{C:attention}First #1#{} played',
                    'cards give {C:mult}+#2#{}',
                    'Mult when scored'
                }
			},
            j_bloons_quickdraw = {
                name = 'Quickdraw',
                text = {
                    '{C:attention}First #1#{} played cards',
                    'give {C:mult}+#2#{} Mult for',
                    'each unscoring card'
                }
            },
            j_bloons_standoff = {
                name = 'Standoff',
                text = {
                    '{C:attention}First #1#{} played cards',
                    'give {C:mult}+#2#{} Mult for',
                    'each card under',
                    '{C:attention}5{} played cards',
                }
            },
            j_bloons_big_iron = {
                name = 'Big Iron',
                text = {
                    '{C:mult}+#1#{} Mult if',
                    'scoring hand',
                    'contains a {C:attention}6{}'
                }
            },
            j_bloons_twin_sixes = {
                name = 'Twin Sixes',
                text = {
                    '{X:mult,C:white}X#1#{} Mult if',
                    'scoring hand contains',
                    'at least {C:attention}#2# 6{}s',
                }
            },
            j_bloons_the_blazing_sun = {
                name = 'The Blazing Sun',
                text = {
                    'Each played {C:attention}#2#{}',
                    'of {C:hearts}Hearts{} gives',
                    '{X:mult,C:white}X#1#{} Mult when scored',
                    '{s:0.8}Rank changes every round{}',
                }
            },
            j_bloons_eagle_eye = {
                name = 'Eagle Eye',
                text = {
                    '{C:attention}First #1#{} played cards',
                    'give {C:mult}+#2#{} Mult when scored,',
                    '{C:mult}+#3#{} if rank is {C:attention}#4#{}',
                    '{s:0.8}Rank changes every round{}',
                }
            },
            j_bloons_bullseye = {
                name = 'Bullseye',
                text = {
                    '{C:attention}First #1#{} played cards',
                    'give {C:mult}+#2#{} Mult when scored,',
                    '{C:mult}+#3#{} if rank is {C:attention}#4#{}',
                    '{s:0.8}Rank changes every round{}',
                }
            },
            j_bloons_deadeye = {
                name = 'Deadeye',
                text = {
                    'Played {C:attention}#1#s{} give',
                    '{X:mult,C:white}X#2#{} Mult when scored',
                    '{s:0.8}Rank changes every round{}',
                }
            },
            j_bloons_bounty_hunter = {
                name = 'Bounty Hunter',
                text = {
                    'Played {C:attention}#1#s{} give',
                    '{C:money}$#2#{} when scored',
                    '{s:0.8}Rank changes every round{}',
                }
            },
            j_bloons_golden_justice = {
                name = 'Golden Justice',
                text = {
                    '{C:attention}Gold Cards{} and {C:attention}Glass Cards{}',
                    "inherit each others' abilities",
                    'Both give {C:money}$#5#{} when destroyed',
                }
            },
            j_bloons_wanderer = {
                name = 'Wanderer',
                text = {
                    '{C:chips}+#1#{} Chips for each',
                    'empty {C:attention}Joker{} slot',
                    '{s:0.8}Wanderer included',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
                }
            },
            j_bloons_nomad = {
                name = 'Nomad',
                text = {
                    'This {C:attention}Joker{} gains {C:chips}+#1#{} Chips ',
                    'if {C:attention}poker hand{} is different from',
                    'the previous {C:attention}poker hand {C:inactive}#3#{}',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
                }
            },
            j_bloons_enforcer = {
                name = 'Enforcer',
                text = {
                    'This Joker gains {X:mult,C:white}X#1#{}',
                    'Mult if scoring hand',
                    'contains {C:attention}#2#{} cards',
                    '{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)'
                }
            },
            j_bloons_avenger = {
                name = 'Avenger',
                text = {
                    'This Joker gains {X:mult,C:white}X#1#{} Mult',
                    'if scoring hand contains',
                    'ranks in previous hand',
                    '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)',
                    '{C:inactive}(#3#){}',
                }
            },
            j_bloons_the_desert_phantom = {
                name = 'The Desert Phantom',
                text = {
                    '{C:spectral}Spectral{} cards may',
                    'appear in the shop,',
                    '{X:mult,C:white}X#1#{} Mult for each',
                    '{C:spectral}Spectral{} card used',
                    '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)',
                }
            },
		}
    }
}