SMODS.Atlas {
    key = 'Stake',
    path = 'stakes.png',
    px = 34,
    py = 34,
}

SMODS.Atlas {
    key = 'Sticker',
    path = 'stickers.png',
    px = 71,
    py = 95,
}

SMODS.Stake {
    key = 'chimps',
    name = 'CHIMPS Stake',
    atlas = 'Stake',
    pos = { x = 1, y = 0 },
    sticker_atlas = 'Sticker',
    sticker_pos = { x = 4, y = 1 },
    applied_stakes = { 'gold' },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("90b4f7"),

    modifiers = function()
        G.GAME.modifiers.chimps_stake = true
    end
}