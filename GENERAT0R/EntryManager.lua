

local EntryManager = objects.Class("generation:EntryManager")


function EntryManager:init()
    self.tagToEntries = {--[[
        [tag] -> Set([entry1, entry2, ...])
    ]]}

    self.entries = objects.Set()

    self.nameToEntryObject = {--[[
        [entryName] -> entryObject
    ]]}
end



function EntryManager:defineEntry(entry, options)
    local entryObj = {
        chance = options.chance or 1,
        traits = options.traits or {},
        tags = objects.Set(options.tags or {}),
        entry = entry
    }
    for k,v in pairs(options) do
        -- Allow user to input custom data into the entry object
        if not entryObj[k] then
            entryObj[k] = v
        end
    end

    local tags = options.tags or {}
    for _, tag in tags do
        local set = self.tagToEntries[tag] or objects.Set()
        self.tagToEntries[tag] = set
        set:add(entryObj)
    end
    self.entries:add(entryObj)
    self.nameToEntryObject[entry] = entryObj
end



function EntryManager:getEntryObject(entry)
    return self.nameToEntryObject[entry]
end



function EntryManager:getEntries(fromTags)
    local set = objects.Set()
    for _, tag in ipairs(fromTags) do
        for _, entryObj in ipairs(self.tagToEntries[tag]) do
            set:add(entryObj)
        end
    end
end



return EntryManager

