SMODS.Atlas {
    key = 'bloons_logo',
    path = 'logos.png',
    px = 71,
    py = 95
}

SMODS.Sound({key = "pop01", path = "pop01.ogg",})
SMODS.Sound({key = "pop02", path = "pop02.ogg",})
SMODS.Sound({key = "pop03", path = "pop03.ogg",})
SMODS.Sound({key = "pop04", path = "pop04.ogg",})

function Bloonlatro.main_menu(pos_x)
    if not G.title_top or not G.title_top.cards or not G.title_top.cards[1] then return end

    G.title_top.max_pos_x = G.title_top.max_pos_x or pos_x

    G.title_top.cards[1]:remove()

    local card = Card(
        0, 0,
        G.CARD_W * 1.4,
        G.CARD_H * 1.4,
        G.P_CARDS.empty,
        G.P_CENTERS.c_base
    )

    card:set_alignment({
        major = G.title_top,
        type = 'cm',
        bond = 'Strong',
        offset = { x = 0, y = 0 }
    })

    card.no_ui = true

    card.children.center:remove()
    card.children.center = SMODS.create_sprite(
        card.T.x, card.T.y, card.T.w, card.T.h,
        G.ASSET_ATLAS["bloons_logo"],
        { x = pos_x, y = 0 }
    )
    card.children.center:set_role({ major = card, role_type = 'Glued', draw_major = card })

    function card:click()
        local num = math.random(1, 4)
        play_sound('bloons_pop0'..num)
        G.E_MANAGER:add_event(Event({
            delay = 0.1,
            func = function()
                local next_x = (pos_x <= 0 and G.title_top.max_pos_x) or (pos_x - 1)

                pos_x = next_x

                card.children.center:set_sprite_pos({ x = pos_x, y = 0 })

                return true
            end
        }))
    end

    G.title_top:emplace(card)
end