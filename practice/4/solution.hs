
-- # 1 : isSorted
isSorted :: Ord a => [a] -> Bool
isSorted [] = True
isSorted [a] = True
isSorted [a,b] = a <= b
isSorted (a:b:l) = if a > b then False else isSorted (b:l)

-- # 2 : contains
contains :: Eq a => [a] -> [a] -> Bool
contains _ [] = True
contains xs (y:ys) = (y `elem` xs) && contains xs ys