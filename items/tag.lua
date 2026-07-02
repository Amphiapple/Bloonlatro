SMODS.Atlas {
    key = 'Tag',
    path = 'tags.png',
    px = 34,
    py = 34,
}

SMODS.Tag {
    key = 'cleansing',
    name = 'Cleansing Tag',
    
    atlas = 'Tag',
	pos = { x = 0, y = 0 },
    min_ante = nil,
    config = { type = 'immediate' },

	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.shared_sticker_eternal
		info_queue[#info_queue + 1] = G.P_CENTERS.shared_sticker_perishable
		info_queue[#info_queue + 1] = G.P_CENTERS.shared_sticker_rental
	end,
	in_pool = function (self, args)
		return G.GAME.stake >= 4
	end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
			local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
			tag:yep("+", G.C.PURPLE, function()
				local joker = G.jokers.cards[1]
				if joker then
					-- Remove stickers
                    joker:set_eternal(nil)
                    joker.ability.perishable = nil
                    joker:set_rental(nil)

					joker:set_debuff()
					joker:juice_up(1, 0.5)
				end
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
    end
}

SMODS.Tag {
    key = 'invisible',
    name = 'Invisible Tag',
    atlas = 'Tag',
	pos = { x = 1, y = 0 },
    min_ante = 2,
    config = { type = 'eval' },

    apply = function(self, tag, context)
        if context.type == 'eval' then
			if G.GAME.last_blind and G.GAME.last_blind.boss then
				local lock = tag.ID
            	G.CONTROLLER.locks[lock] = true
				tag:yep("+", G.C.PURPLE, function()
					if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit and #G.jokers.cards > 0 then
						local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('invisible'..G.GAME.round_resets.ante))
						local card = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
						card:add_to_deck()
						G.jokers:emplace(card)
					end
					G.CONTROLLER.locks[lock] = nil
					return true
				end)
				tag.triggered = true
				return {
                    dollars = 0,
                    condition = localize('ph_defeat_the_boss'),
                }
			end
		end
    end
}

SMODS.Tag {
    key = 'power',
    name = 'Power Tag',
    
    atlas = 'Tag',
	pos = { x = 2, y = 0 },
    min_ante = 2,
    config = {type = 'new_blind_choice' },

    loc_vars = function(self, info_queue)
		info_queue[#info_queue+1] = G.P_CENTERS.p_bloons_power_mega_1
	end,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
			local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
			tag:yep("+", G.C.Power, function()
				local key = "p_bloons_power_mega_1"
				local card = Card(
					G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
					G.CARD_W * 1.27,
					G.CARD_H * 1.27,
					G.P_CARDS.empty,
					G.P_CENTERS[key],
					{ bypass_discovery_center = true, bypass_discovery_ui = true }
				)
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
    end
}

SMODS.Tag {
    key = 'sabotage',
    name = 'Sabotage Tag',
    
    atlas = 'Tag',
	pos = { x = 3, y = 0 },
    min_ante = nil,
    config = { type = 'round_start_bonus', percent = 50 }, --Variables: percent = blind reduction percent

    loc_vars = function(self, info_queue)
		return { vars = { self.config.percent } }
	end,
    apply = function(self, tag, context)
        if context.type == 'round_start_bonus' then
			local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
			tag:yep("+", G.C.BLUE, function()
				G.GAME.blind.chips = G.GAME.blind.chips - G.GAME.blind.chips * tag.config.percent / 100.0
				G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
				G.GAME.blind:wiggle()
				if G.GAME.blind.name ~= 'bl_mp_nemesis' then
					G.E_MANAGER:add_event(Event({
						trigger = "immediate",
						func = function()
							if G.GAME.chips/G.GAME.blind.chips >= to_big(1) and G.STATE == G.STATES.SELECTING_HAND then
								G.GAME.current_round.semicolon = true
								G.STATE = G.STATES.HAND_PLAYED
								G.STATE_COMPLETE = true
								end_round()
								return true
							end
							return false
						end,
					}), "other")
				end
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
    end
}

SMODS.Tag {
    key = 'redeemed',
    name = 'Redeemed Tag',
    atlas = 'Tag',
	pos = { x = 4, y = 0 },
    min_ante = 2,
    config = { type = 'voucher_add' },

    apply = function(self, tag, context)
        if context.type == 'voucher_add' then
			local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
			tag:yep('+', G.C.SECONDARY_SET.Voucher,function()
				local pool, pool_key = get_current_pool('Voucher'), 'Voucher_fromtag'
				local upgraded = {}
				for k, v in ipairs(pool) do
					if G.P_CENTERS[v] and G.P_CENTERS[v].requires then
						upgraded[#upgraded+1] = v
					end
				end
				if #upgraded > 0 then
					local voucher_key = pseudorandom_element(upgraded, pseudoseed(pool_key..G.GAME.round_resets.ante))
					G.ARGS.voucher_tag = G.ARGS.voucher_tag or {}
					G.ARGS.voucher_tag[voucher_key] = true
					G.shop_vouchers.config.card_limit = G.shop_vouchers.config.card_limit + 1
					local card = Card(G.shop_vouchers.T.x + G.shop_vouchers.T.w/2,
					G.shop_vouchers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[voucher_key],{bypass_discovery_center = true, bypass_discovery_ui = true})
					card.from_tag = true
					create_shop_card_ui(card, 'Voucher', G.shop_vouchers)
					card:start_materialize()
					G.shop_vouchers:emplace(card)
					end
				G.ARGS.voucher_tag = nil
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
    end
}

SMODS.Tag {
    key = 'concoction',
    name = 'Concoction Tag',
    atlas = 'Tag',
	pos = { x = 5, y = 0 },
    min_ante = nil,
    config = { type = 'immediate' },

    loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
		info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
	end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
			local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
			tag:yep("+", G.C.PURPLE, function()
				local eligible_jokers = {}
				for k, v in pairs(G.jokers.cards) do
					if v.ability.set == 'Joker' and not v.edition then
						table.insert(eligible_jokers, v)
					end
				end
				if #eligible_jokers > 0 then
					local joker = pseudorandom_element(eligible_jokers, pseudoseed('brew'..G.GAME.round_resets.ante))
					if joker then
						local edition = poll_edition('wheel_of_fortune', nil, nil, true)
						joker:set_edition(edition, true)
					end
				end
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
    end
}