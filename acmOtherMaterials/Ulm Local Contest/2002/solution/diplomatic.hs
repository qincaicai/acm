-- Problem   Diplomatic License
-- Algorithm Geometry
-- Runtime   O(n)
-- Author    Walter Guttmann
-- Date      30.05.2002

import Complex

main :: IO ()
main = readFile "diplomatic.in" >>=
       mapM_ (putStrLn . pretty . solve . parse) . cases . map read . words

type Case  = [Point]
type Point = Complex Double

cases :: [Double] -> [[Double]]
cases [] = []
cases (d:xs) = let (ys,zs) = splitAt (2 * round d) xs in ys : cases zs

parse :: [Double] -> Case
parse [] = []
parse (x:y:xs) = x:+y : parse xs

solve :: Case -> Case
solve ps = zipWith (\x y -> (x + y) / 2.0) ps (tail ps ++ [head ps])

pretty :: Case -> String
pretty ps = show (length ps) ++
            concat [ " " ++ show x ++ " " ++ show y | x:+y <- ps ]

