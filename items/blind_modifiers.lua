Bloonlatro = Bloonlatro or {}
Bloonlatro.blind_modifiers = Bloonlatro.blind_modifiers or {}

SMODS.Atlas {
    key = 'Modifier',
    path = 'modifiers.png',
    px = 34,
    py = 34,
}

local function create_blind_modifier(modifier)
    local full_key = "bloons_" .. modifier.key
    local full_atlas = "bloons_" .. modifier.atlas
    local new_modifier = {
        key = full_key,
        name = modifier.name,
        atlas = full_atlas,
        pos = modifier.pos,
        colour = modifier.colour,
        config = modifier.config,
        loc_vars = modifier.loc_vars
    }

    Bloonlatro.blind_modifiers[full_key] = new_modifier
end

create_blind_modifier {
    key = 'regrow',
    name = 'Regrow',
    atlas = 'Modifier',
    pos = { x = 0, y = 0 },
    colour = G.C.RED,
    config = { ante = 2, percent = 10 },
    loc_vars = function(self)
        return { vars = { self.config.percent } }
    end
}

create_blind_modifier {
    key = 'camo',
    name = 'Camo',
    atlas = 'Modifier',
    pos = { x = 1, y = 0 },
    colour = G.C.GREEN,
    config = { ante = 4, limit = 5 },
    loc_vars = function(self)
        return { vars = { self.config.limit } }
    end
}

create_blind_modifier {
    key = 'fortified',
    name = 'Fortified',
    atlas = 'Modifier',
    pos = { x = 2, y = 0 },
    colour = HEX('Be6a1a'),
    config = { ante = 6, increase = 2 },
    loc_vars = function(self)
        return { vars = { self.config.increase } }
    end
}