finalPosition = foldl (\(x,y) (dx,dy) -> (x+dx, y+dy))

nineDigit :: (Integral a, Show a, Integral b) => a -> b
nineDigit = fromIntegral . length . filter (=='9') . show