

local EntryManager = objects.Class("generation:EntryManager")


function EntryManager:init()
    self.tagToEntries = {--[[
        [tag] -> Set([entryObj, entryObj, ...])
    ]]}

    self.allEntryObjs = objects.Set()

    self.nameToEntryObj = {--[[
        [entryName] -> entryObject
    ]]}
end



function EntryManager:defineEntry(entry, options)
    local entryObj = {
        chance = options.chance or 1,
        traits = options.traits or {},
        tags = objects.Set(options.tags or {}), 
        -- ^^^^^^ wrap in Set so other APIS can use entryObj:has(tag)
        entry = entry
    }
    for k,v in pairs(options) do
        -- Allow user to input custom data into the entry object
        if not entryObj[k] then
            entryObj[k] = v
        end
    end

    local tags = options.tags or {}
    for _, tag in ipairs(tags) do
        local set = self.tagToEntries[tag] or objects.Set()
        self.tagToEntries[tag] = set
        set:add(entryObj)
    end

    self.allEntryObjs:add(entryObj)
    self.nameToEntryObj[entry] = entryObj
end



function EntryManager:getEntryObject(entry)
    return self.nameToEntryObj[entry]
end



function EntryManager:getEntries(fromTags)
    local set
    if #fromTags > 0 then
        set = objects.Set()
        for _, tag in ipairs(fromTags) do
            for _, entryObj in ipairs(self.tagToEntries[tag]) do
                set:add(entryObj)
            end
        end
    else
        -- defensive copy.
        set = objects.Set(self.allEntryObjs)
    end
    return set
end



return EntryManager

