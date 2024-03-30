

local Query = objects.Class("generation:Query")


function Query:init(args)
    self.from = args.from
    self.rng = args.rng or DEFAULT_RNG

    self.filter = args.filter 
end



function Query:execute()

end


return Query

