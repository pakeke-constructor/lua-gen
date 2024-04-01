
local EntryManager = require("EntryManager")
local Query = require("Query")


local Generator = objects.Class("generation:Generator")



local truthy = function()
    return true
end


local function defaultChance(entry, options)
    return options.chance or 1
end



local EMPTY = {}


local queryTc = typecheck.assert("table", "table")
function Generator:createQuery(args)
    --[[
        args = {
            from = {...},
            rng = RNGObject() or nil,
            filter = func or nil,
            chance = func or nil
        }
    ]]
    queryTc(self, args)

    local from = args.from or EMPTY
    local filter = args.filter or truthy
    local chanceFunc = args.chance or defaultChance

    -- get the entries, and filter them:
    local query = Query()
    self.entryManager:getEntries(from)
        :filter(filter)
        :map(function(entryObj)
            local entry = entryObj.entry
            local chance = chanceFunc(entry, entryObj)
            query:add(entry, chance)
        end)

    return query
end



function Generator:query(args)
    --[[
        same as :createQuery(...), except executes instantly.

        WARNING!!!!
        This function is VERY INEFFICIENT!!!!
        If you want more efficieny code, create a query once, 
        and reuse it elsewhere.

        TODO:
        Should we remove this???
        Probably...
    ]]
    queryTc(self, args)
    local query = self:createQuery(args)
    return query()
end




function Generator:init()
    self.rng = love.math.newRandomGenerator()
    self.entryManager = EntryManager()
end




return Generator

