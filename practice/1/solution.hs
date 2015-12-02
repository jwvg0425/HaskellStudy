
-- #1 fibonacci
fibonacci n = if n <= 1 then 1 else fibonacci (n-1) + fibonacci (n-2)

-- #2 minThree
minThree a b c = min (min a b) c