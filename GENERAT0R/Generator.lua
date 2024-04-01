
local Query = require("Query")


local Generator = objects.Class("generation:Generator")





function Generator:createQuery(rng)
    -- get the entries, and filter them:
    local query = Query({
        rng = rng or self.rng,
        generator = self
    })
    return query
end




function Generator:init()
    self.rng = love.math.newRandomGenerator()

    self.tagToEntries = {--[[
        [tag] -> Set([entryObj, entryObj, ...])
    ]]}

    self.allEntries = objects.Set()

    self.nameToEntryObj = {--[[
        [entryName] -> entryObject
    ]]}
end




function Generator:defineEntry(entry, options)
    local entryObj = {
        defaultChance = options.defaultChance or 1,
        traits = options.traits or {},
        entry = entry
    }

    for _, trait in pairs(entryObj.traits) do
        local set = self.tagToEntries[trait] or objects.Set()
        self.tagToEntries[trait] = set
        set:add(entry)
    end

    self.allEntries:add(entryObj)
    self.nameToEntryObj[entry] = entryObj
end




function Generator:getEntries(traits)
    local set
    if #traits > 0 then
        set = objects.Set()
        for _, tag in ipairs(traits) do
            for _, entryObj in ipairs(self.tagToEntries[tag]) do
                set:add(entryObj)
            end
        end
    else
        -- defensive copy.
        set = objects.Set(self.allEntries)
    end
    return set
end


function Generator:getInfo(entry)
    -- gets info about an entry
    return self.nameToEntryObj[entry]
end




return Generator

