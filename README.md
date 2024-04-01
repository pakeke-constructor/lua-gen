

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

    -- we can also add extra entries manually:
    -- (This will be ignored by the `filter` and `chance` functions)
    extra = {
        {entry="mod:coal", chance=0.5},
        {entry="mod:iron", chance=0.2}
    }
})






-- creates a query, and executes it instantly:
-- (WARNING: Is very inefficient!!!)
local x = gen:query({
    ...
})




-- generate 3 random entries:
local x1 = query()
local x2 = query()
local x3 = query()

```


## FLEXIBILTY PROBLEMS:
There are some problems with this current setup;
particularly to do with flexibility.


#### PROBLEM-1: Altering probabilities
For example, lets say we have an item call `FOO_ITEM`:
- If you took damage last round:
    - Make *legendary* items 2x as common.

How can we integrate this ^^^^ with the existing query setup....?  
It's hard...  
Part of this is probably due to the Alias-Method data-structure;
which doesn't allow altering the probability-space once its been created.  
hmm....

The only possible way to do this would be to re-construct the query
each time something updates.   
^^^ this is not a *bad* solution per se, but it is not efficient at all.

Ahh, actually, this could be quite a good solution.    
For example, in `lootplot`; we would ideally reconstruct the 
query every time we reroll.   
This would DEFINITELY be efficient-enough.

**EXAMPLE IMPLEMENTATION:**
- have a property, `legendaryRandomnessMult`.
- FOO_ITEM should add a 2x multiplier to ^^^ that property
- Whenever the query is reconstructed, a question-bus should modify the `.chance` value for every legendary entry.


#### PROBLEM-2: 
Ultra-custom querys:   
Ok.. this is actually a much bigger problem.

Lets say we want a query with all entries from `tag-A`, plus 2 extra entries.
How would we do that...?

Well... we'd have to create a query with ALL possible entries,
and then filter specifically for the entries that we want.

this... is fucking dumb. We should allow users to pass in their own entries.



#### PROBLEM-3:
Relative-probabilities:

Consider the following query:
    50% chance to spawn a zombie.
    50% chance to spawn a legendary item.
```lua
-- Create a generator query:
local query = gen:createQuery({
    ...
})





















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

