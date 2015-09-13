data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving Show

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

insert :: (Ord a) => Tree a -> a -> Tree a
insert EmptyTree x = singleton x
insert node@(Node value left right) x
    | x == value = node
    | x < value = Node value (insert left x) right
    | otherwise = Node value left (insert right x)
    
find :: (Ord a) => Tree a -> a -> Bool
find (Node value left right) x
    | x == value = True
    | x < value = find left x
    | otherwise = find right x