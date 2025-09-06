SMODS.Scoring_Calculation({
	key = "bloons_dreadbloon",
	func = function(self, chips, mult, flames)
		return math.floor(math.min(0.3 * G.GAME.blind.chips, chips * mult) + 0.5)
	end,
    replace_ui = function(self)
		return {
			n = G.UIT.R,
			config = { minh = 1.2, align = "cm" },
			nodes = {
				{
					n = G.UIT.C,
					config = { align = "cm" },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm", minh = 1, padding = 0.1 },
							nodes = {

								-- Chips box
								{
									n = G.UIT.C,
									config = { align = "cm", id = "hand_chips_container" },
									nodes = {
										SMODS.GUI.score_container({
											type = "chips",
											text = "chip_text",
											align = "cr",
											colour = G.C.CHIPS,
										}),
									},
								},

                                -- Operator
								SMODS.GUI.operator(0.4),

								-- Mult box
								{
									n = G.UIT.C,
									config = { align = "cm", id = "hand_mult_container" },
									nodes = {
										SMODS.GUI.score_container({
											type = "mult",
											colour = G.C.MULT,
										}),
									},
								},
							},
						},
					},
				},
			},
		}
	end,
})

SMODS.Scoring_Calculation({
	key = "bloons_blastapopoulos",
	func = function(self, chips, mult, flames)
        local score = chips * mult
        local heat = 0

        if G.play and G.play.cards then
            local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)

            for i=1, #G.play.cards do
				-- nullify the heat decreased from played frozen cards
				if G.play.cards[i].config.center == G.P_CENTERS.m_bloons_frozen then
					heat = heat + 3
				end
				
                local splashed = SMODS.always_scores(G.play.cards[i]) or next(find_joker('Splash'))
                local unsplashed = SMODS.never_scores(G.play.cards[i])
                if not splashed then
                    for _, card in pairs(scoring_hand) do
                        if card == G.play.cards[i] then splashed = true end
                    end
                end
                local effects = {}
                SMODS.calculate_context({modify_scoring_hand = true, other_card =  G.play.cards[i], full_hand = G.play.cards, scoring_hand = scoring_hand, in_scoring = true}, effects)
                local flags = SMODS.trigger_effects(effects, G.play.cards[i])
                if flags and flags.add_to_hand then splashed = true end
                if flags and flags.remove_from_hand then unsplashed = true end
                if splashed and not unsplashed then 
                    if G.play.cards[i].config.center == G.P_CENTERS.m_bloons_meteor then
                        heat = heat + 3
					else
                        heat = heat + 1
                    end
                end
            end
        end

        -- Needed to count frozen cards before a hand is played due to the frozen cards unfreezing too soon otherwise
        if G.STATE and G.STATE == G.STATES.SELECTING_HAND then
            self.frozen = 0
            for _, card in ipairs(G.hand.cards) do
                if card.config.center == G.P_CENTERS.m_bloons_frozen then
                    self.frozen = self.frozen + 1
                end
            end
        end

        if self.frozen then
            heat = heat - 3 * self.frozen
        end

        if heat < 0 then heat = 0 end
        if heat > 10 then heat = 10 end

        local reduction = heat * 0.1
        local reduced_score = score * (1 - reduction)

        return math.floor(reduced_score + 0.5)
    end,
    replace_ui = function(self)
		return {
			n = G.UIT.R,
			config = { minh = 1.2, align = "cm" },
			nodes = {
				{
					n = G.UIT.C,
					config = { align = "cm" },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm", minh = 1, padding = 0.1 },
							nodes = {

								-- Chips box
								{
									n = G.UIT.C,
									config = { align = "cm", id = "hand_chips_container" },
									nodes = {
										SMODS.GUI.score_container({
											type = "chips",
											text = "chip_text",
											align = "cr",
											colour = G.C.CHIPS,
										}),
									},
								},

                                -- Operator
								SMODS.GUI.operator(0.4),

								-- Mult box
								{
									n = G.UIT.C,
									config = { align = "cm", id = "hand_mult_container" },
									nodes = {
										SMODS.GUI.score_container({
											type = "mult",
											colour = G.C.MULT,
										}),
									},
								},
							},
						},
					},
				},
			},
		}
	end,
})