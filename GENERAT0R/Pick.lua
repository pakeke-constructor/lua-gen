

local Pick = objects.Class("generation:Pick")

local Query


function Pick:init(value, chance)
    Query = Query or require("Query")
    self.value = value
    self.chance = chance
end


function Pick:get()
    if Query:isInstance(self.value) then
        return self.value()
    else
        return self.value
    end
end



return Pick

