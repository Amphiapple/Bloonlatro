local create_mod_badges_old = SMODS.create_mod_badges

-- Register category colours
G.C.PRIMARY  = HEX("25ACE8")
G.C.MILITARY = HEX("3DD228")
G.C.MAGIC    = HEX("7E4AF4")
G.C.SUPPORT  = HEX("EE882B")
G.C.MISC     = HEX("FF6FAE")


local function split_two_lines(text)
    text = tostring(text or "")
    if text == "Card Storm" then return text end --Special case for Card Storm as it looks worse with the line break

    local words = {}
    for w in text:gmatch("%S+") do
        words[#words+1] = w
    end

    if #words <= 1 then
        return text, nil
    end

    local mid = math.ceil(#words/2)
    return table.concat(words, " ", 1, mid),
           table.concat(words, " ", mid + 1)
end


local function make_text_row(str)
    return {
        n = G.UIT.R,
        config = {align = "cm", padding = 0},
        nodes = {{
            n = G.UIT.O,
            config = {
                object = DynaText({
                    string = str,
                    colours = {G.C.WHITE},
                    silent = true,
                    float = true,
                    shadow = true,
                    spacing = 1,
                    scale = 0.33 * 0.9
                })
            }
        }}
    }
end


local function create_bloonlatro_badge(text, colour)
    local line1, line2 = split_two_lines(text)

    local rows = { make_text_row(line1) }

    if line2 and line2 ~= "" then
        rows[#rows+1] = make_text_row(line2)
    end

    local height = (line2 and line2 ~= "") and 0.62 or 0.36

    return {
        n = G.UIT.R,
        config = {align = "cm"},
        nodes = {{
            n = G.UIT.R,
            config = {
                align = "cm",
                colour = colour or G.C.JOKER_GREY,
                r = 0.1,
                minw = 2.0,
                minh = height,
                emboss = 0.05,
                padding = 0.03 * 0.9
            },
            nodes = {
                {n = G.UIT.B, config = {h = 0.1, w = 0.03}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.01}, nodes = rows},
                {n = G.UIT.B, config = {h = 0.1, w = 0.03}}
            }
        }}
    }
end


function SMODS.create_mod_badges(obj, badges)
    if not (obj and badges) then return end

    if create_mod_badges_old then
        create_mod_badges_old(obj, badges)
    end

    local info = (obj.config and obj.config.tower_info)
    if not info then return end

    local base     = info.base or "placeholder base"
    local upgrade  = info.upgrade or "placeholder upgrade"
    local category = info.category or "placeholder category"

    local colour = G.C[category:upper()] or G.C.JOKER_GREY

    badges[#badges+1] = create_bloonlatro_badge(base, colour)
end