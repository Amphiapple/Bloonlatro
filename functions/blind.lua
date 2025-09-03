function Blind:bloons_modify_score(score)
    if not self.disabled then
        local obj = self.config and self.config.blind or self
        if obj.bloons_modify_score and type(obj.bloons_modify_score) == "function" then
            return obj:bloons_modify_score(score)
        end
    end
    return score
end