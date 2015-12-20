import Data.Monoid

newtype MyAll = MyAll { getMyAll :: Bool }
    deriving (Eq, Ord, Read, Show, Bounded)
    
newtype MyAny = MyAny { getMyAny :: Bool }
    deriving (Eq, Ord, Read, Show, Bounded)

instance Monoid MyAll where
    mempty = MyAll True
    MyAll x `mappend` MyAll y = MyAll (x && y)
    
instance Monoid MyAny where
    mempty = MyAny False
    MyAny x `mappend` MyAny y = MyAny (x || y)