-- Promedio, que toma dos números y devuelve su promedio.
promedio :: Float -> Float -> Float
promedio a b = (a + b) / 2


-- Máximo, que toma dos números y devuelve el mayor de ellos.
maximo :: Ord a => a -> a -> a
maximo a b 
    | a > b = a
    | otherwise = b

-- Factorial, que toma un número entero no negativo y devuelve su factorial.
factorial:: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n-1)

-- Inverso, que toma un número y devuelve su inverso multiplicativo si está definido, o Nothing en caso contrario.
inverso :: Float -> Maybe Float
inverso 0 = Nothing
inverso x = Just (1 / x)

-- aEntero, que toma una expresión que puede ser booleana o entera. En caso de los booleanos, el entero que corresponde es 0 para el False y 1 para el True.
aEntero :: Either Int Bool -> Int
aEntero (Left x) = x
aEntero (Right True) = 1
aEntero (Right False) = 0