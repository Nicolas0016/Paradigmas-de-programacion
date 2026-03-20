# Introducción a Haskell:

Podemos definir funciones
```hs
f x = x + 1
```
Podemos aplciar funciones
```hs
f 5
(>) 6 1
```
¿Cual es la diferencia entre una variable de haskell y una variable de otro lenguaje?
- En Haskell, una variable es un símbolo que representa un valor, pero **no puede ser reasignada a otro valor**. Es decir, una vez que se le asigna un valor a una variable, ese valor no puede cambiar. En otros lenguajes de programación, como Python o JavaScript, las variables pueden ser reasignadas a diferentes valores a lo largo del programa. (las variables no variann, son constantes)

Ejercicio. Definir en haskell las siguientes funciones:

1. Promedio, que toma dos números y devuelve su promedio.

2. Máximo, que toma dos números y devuelve el mayor de ellos.

3. Factorial, que toma un número entero no negativo y devuelve su factorial. (el producto de todos los enteros desde 1 hasta n)

Respuestas:

```hs
-- Promedio
promedio :: Float -> Float -> Float
promedio a b = (a + b) / 2

-- Máximo
maximo :: Float -> Float -> Float
maximo a b = if a > b then a else b

-- Factorial
factorial :: Int -> Int
factorial n = if n == 0 then 1 else n * factorial (n - 1)
```

## Recursión en listas:

```hs
incN n [] = []
incN n (x:xs) = (x + n) : incN n xs
```
¿Qué hace esta función?
- Toma un número n y una lista de números xs, y devuelve una nueva lista donde cada elemento es el elemento correspondiente de xs sumado con n.

¿Qué devuelve incN 2 [3, 2, 3]?
- incN 2 [3, 2, 3] = (3 + 2) : incN 2 [2, 3] = 5 : incN 2 [2, 3] = 5 : (2 + 2) : incN 2 [3] = 5 : 4 : incN 2 [3] = 5 : 4 : (3 + 2) : incN 2 [] = 5 : 4 : 5 : [] = [5, 4, 5]

¿Qúe devuelve incN [2, 3, 2] []?
- Devuelve un error porque la función incN espera un número y una lista de números, y se le pasó una lista de números y una lista de números.

¿De qué tipo son las siguientes expresiones?

```hs
3 => Int
True => Bool
even => Int -> Bool
[1,2,3] => [Int]
[1,True] => Error
[[1]] => [[Int]]
[] => [a]
```

## Variables de tipo:
```hs
[] :: [a]
id :: a -> a
head :: [a] -> a
tail :: [a] -> [a]
const :: a -> b -> a
length :: [a] -> Int
```

¿Qué funciones son?
```hs
-- Suma
a1 x 0 = x
a1 x y = a1 x (y - 1) + 1

-- Multiplicación
a2 x 0 = 0
a2 x y = a2 (x-1) y + x

-- Potenciación
a3 x 0 = 0
a3 x y = a3 x (y-1) * x
```

Tipo de funciones:
f1 :: Int -> (Int -> Int)
f2 :: (Int -> Int) -> Int
f3 :: Int -> Int -> Int

> Obs: los parentesis son para agrupar, no son necesarios en este caso porque la asociatividad de la función es de izquierda a derecha.

