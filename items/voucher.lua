SMODS.Atlas {
    key = 'Voucher',
    path = 'vouchers.png',
    px = 71,
    py = 95,
}

SMODS.Voucher { --Power Merchant
    key = 'power_merchant',
    name = 'Power Merchant',
	atlas = 'Voucher',
	pos = { x = 0, y = 0 },
	cost = 10,
    config = { extra = { rate = 4 } }, --Variables: rate = power card shop rate

    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.power_rate = card.ability.extra.rate
                return true 
            end
        }))
    end
}

SMODS.Voucher { --Power Tycoon
    key = 'power_tycoon',
    name = 'Power Tycoon',
	atlas = 'Voucher',
	pos = { x = 0, y = 1 },
	cost = 10,
    requires = { 'v_bloons_power_merchant' },
    config = { extra = { rate = 9.33, multiplier = 2 } }, --Variables: rate = power card shop rate

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.multiplier } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.power_rate = card.ability.extra.rate
                return true 
            end
        }))
    end
}

SMODS.Voucher { --Insider Trades
    key = 'insider_trades',
    name = 'Insider Trades',
	atlas = 'Voucher',
	pos = { x = 1, y = 0 },
	cost = 10,
    config = { extra = { slots = 1 } }, --Variables: slots = extra booster slots

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_booster_limit(card.ability.extra.slots)
                return true 
            end
        }))
    end
}

SMODS.Voucher { --Backroom Deals
    key = 'backroom_deals',
    name = 'Backroom Deals',
	atlas = 'Voucher',
	pos = { x = 1, y = 1 },
	cost = 10,
    requires = { 'v_bloons_insider_trades' },
    config = { extra = { slots = 1 } }, --Variables: slots = extra voucher slots

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_voucher_limit(card.ability.extra.slots)
                return true 
            end
        }))
    end
}

SMODS.Voucher { --Flanking Maneuvers
    key = 'flanking_maneuvers',
    name = 'Flanking Maneuvers',
	atlas = 'Voucher',
	pos = { x = 2, y = 0 },
	cost = 10,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_double
    end
}

SMODS.Voucher { --Grand Prix Spree
    key = 'grand_prix_spree',
    name = 'Grand Prix Spree',
    atlas = 'Voucher',
	pos = { x = 2, y = 1 },
	cost = 10,
    requires = { 'v_bloons_flanking_maneuvers' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_skip
    end
}

SMODS.Voucher { --Big Bloon Sabotage
    key = 'big_bloon_sabotage',
    name = 'Big Bloon Sabotage',
	atlas = 'Voucher',
	pos = { x = 3, y = 0 },
	cost = 10,
    config = { extra = { percent = 10 } }, --Variables: percent = reduction percent

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.percent } }
    end
}

SMODS.Voucher { --Big Bloon Blueprints
    key = 'big_bloon_blueprints',
    name = 'Big Bloon Blueprints',
	atlas = 'Voucher',
	pos = { x = 3, y = 1 },
	cost = 10,
    requires = { 'v_bloons_big_bloon_sabotage' },
    config = { extra = { percent = 30 } }, --Variables: percent = reduction percent

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.percent } }
    end
}