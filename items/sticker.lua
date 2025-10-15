SMODS.Atlas {
    key = 'Tag',
    path = 'tags.png',
    px = 34,
    py = 34,
}

SMODS.Sticker {
    key = 'regrow',
    name = 'Regrow',
    atlas = 'Tag',
    pos = { x = 0, y = 0 },
    default_compat = false,
    badge_colour = G.C.RED,
    loc_vars = function(self, info_queue, card)
        return { vars = { 10 } }
    end
}

SMODS.Sticker {
    key = 'camo',
    name = 'Camo',
    atlas = 'Tag',
    pos = { x = 1, y = 0 },
    default_compat = false,
    badge_colour = G.C.GREEN,
    loc_vars = function(self, info_queue, card)
        local prob_vars = SMODS.get_probability_vars('camo', 1, 7, false)
        return { vars = prob_vars }
    end
}

SMODS.Sticker {
    key = 'fortified',
    name = 'Fortified',
    atlas = 'Tag',
    pos = { x = 2, y = 0 },
    default_compat = false,
    badge_colour = G.C.BLACK,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end
}