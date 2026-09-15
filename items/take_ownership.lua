-- Change vouchers to increase values instead of setting them
SMODS.Voucher:take_ownership('clearance_sale', {
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = G.GAME.discount_percent + 25
                return true
            end
        }))
    end
}, true)

SMODS.Voucher:take_ownership('liquidation', {
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = G.GAME.discount_percent + 25
                return true
            end
        }))
    end
}, true)

SMODS.Voucher:take_ownership('seed_money', {
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.interest_cap = G.GAME.interest_cap + 25
                return true
            end
        }))
    end
}, true)

SMODS.Voucher:take_ownership('money_tree', {
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.interest_cap = G.GAME.interest_cap + 50
                return true
            end
        }))
    end
}, true)

SMODS.Voucher:take_ownership('magic_trick', {
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.playing_card_rate = G.GAME.playing_card_rate + 4
                return true
            end
        }))
    end
}, true)
