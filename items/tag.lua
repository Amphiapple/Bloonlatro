SMODS.Atlas {
    key = 'Tag',
    path = 'tags.png',
    px = 34,
    py = 34,
}

SMODS.Tag {
    key = 'cleansing',
    name = 'Cleansing Tag',
    loc_txt = {
        name = 'Cleansing Tag',
        text = {
            'Shop has a free',
            '{C:attention}Stickerless{} Joker',
        }
    },
    atlas = 'Tag',
	pos = { x = 0, y = 0 },
	order = 25,
    min_ante = nil,
    config = { type = 'store_joker_modify' },

    loc_vars = function(self, info_queue)
		return { vars = { self.config.percent } }
	end,
    apply = function(self, tag, context)
        if context.type == 'store_joker_modify' and context.card.ability.set == 'Joker' then
			local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
			tag:yep('+', G.C.DARK_EDITION, function() 
				context.card.ability.couponed = true
				-- Remove stickers
				context.card:set_eternal(nil)
				context.card.ability.perishable = nil
				context.card:set_rental(nil)
				-- Remove Bunco stickers
				context.card:set_scattering(nil)
				context.card:set_hindered(nil)
				context.card:set_reactive(nil)
				
				context.card:set_cost()
				context.card:juice_up(1, 0.5)
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
    loc_txt = {
        name = 'Invisible Tag',
        text = {
            '{C:attention}Duplicates{} a',
            'random {C:attention}Joker{}',
			'{C:inactive}(Must have room)',
        }
    },
    atlas = 'Tag',
	pos = { x = 1, y = 0 },
	order = 26,
    min_ante = 2,
    config = { type = 'immediate' },

    apply = function(self, tag, context)
        if context.type == 'immediate' then
			local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
			tag:yep("+", G.C.PURPLE, function()
				if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit and #G.jokers.cards > 0 then
					local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('invisible'))
					local card = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
					card:add_to_deck()
					G.jokers:emplace(card)
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
    key = 'power',
    name = 'Power Tag',
    loc_txt = {
        name = 'Power Tag',
        text = {
            'Gives a free',
            '{C:power}Mega Power Pack{}',
        }
    },
    atlas = 'Tag',
	pos = { x = 2, y = 0 },
	order = 27,
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
    loc_txt = {
        name = 'Sabotage Tag',
        text = {
            'Reduces {C:attention}Blind{}',
            'requirement by {C:attention}#1#%{}',
			'next round'
        }
    },
    atlas = 'Tag',
	pos = { x = 3, y = 0 },
	order = 28,
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
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
    end
}

SMODS.Tag {
    key = 'Redeemed',
    name = 'Redeemed Tag',
    loc_txt = {
        name = 'Redeemed Tag',
        text = {
            'Adds one {C:attention}Upgraded{}',
			'{C:voucher}Voucher{} to the next shop',
        	'{C:inactive}(Must be available)',
        }
    },
    atlas = 'Tag',
	pos = { x = 4, y = 0 },
	order = 29,
    min_ante = nil,
    config = { type = 'voucher_add' },

    loc_vars = function(self, info_queue)
		return { vars = { self.config.percent } }
	end,
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
					local voucher_key = pseudorandom_element(upgraded, pseudoseed(pool_key))
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
    loc_txt = {
        name = 'Concoction Tag',
        text = {
            'Adds {C:dark_edition}Foil{}, {C:dark_edition}Holographic{},',
            '{C:dark_edition}Polychrome{}, or {C:dark_edition}Negative{} edition',
            'to a random {C:attention}Joker',
		}
    },
    atlas = 'Tag',
	pos = { x = 5, y = 0 },
	order = 30,
    min_ante = 2,
    config = { type = 'immediate' },

    loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
		info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return { vars = { self.config.percent } }
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
				local joker = pseudorandom_element(eligible_jokers, pseudoseed('brew'))
				if joker then
					local edition = poll_edition('wheel_of_fortune', nil, nil, true)
					joker:set_edition(edition, true)
				end
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
    end
}