SMODS.Stake {
    key = 'chimps',
    name = 'CHIMPS Stake',
    applied_stakes = { 'gold' },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("006240"),

    modifiers = function()
        G.GAME.modifiers.chimps_stake = true
    end
}