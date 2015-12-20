import System.Random
import Control.Monad
import Data.List

main = do
    gen <- getStdGen
    play $ makeAnswer gen

makeAnswer :: StdGen -> Int
makeAnswer gen = head candidates
    where rands = randomRs (0, 9) gen
          candidates = do
            h <- rands
            guard (h /= 0)
            t <- rands
            guard (h /= t)
            o <- rands
            guard (o /= t && o /= h)
            return (h*100 + t*10 + o)
            
play :: Int -> IO ()
play answer = do
    putStrLn "guess the answer!(0 : exit)"
    rawInput <- getLine
    let input = getInput rawInput
    case input of Just 0 -> end
                  Nothing -> retry answer
                  Just guess -> check answer guess
                  
end :: IO ()
end = do
    putStrLn "game over."
    
retry :: Int -> IO ()
retry answer = do
    putStrLn "invalid input."
    play answer
    
check :: Int -> Int -> IO ()
check answer guess
    | answer == guess = do
        putStrLn "you are right!"
        end
    | otherwise = do
        let (s, b) = getStrikeAndBall answer guess
        putStrLn $ show s ++ " strike, " ++ show b ++ " ball"
        play answer

getInput :: String -> Maybe Int
getInput raw = go (reads raw)
    where go [] = Nothing
          go [(i, [])]
            | i == 0 = Just 0
            | i > 999 || i < 100 = Nothing
            | (length . nub . show) i == 3 = Just i
            | otherwise = Nothing
          go _ = Nothing
    
getStrikeAndBall :: Int -> Int -> (Int, Int)
getStrikeAndBall answer guess = (strike, ball)
    where a = show answer
          g = show guess
          strike = length $ filter (\(x,y) -> x == y) (zip a g)
          ball = (length $ filter (\x -> x `elem` a) g) - strike