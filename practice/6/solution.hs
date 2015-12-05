

-- # 1 : Direction & Position

data Direction = L | R | U | D

data Position a = Position a a

move :: (Num a) => Position a -> Direction -> a -> Position a
move (Position x y) L dx = Position (x-dx) y
move (Position x y) R dx = Position (x+dx) y
move (Position x y) U dy = Position x (y-dy)
move (Position x y) D dy = Position x (y+dy)

-- # 2 : Direction & Position : typeclass

instance Show Direction where
    show L = "Left Direction"
    show U = "Up Direction"
    show R = "Right Direction"
    show D = "Down Direction"
    
instance Eq Direction where
    L == L = True
    R == R = True
    U == U = True
    D == D = True
    _ == _ = False
    
instance (Num a, Eq a) => Eq (Position a) where
    Position ax ay == Position bx by = (ax == bx) && (ay == by)
    
instance (Num a, Show a) => Show (Position a) where
    show (Position x y) = "(x = " ++ show x ++ ", y = " ++ show y ++ ")"