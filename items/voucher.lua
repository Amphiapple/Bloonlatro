SMODS.Atlas {
    key = 'Voucher',
    path = 'vouchers.png',
    px = 71,
    py = 95,
}

SMODS.Voucher { --Power Merchant
    key = 'power_merchant',
    name = 'Power Merchant',
	loc_txt = {
        name = 'Power Merchant',
        text = {
            '{C:power}Power{} cards may',
            'appear in the shop'
        }
    },
	atlas = 'Voucher',
	pos = { x = 0, y = 0 },
	cost = 10,
	order = 33,
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
	loc_txt = {
        name = 'Power Tycoon',
        text = {
            '{C:power}Power{} cards appear',
            '{C:attention}#1#X{} more frequently',
            'in the shop'
        }
    },
	atlas = 'Voucher',
	pos = { x = 0, y = 1 },
	cost = 10,
	order = 34,
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
	loc_txt = {
        name = 'Insider Trades',
        text = {
            '{C:attention}+#1#{} Booster Pack slot'
        }
    },
	atlas = 'Voucher',
	pos = { x = 1, y = 0 },
	cost = 10,
	order = 35,
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
	loc_txt = {
        name = 'Backroom Deals',
        text = {
            '{C:attention}+#1#{} Voucher slot'
        }
    },
	atlas = 'Voucher',
	pos = { x = 1, y = 1 },
	cost = 10,
	order = 36,
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

SMODS.Voucher { --Quick Hands
    key = 'quick_hands',
    name = 'Quick Hands',
	loc_txt = {
        name = 'Quick Hands',
        text = {
            'Create a {C:attention}Double Tag{}',
            'when skipping a {C:attention}Blind{}'
        }
    },
	atlas = 'Voucher',
	pos = { x = 2, y = 0 },
	cost = 10,
	order = 37,
}

SMODS.Voucher { --Grand Prix Spree
    key = 'grand_prix_spree',
    name = 'Grand Prix Spree',
	loc_txt = {
        name = 'Grand Prix Spree',
        text = {
            'Create a {C:attention}Speed Tag{}',
            'when skipping a {C:attention}Blind{}'
        }
    },
	atlas = 'Voucher',
	pos = { x = 2, y = 1 },
	cost = 10,
	order = 38,
    requires = { 'v_bloons_quick_hands' },
}

SMODS.Voucher { --Big Bloon Sabotage
    key = 'big_bloon_sabotage',
    name = 'Big Bloon Sabotage',
	loc_txt = {
        name = 'Big Bloon Sabotage',
        text = {
            'Reduce {C:attention}Blind{}',
            'requirement by {C:attention}#1#%{}'
        }
    },
	atlas = 'Voucher',
	pos = { x = 3, y = 0 },
	cost = 10,
	order = 39,
    config = { extra = { percent = 10 } }, --Variables: percent = reduction percent

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.percent } }
    end
}

SMODS.Voucher { --Big Bloon Blueprints
    key = 'big_bloon_blueprints',
    name = 'Big Bloon Blueprints',
	loc_txt = {
        name = 'Big Bloon Blueprints',
        text = {
            'Reduce {C:attention}Boss Blind{}',
            'requirement by {C:attention}#1#%{} instead'
        }
    },
	atlas = 'Voucher',
	pos = { x = 3, y = 1 },
	cost = 10,
	order = 40,
    requires = { 'v_bloons_big_bloon_sabotage' },
    config = { extra = { percent = 25 } }, --Variables: percent = reduction percent

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.percent } }
    end
}