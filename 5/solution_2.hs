finalPosition start move = foldl (\(ax,ay) (x,y) -> (ax+x, ay+y)) start move

nineDigit :: Integer -> Int
nineDigit = length . filter (=='9') . show