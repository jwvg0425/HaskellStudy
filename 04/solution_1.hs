yesNo :: Bool -> String
yesNo True = "Yes"
yesNo False = "No"

trueman :: (Num a) => [Bool] -> a
trueman [] = 0
trueman (True:xs) = 1 + trueman xs
trueman (_:xs) = trueman xs

listToPairs :: [a] -> [(a,a)]
listToPairs [] = []
listToPairs [a] = []
listToPairs (x:y:zs) = (x,y):listToPairs zs