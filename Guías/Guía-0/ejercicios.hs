-- ValorAbsoluto: que dado un número devuelve su valor absoluto.
valorAbsoluto :: Float -> Float
valorAbsoluto x 
    | x > 0 = x
    | x < 0 = -x

-- bisiesto: dado un número que representa un año, indica si el mismo es bisiesto
bisiesto :: Int -> Bool
bisiesto anio
    | divisiblePor4 && not divisiblePor100 || divisiblePor400 = True
    | otherwise = False
    where
        divisiblePor4 = anio `mod` 4 == 0
        divisiblePor100 = anio `mod` 100 == 0
        divisiblePor400 = anio `mod` 400 == 0

-- factorial
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- cantDivisoresPrimos
cantDivisoresPrimos :: Int -> Int
cantDivisoresPrimos n 
    | n < 2 = 0
    | otherwise = iCantDivisoresPrimos 2 n

iCantDivisoresPrimos :: Int -> Int -> Int
iCantDivisoresPrimos i n
    | i > n = 0
    | esPrimo i && n `mod` i == 0 = 1 + iCantDivisoresPrimos (i + 1) n
    | otherwise = iCantDivisoresPrimos (i + 1) n

esPrimo :: Int -> Bool
esPrimo n
    | n < 2 = False
    | otherwise = iEsPrimo (n-1) n

iEsPrimo :: Int -> Int -> Bool
iEsPrimo i n
    | i == 1 = True
    | n `mod` i == 0 = False
    | otherwise = iEsPrimo (i - 1) n

-- inverso : dado un número devuelve su inverso multiplicativo si está definido, o Nothing en caso contrario.
inverso :: Float -> Maybe Float
inverso x
    | x== 0 = Nothing
    | otherwise = Just (1/x)

-- aEntero : convierte a entero una expresión que puede ser booleana o entera.
aEntero :: Either Int Bool -> Int
aEntero (Left x) = x
aEntero (Right True) = 1
aEntero (Right False) = 0

-- limpiar: elimina todas las apariciones de cualquier carácter de la primera cadena en la segunda.
limpiar :: String -> String -> String
limpiar [] palabra = palabra
limpiar (letra_eliminar:xs) palabra = limpiar xs (eliminarLetra letra_eliminar palabra)

eliminarLetra :: Char -> String -> String
eliminarLetra _ [] = []
eliminarLetra letra_eliminar (letra_palabra:xs)
    | letra_eliminar == letra_palabra = eliminarLetra letra_eliminar xs
    | otherwise = letra_palabra : eliminarLetra letra_eliminar xs


-- difPromedio: que dada una lista de números devuelve la diferencia de cada uno con el promedio general.

difPromedio :: [Float] -> [Float]
difPromedio xs = difPromedio2 xs ((sum xs) / fromIntegral (length xs))

difPromedio2 :: [Float] -> Float -> [Float]
difPromedio2 [] _ = [] 
difPromedio2 (x:xs) promedio = (x - promedio) : difPromedio2 xs promedio

-- todosIguales: que indica si una lista de enteros tiene todos sus elementos iguales.

todosIguales :: [Int] -> Bool
todosIguales [x] = True
todosIguales (x_1 : x_2 : xs) = (x_1 == x_2) && todosIguales (x_2:xs)

data AB a = Nil | Bin (AB a) a (AB a)
-- vacioAB
vacioAB:: AB a -> Bool
vacioAB Nil = True
vacioAB _ = False
-- negaciónAB
negacionAB:: AB Bool -> AB Bool
negacionAB Nil = Nil
negacionAB (Bin izq val der) = Bin (negacionAB izq) (not val) (negacionAB der)

producto:: AB Int -> Int
producto Nil = 1
producto (Bin izq val der) = producto izq * val * producto der
