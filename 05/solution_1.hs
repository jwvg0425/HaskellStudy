inverse xs = map (1/) xs

longList xs = filter ((>= 3).length) xs

dot xs ys = zipWith (\(x1,y1) (x2,y2) -> x1*x2 + y1*y2) xs ys