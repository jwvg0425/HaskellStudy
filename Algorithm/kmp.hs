import Data.Array

data KMP a = KMP
    { done :: Bool
    , next :: (a -> KMP a)
    }

isSubstringOf :: Eq a => [a] -> [a] -> Bool
isSubstringOf as bs = any done $ scanl next (makeTable as) bs

makeTable :: Eq a => [a] -> KMP a
makeTable xs = table
    where table = makeTable' xs (const table)

makeTable' :: Eq a => [a] -> (a -> KMP a) -> KMP a
makeTable' [] failure = KMP True failure
makeTable' (x:xs) failure = KMP False test
    where test c = if c == x then success else failure c
          success = makeTable' xs (next (failure x))