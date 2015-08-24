even' n = n `mod` 2 == 0
factorial n = if n == 0 then 1 else n * factorial (n-1)
-- using product & list(see study 2)
factorial' n = product [1..n]