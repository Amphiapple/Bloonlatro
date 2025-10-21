-- Bunco sticker compatability functions
function Card.set_scattering(self, _scattering)
    if SMODS.Mods["Bunco"] and SMODS.Mods["Bunco"].can_load then
        self.ability.bunc_scattering = _scattering
    end
end

function Card.set_hindered(self, _hindered)
    if SMODS.Mods["Bunco"] and SMODS.Mods["Bunco"].can_load then
        self.ability.bunc_hindered = _hindered
    end
end

function Card.set_reactive(self, _reactive)
    if SMODS.Mods["Bunco"] and SMODS.Mods["Bunco"].can_load then
        self.ability.bunc_reactive = _reactive
    end
end