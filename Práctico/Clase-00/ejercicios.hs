-- Promedio, que toma dos números y devuelve su promedio.
promedio :: Float -> Float -> Float
promedio a b = (a + b) / 2


-- Máximo, que toma dos números y devuelve el mayor de ellos.
maximo :: Ord a => a -> a -> a
maximo a b 
    | a > b = a
    | otherwise = b

factorial:: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n-1)