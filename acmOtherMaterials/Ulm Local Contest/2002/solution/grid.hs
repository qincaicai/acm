-- Problem   Paths on a Grid
-- Algorithm Binomial Coefficients
-- Runtime   O(n)
-- Author    Walter Guttmann
-- Date      26.12.2001

main :: IO ()
main =
  do input <- readFile "grid.in"
     mapM_ solve $ takeWhile (/= [0,0]) $ groupn 2 $ map read $ words input

groupn :: Int -> [a] -> [[a]]
groupn n xs = let (ys,zs) = splitAt n xs in ys : groupn n zs

solve :: [Integer] -> IO ()
solve [x,y] = putStrLn $ show $ choose (x+y) x

choose :: Integer -> Integer -> Integer
choose n k | k > n-k = choose n (n-k)
choose n k = product [n,n-1..n-k+1] `div` product [1..k]

