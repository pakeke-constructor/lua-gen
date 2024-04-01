

# API Planning:
```lua

gen = Generator()

rng = RNGState()


-- add an entry to the generation config
gen:addEntry("mod:grass", {
    chance = 1, -- (default=1)

    -- tags are string keywords that we can query for
    tags = {"a", "b", "c"},

    -- traits are key-val pairs that we can also query for
    traits = {
        rarity = 5,
        requiredLevel = 2
    }
})

-- add more entries:
gen:addEntry("mod:ent_1", {...})
gen:addEntry("mod:ent_ABC", {...})
gen:addEntry("mod:ent_foobar", {...})
--[[
    ideally, these would work by tagging onto `@newEntityType`,
    and it would look for components deployed by the entity-type.

    If it matches some condition, then we should add the entity-type to our pool.
]]



-- Create a generator query:
local query = gen:createQuery({
    rng = rngObject or nil,

    from = {"a", "b"},
    -- selects entries with tag-`a`, OR with tag-`b`

    filter = function(entry, options)
        -- we can filter away entrys we dont want
        return options.traits.requiredLevel > 2
    end,
    chance = function(entry, options)
        -- we can provide a custom chance for each entry!
        -- (could use question-buses internally with this)
        return options.chance or 1
        -- (this ^^^^ is the code used by default)
        -- (NOTE: `options` is the table passed in by :addEntry() function)
    end
})

-- if there are no results to pick from,
-- `query` will be nil.



local x = gen:query({
    -- (creates a query, and executes it instantly)
    ...
})




-- generate 3 random entries:
local x1 = query()
local x2 = query()
local x3 = query()

--[[
    TODO:
    Could be pass xtra args into the query?
        IDEA:
]]
local x = query({
    retry = shouldRetry
})


```


<br/>
<br/>
<br/>

# Stretch Goal:
Query unions / more exotic composition:
```lua

local query2 = query
    :filter(newFilter) -- add a custom filter
    :union(query2) -- take a union with another query!
    :withEntry("mod:specialEntity", 0.1) -- add an entry manually

```

<br/>
<br/>




# Architecture:

```mermaid

```

