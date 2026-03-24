# Ejercicio 1
Dar el tipo y describir el comportamiento de las siguientes funciones del módulo `Prelude` de Haskell:

```hs
null head tail init las take drop (++) concat reverse elem
```
> Respuesta:
+ `null :: [a] -> Bool`
    Devuelve `True` si la lista está vacía, `False` en caso contrario.
+ `head :: [a] -> a`
    Devuelve el primer elemento de la lista.
+ `tail :: [a] -> [a]`
    Devuelve la lista sin el primer elemento.
+ `init :: [a] -> [a]`
    Devuelve la lista sin el último elemento.
+ `last :: [a] -> a`
    Devuelve el último elemento de la lista.
+ `take :: Int -> [a] -> [a]`
    Devuelve los primeros `n` elementos de la lista.
+ `drop :: Int -> [a] -> [a]`
    Devuelve la lista sin los primeros `n` elementos.
+ `(++) :: [a] -> [a] -> [a]`
    Concatena dos listas.
+ `concat :: [[a]] -> [a]`
    Concatena una lista de listas.
+ `reverse :: [a] -> [a]`
    Invierte el orden de los elementos de la lista.
+ `elem :: Eq a => a -> [a] -> Bool`
    Devuelve `True` si el elemento está en la lista, `False` en caso contrario.

# Ejercicio 2
Definir las siguientes funciones:
1. valorAbsoluto :: Float -> Float, que dado un número devuelve su valor absoluto.
2. bisiesto :: Int -> Bool, que dado un número que represetna un año, indica si el mismo es bisiesto
3. factorial :: Int -> Int, definida únicamente para enteros positivos, que computa el factorial
4. cantDivisoresPrimos :: Int -> Int, que dado un entero positov devuelve la cantidad de divisores primos.

> Respuesta
```hs
--- valorAbsoluto
valorAbsoluto :: Float -> Float
valorAbsoluto x 
    | x > 0 = x
    | otherwise = -x

--- bisiesto
bisiesto :: Int -> Bool
bisiesto anio
    | divisiblePor4 && not divisiblePor100 || divisiblePor400 = True
    | otherwise = False
    where
        divisiblePor4 = anio `mod` 4 == 0
        divisiblePor100 = anio `mod` 100 == 0
        divisiblePor400 = anio `mod` 400 == 0

--- factorial
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

--- cantDivisoresPrimos
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
```
# Ejercicio 3 
Contamos con los tipos `Maybe` y `Either` definidos como sigue:
```hs
data Maybe a = Nothing | Just a
data Either a b = Left a | Right b
```
a. Definir la función `inverso :: Float -> Maybe Float` que dado un número devuelve su inverso multiplicativo
si está definido, o `Nothing` en caso contrario.
b. Definir la función `aEntero :: Either Int Bool -> Int` que convierte a entero una expresión que puede ser
booleana o entera. En el caso de los booleanos, el entero que corresponde es 0 para `False` y 1 para `True`.

> Respuesta
```hs
-- inverso
inverso :: Float -> Maybe Float
inverso x
    | x== 0 = Nothing
    | otherwise = Just (1/x)

-- aEntero
aEntero :: Either Int Bool -> Int
aEntero (Left x) = x
aEntero (Right True) = 1
aEntero (Right False) = 0
```

# Ejercicio 4
Definir las siguietnes funciones sobre listas: 

1. `limpiar :: String -> String -> String`, que elimina todas las apariciones de cualquier carácter de la primera cadena en la segunda. Por ejemplo , `limpiar "aeiou" "hola mundo"` debería devolver `"hll mnd"`.

2. `difPromedio :: [Float] -> [Float]` que dada una lsita de números devuelve la diferencia de cada uno con el promedio general. Por ejemplo, `difPromedio [1,2,3,4,5]` debería devolver `[-2,-1,0,1,2]`.

3. `todosIguales :: [Int] -> Bool` que indica si una lista de enteros tiene todos sus elementos iguales. 


> Respuesta
```hs
-- limpiar
limpiar :: String -> String -> String
limpiar [] palabra = palabra
limpiar (letra_eliminar:xs) palabra = limpiar xs (eliminarLetra letra_eliminar palabra)

eliminarLetra :: Char -> String -> String
eliminarLetra _ [] = []
eliminarLetra letra_eliminar (letra_palabra:xs)
    | letra_eliminar == letra_palabra = eliminarLetra letra_eliminar xs
    | otherwise = letra_palabra : eliminarLetra letra_eliminar xs

-- difPromedio

difPromedio :: [Float] -> [Float]
difPromedio xs = difPromedio2 xs ((sum xs) / fromIntegral (length xs))

difPromedio2 :: [Float] -> Float -> [Float]
difPromedio2 [] _ = [] 
difPromedio2 (x:xs) promedio = (x - promedio) : difPromedio2 xs promedio

-- todosIguales

todosIguales :: [Int] -> Bool
todosIguales [x] = True
todosIguales (x_1 : x_2 : xs) = (x_1 == x_2) && todosIguales (x_2:xs)
```

# Ejercicio 5
Dado el siguiente modelo para árboles binarios
```hs
data Arbol a = Hoja | Nodo a (Arbol a) (Arbol a)
-- In haskell
data AB a = Nil | Bin (AB a) a (AB a)
```
> `Bin (AB a) a (AB a)` es un árbol binario con raíz en `a` y subárboles izquierdo y derecho. Con raíz nos referimos al valor que se encuentra en el nodo.

> `Nil` es un árbol binario vacío.

1. `vacioAB :: Arbol a -> Bool` que dado un árbol indica si el mismo está vacío.
2. `negacionAB :: Arbol Bool -> Arbol Bool` que dado un árbol de booleanos devuelve otro árbol con los valores negados.
3. `productoAB :: AB Int -> Int` que calcula el producto de todos los nodos del árbol

> Respuesta
```hs
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
```
> Para trabajar con un arbol binario en haskell se puede usar la siguiente sintaxis:
+ `Nil` es un árbol binario vacío.
+ `Bin izq val der` es un árbol binario con raíz en `val` y subárboles izquierdo y derecho `izq` y `der` respectivamente.
+ `Bin (Bin Nil 1 Nil) 2 (Bin Nil 3 Nil)` es un árbol binario con raíz en 2 y subárboles izquierdo y derecho `Bin Nil 1 Nil` y `Bin Nil 3 Nil` respectivamente.

