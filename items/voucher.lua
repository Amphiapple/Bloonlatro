SMODS.Atlas {
    key = 'Voucher',
    path = 'vouchers.png',
    px = 71,
    py = 95,
}

SMODS.Joker { --
    key = '',
    name = '',
	loc_txt = {
        name = '',
        text = {

        }
    },
	atlas = 'Voucher',
	pos = { x = 0, y = 0 },
	cost = 10,
	order = 33,
    config = { extra = {  } }, --Variables:

    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        
    end
}
