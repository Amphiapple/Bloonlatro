return {
	descriptions = {
		Joker = {
			j_bloons_skywarden = {
				name = 'Skywarden',
				text = {
					'{C:mult}+#1#{} Mult',
					'{C:mult}+#2#{} Mult after each hand',
                    'played this round',
				}
			},
			j_bloons_aerial_attunement = {
				name = "Aerial Attunement",
				text = {
					'{C:mult}+#1#{} Mult',
					'{C:mult}+#2#{} Mult after each hand',
                    'played this round',
				}
			},
			j_bloons_zephyr_sense = {
				name = 'Zephyr Sense',
				text = {
					'{C:mult}+#1#{} Mult',
					'{C:mult}+#2#{} Mult after each hand',
                    'played this ante',
				}
			},
            j_bloons_wind_weaver = {
				name = 'Wind Weaver',
				text = {
					'Each played card this round',
					'gives {C:mult}+#1#{} more Mult when scored',
					'and retriggers above {C:mult}+#2#{} Mult',
					'{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult){}'
				}
			},
			j_bloons_galesage = {
				name = 'Galesage',
				text = {
					'Retrigger all played',
					'cards if scoring hand',
                    'contains {C:attention}#1#{} cards',
				}
			},
			j_bloons_farwind_seer = {
				name = 'Farwind Seer',
				text = {
					'Retrigger all played',
					'cards once for each',
					'empty {C:attention}Joker{} slot',
                    '{C:inactive}(Currently {C:attention}#1#{C:inactive} retriggers){}',
				}
			},
			j_bloons_storms_pulse = {
				name = "Storm's Pulse",
				text = {
					'{C:mult}+#1#{} Mult',
					'{C:mult}+#2#{} Mult after each hand',
                    'played this round',
				}
			},
			j_bloons_thundering_arc = {
				name = 'Thundering Arc',
				text = {
					'{C:mult}+#1#{} Mult',
					'{C:mult}+#2#{} Mult after each card',
                    'scored this round',
				}
			},
            j_bloons_galvanic_conduit = {
				name = 'Galvanic Conduit',
				text = {
					'Each played card this round',
					'gives {C:mult}+#1#{} more Mult when scored',
					'and is {C:attention}Stunned{} above {C:mult}+#2#{} Mult',
					'{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult){}'
				}
			},
			j_bloons_thunders_decree = {
				name = "Thunder's Decree",
				text = {
					'Stun the last card',
					'in scoring hand',
					'Stunned cards give',
					'{X:mult,C:white}X#1#{} Mult when scored',
				}
			},
			j_bloons_stormwrath_archon = {
				name = 'Stormwrath Archon',
				text = {
					'Stunned cards give',
					'{X:mult,C:white}X#1#{} Mult when scored',
					'Adjacent cards give',
					'{C:mult}+#2#{} Mult when scored',
				}
			},
			j_bloons_shatterpoint = {
				name = 'Shatterpoint',
				text = {
					'{C:mult}+#1#{} Mult',
					'Destroy all played',
					'{C:attention}Frozen Cards{} with',
					'rank less than {C:attention}#2#{}'
				}
			},
			j_bloons_icebore = {
				name = 'Icebore',
				text = {
					'{C:mult}+#1#{} Mult',
					'{C:attention}Frozen Cards{} give',
					'{C:mult}+#2#{} Mult when held'
				}
			},
			j_bloons_coldchain = {
				name = 'Coldchain',
				text = {
					'Each played card this round',
					'gives {C:chips}+#1#{} more Chips when scored',
					'and is {C:attention}Frozen{} above {C:chips}+#2#{} Chips',
					'{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips){}'
				}
			},
			j_bloons_frozen_verdict = {
				name = 'Frozen Verdict',
				text = {
					'This {C:attention}Joker{} gains',
                    '{X:mult,C:white}X#1#{} Mult whenever a',
                    '{C:attention}Frozen Card{} is destroyed',
                    '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
				}
			},
			j_bloons_winters_mercy = {
				name = "Winter's Mercy",
				text = {
                    '{X:mult,C:white}X#1#{} Mult for each',
					'{C:attention}Frozen Cards{} in your {C:attention}full deck{}',
                    '{X:mult,C:white}X#2#{} Mult for each destroyed',
                    '{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)'
				}
			},
		}
	}
}
