
local EntryManager = require("EntryManager")
local UniformPicker = require("UniformPicker")


local Generator = objects.Class("generation:Generator")



local truthy = function()
    return true
end


local function defaultChance(entry, options)
    return options.chance or 1
end





function Generator:createQuery(args)
    --[[
        args = {
            from = {...},
            rng = RNGObject(),
            filter = func,
            chance = func
        }
    ]]
    typecheck.assertKeys(args, {"from"})

    local filter = args.filter or truthy
    local chance = args.chance or defaultChance

    -- get the entries, and filter them:
    local entries = self.entryManager:getEntries(args.from)
        :filter(filter)
        :map(function(entryObj)
            local entry = entryObj.entry
            return {
                entry = entry,
                chance = chance(entry, entryObj)
            }
        end)

    local rng = args.rng or self.rng
    local picker = UniformPicker(entries)
    
    local function pick()
        local r1 = rng:random()
        local r2 = rng:random()
        return picker:pick(r1,r2)
    end
    return pick
end



function Generator:query(args)
    --[[
        same as :createQuery(...), except executes instantly
    ]]
    local query = self:createQuery(args)
    return query()
end




function Generator:init()
    self.rng = love.math.newRandomGenerator()
    self.entryManager = EntryManager()
end




return Generator

