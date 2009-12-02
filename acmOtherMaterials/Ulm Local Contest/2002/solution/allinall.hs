-- Problem   All in All
-- Algorithm Greedy
-- Runtime   O(n)
-- Author    Walter Guttmann
-- Date      26.12.2001

main :: IO ()
main =
  do input <- readFile "allinall.in"
     mapM_ solve $ groupn 2 $ words input

groupn :: Int -> [a] -> [[a]]
groupn n [] = []
groupn n xs = let (ys,zs) = splitAt n xs in ys : groupn n zs

solve :: [String] -> IO ()
solve [x,y] = putStrLn $ if isSubSeq x y then "Yes" else "No"

isSubSeq :: Eq a => [a] -> [a] -> Bool
isSubSeq [] _ = True
isSubSeq _ [] = False
isSubSeq (x:xs) (y:ys) = if x == y then isSubSeq xs ys else isSubSeq (x:xs) ys

