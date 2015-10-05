data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving Show
    

height :: Tree a -> Integer
height EmptyTree = 0
height (Node _ left right) = max (height left) (height right) + 1

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
    
remove :: (Ord a) => Tree a -> a -> Tree a
remove EmptyTree _ = EmptyTree
remove tree@(Node value EmptyTree right) x
    | value == x = right
    | value > x = tree
    | otherwise = Node value EmptyTree (remove right x)
remove tree@(Node value left EmptyTree) x
    | value == x = Node r (remove left r) EmptyTree
    | value < x = tree
    | otherwise = Node value (remove left x) EmptyTree
    where Node r _ _ = rightmost left
remove tree@(Node value left right) x
    | value == x = Node r (remove left r) right
    | value < x = Node value left (remove right x)
    | otherwise = Node value (remove left x) right
    where Node r _ _ = rightmost left

rightmost :: Tree a -> Tree a
rightmost EmptyTree = EmptyTree
rightmost node@(Node value _ EmptyTree) = node
rightmost (Node value _ right) = rightmost right 