SMODS.Atlas {
    key = 'bloons_tutorial',
    path = 'tutorial.png',
    px = 75,
    py = 75
}

function create_bloonlatro_tutorial_button()
    G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial = G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial or false

    local card = create_sprite_card({
        w = 1.8,
        h = 1.8,
        atlas = G.ASSET_ATLAS["bloons_tutorial"],
        pos = { x = 0, y = 0 },
        no_ui = true
    })

    function card:click()
        print(G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial)
        G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial = true
        print(G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial)
    end

    return card
end