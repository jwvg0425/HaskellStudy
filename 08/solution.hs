data Tree a = Node a [Tree a] deriving Show

instance Functor Tree where
    fmap f (Node v children) = Node (f v) (map (fmap f) children)