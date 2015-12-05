
-- # 1 : pairString
pairString :: [(Char, Char)] -> (String, String)
pairString = foldr (\(x,y) (accX,accY) -> (x:accX,y:accY)) ("","")