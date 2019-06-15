module Impasta
    module Kernel
        def impasta?
            false
        end
    end

    class Spy < BasicObject
        def impasta?
            true
        end
    end
end