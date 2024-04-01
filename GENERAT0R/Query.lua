
local Picker = require("Picker")


local Query = objects.Class("generation:Query")



local function finalize(self)
    if self:isEmpty() then
        error("Cannot finalize query! (There are no possible results.)")
    end
    self.picker = Picker(self.picks)
end



local ARGS = {"rng", "generator"}
function Query:init(args)
    typecheck.assertKeys(args, ARGS)

    -- you won't need to modify ANY of these fields outside this module.
    self.rng = args.rng
    self.generator = args.generator

    self.seenPicks = {--[[
        [entry] -> {chance=X, entry=X}
    ]]}
    self.picks = objects.Array(--[[
        {chance=X, entry=X}
    ]])

    self.filters = objects.Array()
    self.chanceAdjusters = objects.Array()

    self.outdated = true
    self.picker = nil

    self.nestedQueries = objects.Set()
end



function Query:__call()
    -- executing a query:
    if self.outdated then
        finalize(self)
    end

    local r1 = self.rng:random()
    local r2 = self.rng:random()
    local result = self.picker:pick(r1,r2)
    if Query:isInstance(result) then
        -- its a nested query: call again
        return result()
    end
    return result -- else, its an entry.
end


function Query:isEmpty()
    return #self.picks <= 0
end



local addTc = typecheck.assert("table", "any", "number")

function Query:add(entry_or_query, chance)
    --[[
        TODO:
        Should we be checking for loops here?
        ie. query references itself...
        We dont want querys querying themselves.... thatd be bad
    ]]
    addTc(self, entry_or_query, chance)

    if self.seenPicks[entry_or_query] then
        -- The pick already exists. So, just increase the chance:
        local pick = self.seenPicks[entry_or_query]
        pick.chance = pick.chance + chance
    else
        local pick = {
            chance = chance,
            entry = entry_or_query
        }
        self.rawPicks:add(pick)
        self.seenPicks[entry_or_query] = pick
    end

    self.outdated = true
    return self
end


return Query
