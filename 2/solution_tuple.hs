swap xs = [(snd x, fst x) | x <- xs]
sum' xs = if null xs then 0 else head xs + sum' (tail xs)
divisors n = [x | x <- [1..n], n `mod` x == 0]