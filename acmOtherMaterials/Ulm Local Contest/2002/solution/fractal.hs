-- Problem   The Sierpinski Fractal
-- Algorithm Recursion
-- Runtime   O(n^2)
-- Author    Walter Guttmann
-- Date      27.12.2001

import List;

main :: IO ()
main =
  do input <- readFile "fractal.in"
     mapM_ solve $ takeWhile (> 0) $ map read $ words input

solve :: Int -> IO ()
solve n = triangle (putStrLn "") [2^n] n

triangle :: IO () -> [Int] -> Int -> IO ()
triangle m xs 1 =
  do putStrLn (line1 1 xs)
     putStrLn (line2 1 xs)
     m
triangle m xs n = triangle m' xs (n-1)
  where m' = triangle m (concat [ [ x-o , x+o ] | x <- xs ]) (n-1)
        o  = 2 ^ (n-1)

line1 :: Int -> [Int] -> String
line1 o [] = ""
line1 o (x:xs) = replicate (x-o) ' ' ++ "/\\" ++ line1 (x+2) xs

line2 :: Int -> [Int] -> String
line2 o [] = ""
line2 o (x:xs) = replicate (x-o-1) ' ' ++ "/__\\" ++ line2 (x+3) xs

