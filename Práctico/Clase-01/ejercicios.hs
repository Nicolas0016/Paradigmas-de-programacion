prod :: Int -> Int -> Int
prod x y = x * y

doble = prod 2
-- (.)
(.) :: (b -> c) -> (a -> b) -> a -> c
(.) f g x = f (g x)

-- flip
flip :: (a -> b -> c) -> b -> a -> c
flip f x y = f y x

-- ($)
($) :: (a -> b) -> a -> b
($) f x = f x

-- const
    
-- map :: (a -> b) -> [a] -> [b]
-- map [] = []
-- map f (x:xs) = f x : map f xs

-- ReverseAnidado
darVuelta :: [a] -> [a]
darVuelta [] = []
darVuelta (x:xs) = (darVuelta xs) ++ [x]

reverseAnidado :: [[Char]] -> [[Char]]
reverseAnidado xs = map reverse (reverse xs)

parCuadrado :: Int -> Int
parCuadrado x
    | (x `mod` 2 == 0) = x * x
    | otherwise = x
paresCuadrados :: [Int] -> [Int]
paresCuadrados [] = []
paresCuadrados xs = map parCuadrado xs
