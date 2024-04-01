
--[[

OK:
I'm not gonna fakken lie, I'm actually NOT ENTIRELY SURE HOW THIS WORKS.
Basically, it's a highly efficient discrete-random-sampling algorithm,
using an algorithm called the "Alias method":
https://en.wikipedia.org/wiki/Alias_method

Code taken from:  https://gist.github.com/RyanPattison/7dd900f4042e8a6f9f23
(Released into public domain, per Ryan's request)

Ok::::
After some "better" research, I found an excellent source 
with a very intuitive explanation:
https://www.keithschwarz.com/darts-dice-coins/

]]


local UniformPicker = {} --objects.Class("generation:UniformPicker")


function UniformPicker:init(pickList) 
    --[[
        pickList = {
            {chance=X, entry=X},
            {chance=X, entry=X},
            {chance=X, entry=X},
            ...
        }
    ]]
    local weights = {}
    self.entryList = {}
    local seen = {}
    for i,pick in ipairs(pickList) do
        local entry, chance = pick.entry, pick.chance
        self.entryList[i] = entry
        if seen[entry] then
            error("Duplicate entry in query: " .. tostring(entry))
        end
        seen[entry] = true
        weights[i] = chance
    end

    local total = 0
    for _,v in ipairs(weights) do
        assert(v >= 0, "all weights must be non-negative")
        total = total + v
    end

    assert(total > 0, "total weight must be positive")
    local normalize = #weights / total
    local norm = {}
    local small_stack = {}
    local big_stack = {}
    for i,w in ipairs(weights) do
        norm[i] = w * normalize
        if norm[i] < 1 then
            table.insert(small_stack, i)
        else
            table.insert(big_stack, i)
        end
    end

    local prob = {}
    local alias = {}
    while small_stack[1] and big_stack[1] do -- both non-empty
        local small = table.remove(small_stack)
        local large = table.remove(big_stack)
        prob[small] = norm[small]
        alias[small] = large
        norm[large] = norm[large] + norm[small] - 1
        if norm[large] < 1 then
            table.insert(small_stack, large)
        else 
            table.insert(big_stack, large)
        end
    end

    for _, v in ipairs(big_stack) do 
        prob[v] = 1
    end
    for _, v in ipairs(small_stack) do 
        prob[v] = 1
    end

    self.alias = alias
    self.prob = prob
    self.n = #weights
end




local function pickIndex(self, rand, rand2)
    -- 0 <= num <= 1
    local index = math.floor(rand * self.n) + 1
    if rand2 < self.prob[index] then
        return index
    else
        return self.alias[index]
    end
end


function UniformPicker:pick(rand1, rand2)
    local i = pickIndex(self, rand1, rand2)
    return self.entryList[i]
end




local self = {}
local PROBS = {
    0.0001,0.02,0.4, 0.57
}
UniformPicker.init(self, PROBS)

-- print("PROB:")
-- for k,v in pairs(self.prob) do
--     print(k,v)
-- end
-- print("ALIAS:")
-- for k,v in pairs(self.alias) do
--     print(k,v)
-- end



local picks = {}
for i=1, #PROBS do
    picks[i] = 0
end

local r=love.math.random
for i=1, 10000100 do
    local x = UniformPicker.pick(self, r(), r())
    picks[x] = picks[x] + 1
end




local function normalizeTable(tabl)
    local tot = 0
    for k,v in pairs(tabl)do 
        tot = tot + v
    end
    for k,v in pairs(tabl)do 
        tabl[k] = tabl[k] / tot
    end
end

normalizeTable(picks)
normalizeTable(PROBS)

for k,v in pairs(picks) do
    print("EXPECTED, GOT: ", PROBS[k], picks[k])
end



return UniformPicker



