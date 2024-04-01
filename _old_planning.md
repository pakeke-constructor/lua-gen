
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















