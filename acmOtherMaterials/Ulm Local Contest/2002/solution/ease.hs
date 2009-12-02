-- Problem   Polygon Programming with Ease
-- Algorithm Geometry
-- Runtime   O(n)
-- Author    Walter Guttmann
-- Date      30.05.2002

import Complex

main :: IO ()
main = readFile "ease.in" >>=
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
solve ps = init qs
  where rotate x y = y + (y - x)
        p1 = head ps
        p2 = foldl1 rotate ps
        p3 = (p1 + p2) / 2.0
        qs = scanl rotate p3 ps

pretty :: Case -> String
pretty ps = show (length ps) ++
            concat [ " " ++ show x ++ " " ++ show y | x:+y <- ps ]

