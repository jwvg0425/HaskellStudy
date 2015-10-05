maximum' :: (Ord a) => [a] -> a
maximum' [] = error "empty list"
maximum' [x] = x
maximum' (x:xs)
    | x > tailMaximum = x
    | otherwise = tailMaximum
    where tailMaximum = maximum' xs
    
take' :: (Integral a) => a -> [b] -> [b]
take' n _ | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x:take' (n-1) xs

zip' :: [a] -> [b] -> [(a,b)]
zip' [] _ = []
zip' _ [] = []
zip' (x:xs) (y:ys) = (x,y):zip' xs ys

quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort [x] = [x]
quickSort (x:xs) = quickSort small ++ [x] ++ quickSort big
    where small = [s | s <- xs, s <= x]
          big = [b | b <- xs, b > x]