-- Dado un enteor n >= , devuelve n!

factorial :: Int -> Int
factorial n 
    | n <= 1 = 1
    | otherwise = n * factorial (n-1)

-- Dado un entero k y una lista xs, devuelve la lista que resulta de sumarle k a cada elemento de xs.
sumaN:: Int -> [Int] -> [Int]
sumaN _ [] = []
sumaN k (x:xs) = (x+k) : sumaN k xs 

-- Dado un elemento x y una lista xs, devuelve un booleano que indica si x aparece en xs.
aparece :: Eq a => a -> [a] -> Bool
aparece _ [] = False
aparece x (y:ys) = (x == y) || aparece x ys

-- Dada una lista, devuelve su permutación ordenada.
minimo :: Ord a => [a] -> a
minimo [x] = x
minimo (x:y:xs)
    | x < y = minimo (x:xs) 
    | otherwise = minimo(y:xs)

eliminar :: Eq a => a -> [a] -> [a]
eliminar _ [] = []
eliminar x (y:ys) 
    | x == y = ys
    | otherwise = x : eliminar y ys

ordenar :: Ord a => [a] -> [a]
ordenar [] = [] 
ordenar xs = (minimo xs ): ordenar((eliminar (minimo xs) xs))

-- Dado el siguiente tipo de datos
data Direccion = Norte | Este | Sur | Oeste
opuesta :: Direccion -> Direccion
opuesta Norte = Sur
opuesta Este  = Oeste
opuesta Sur   = Norte
opuesta Oeste = Este

data Maybe a = Nothing | Just a
data AB a = Nil | Bin (AB a) a (AB a)

-- Dados los siguientes tipos de datos:
data Maybe a = Nothing | Just a
data AB a = Nil | Bin (AB a) a (AB a)
--definir la funci´on
buscar :: Eq a => a -> AB (a, b) -> Maybe b
--que dada una clave k y un ásrbol binario de pares clave/valor,
--devuelve el valor asociado a la clave k en caso de que exista.