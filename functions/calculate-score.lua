function get_standard_ui()
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
		}
	}
end

SMODS.Scoring_Calculation({
	key = "bloons_dreadbloon",
	func = function(self, chips, mult, flames)
		return math.floor(math.min(0.3 * G.GAME.blind.chips, chips * mult) + 0.5)
	end,
	replace_ui = function(self) return get_standard_ui() end,
})

SMODS.Scoring_Calculation({
	key = "bloons_blastapopoulos",
	func = function(self, chips, mult, flames)
		local score = chips * mult
		local heat = 0

		if G.play and G.play.cards then
			local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play
				.cards)

			for i = 1, #G.play.cards do
				-- nullify the heat decreased from played frozen cards
				if G.play.cards[i].config.center == G.P_CENTERS.m_bloons_frozen then
					heat = heat + 3
				end

				local splashed = SMODS.always_scores(G.play.cards[i]) or next(find_joker('Splash')) or
					next(find_joker('Echosense Precision'))
				local unsplashed = SMODS.never_scores(G.play.cards[i])
				if not splashed then
					for _, card in pairs(scoring_hand) do
						if card == G.play.cards[i] then splashed = true end
					end
				end
				local effects = {}
				SMODS.calculate_context(
					{
						modify_scoring_hand = true,
						other_card = G.play.cards[i],
						full_hand = G.play.cards,
						scoring_hand =
							scoring_hand,
						in_scoring = true
					}, effects)
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
	replace_ui = function(self) return get_standard_ui() end,
})

local function get_diamondback_multiplier()
	local multiplier = 1
	if G.GAME and G.GAME.blind_on_deck == "Small" then
		multiplier = 3
	elseif G.GAME and G.GAME.blind_on_deck == "Big" then
		multiplier = 2
	else
		multiplier = 1
	end

	return multiplier
end

local diamondback_mult_parameter = SMODS.Scoring_Parameter({
	key = "diamondback_mult",
	default_value = 1,
	colour = HEX("D8AF48"),
})

SMODS.Scoring_Calculation({
	key = "bloons_diamondback",
	parameters = { "chips", "mult", diamondback_mult_parameter.key},
	func = function(self, chips, mult, flames)
		local diamondback_multiplier = get_diamondback_multiplier()
		if G.GAME and G.GAME.current_round and G.GAME.current_round.current_hand then
			G.GAME.current_round.current_hand[diamondback_mult_parameter.key] = diamondback_multiplier
		end
		return chips * mult * diamondback_multiplier
	end,
	update_ui = function(self)
		if G.GAME and G.GAME.current_round and G.GAME.current_round.current_hand then
			G.GAME.current_round.current_hand[diamondback_mult_parameter.key] = get_diamondback_multiplier()
		end
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
								{
									n = G.UIT.C,
									config = { align = "cm", id = "hand_chips_container" },
									nodes = {
										SMODS.GUI.score_container({
											type = "chips",
											text = "chip_text",
											align = "cr",
											scale = 0.3,
											w = 1.5,
											colour = G.C.CHIPS,
										}),
									},
								},
								SMODS.GUI.operator(0.35),
								{
									n = G.UIT.C,
									config = { align = "cm", id = "hand_mult_container" },
									nodes = {
										SMODS.GUI.score_container({
											type = "mult",
											scale = 0.3,
											w = 1.5,
											colour = G.C.MULT,
										}),
									},
								},
								SMODS.GUI.operator(0.35),
								{
									n = G.UIT.C,
									config = { align = "cm", id = "diamondback_multiplier_container" },
									nodes = {
										SMODS.GUI.score_container({
											type = diamondback_mult_parameter.key,
											w = 0.55,
											scale = 0.3,
											colour = HEX("D8AF48"),
										}),
									},
								},
							},
						},
					},
				},
			}
		}
	end
})
