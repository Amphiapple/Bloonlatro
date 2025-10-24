SMODS.Atlas {
    key = 'Modifier',
    path = 'modifiers.png',
    px = 34,
    py = 34,
}

SMODS.Sticker {
    key = 'regrow',
    name = 'Regrow',
    atlas = 'Modifier',
    pos = { x = 0, y = 0 },
    default_compat = false,
    set = 'blind',
    badge_colour = G.C.RED,
    config = { ante = 2, percent = 10 },
    loc_vars = function(self)
        return { vars = { self.config.percent } }
    end
}

SMODS.Sticker {
    key = 'camo',
    name = 'Camo',
    atlas = 'Modifier',
    pos = { x = 1, y = 0 },
    default_compat = false,
    set = 'blind',
    badge_colour = G.C.GREEN,
    config = { ante = 4, limit = 5 },
    loc_vars = function(self)
        return { vars = { self.config.limit } }
    end
}

SMODS.Sticker {
    key = 'fortified',
    name = 'Fortified',
    atlas = 'Modifier',
    pos = { x = 2, y = 0 },
    default_compat = false,
    set = 'blind',
    badge_colour = HEX('Be6a1a'),
    config = { ante = 6, increase = 2 },
    loc_vars = function(self)
        return { vars = { self.config.increase } }
    end
}