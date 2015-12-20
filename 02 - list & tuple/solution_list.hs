lastButOne xs = last (init xs)
notCapital xs = [x | x <- xs, x `notElem` ['A'..'Z']]
diff as bs = [a | a <- as, a `notElem` bs]