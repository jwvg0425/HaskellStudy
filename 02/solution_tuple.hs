swap xs = [(snd x, fst x) | x <- xs]
-- using pattern matching (see study 4)
swap' xs = [(y,x) | (x,y) <- xs]
sum' xs = if null xs then 0 else head xs + sum' (tail xs)
-- using pattern matching (see study 4)
sum2 [] = 0
sum2 (x:xs) = x + sum2 xs
divisors n = [x | x <- [1..n], n `mod` x == 0]