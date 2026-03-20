## Currificación y aplicación parcial

```hs
prod :: (Int, Int) -> Int
prod (x,y) = x * y

prod' :: Int -> Int -> Int
prod' x y = x * y
```
> Las funciones en haskell siempre tomam un único argumento
Entonces ¿Qué hacen estas funciones?
+ `prod` recibe una tupla de dos elementos
+ `prod'` es una función que **toma un x** de tipo Int y devuelve una función de tipo Int -> Int, cuyo comportamiento es tomar un entero y multiplicarlo por x.

    En particular, `prod' 5` es una función que duplica.

    Una definición equivalente de prod' usando axiomas: `prod' x = \y -> x * y`

> Decimos que prod' es una versión currificada de prod.
### Curry y Uncurry
Ejercicio: Definir las siguientes funciones:
1. `curry:: ((a, b) -> c) -> (a-> b -> c)`
    Que devuelve una versión currificada de una función no currificada
2. `uncurry:: (a-> b -> c) -> ((a, b) -> c)`
    Que devuelve una versión no currificada de una función currificada

Respuesta:

```hs
curry :: ((a,b) -> c) -> a -> b -> c
curry f = \x -> \y -> f (x,y)

uncurry :: (a-> b -> c) -> ((a, b) -> c)
uncurry f = \(x,y) -> f x y
```
> Una función se le considera "currificada" si toma un solo argumento y devuelve una funcion que toma el siguiente argumento.

### Aplicación parcial
Sea la función:

```hs
prod :: Int -> Int -> Int
prod x y = x * y
```
Definimos `doble x = prod 2 x`
1. ¿Cuál es el tipo de doble?
2. ¿Qué pasa si cambiamos la definición por `doble = prod 2`?
3. ¿Qué significa `(+) 1`?
4. Definir las funciones de forma similar a (+) 1:
    + Triple :: Float -> Float
    + esMayorDeEdad :: Int -> Bool

Respuestas:
1. `doble :: Int -> Int`
2. Lo que ocurre si sacamos la `x` es que prod 2  nos devuelve una función que toma un entero y lo multiplica por 2. Es decir, `doble` es una función válida y su tipo será `Int -> Int`.
3. `(+) 1` es una función que toma un entero y le suma 1.
4. `(triple) = prod 3` y `(esMayorDeEdad) = (>=) 18`

### Funciones útiles:
1. Implementar y dar los tipos de las siguientes funciones:
    + `(.)` que descompone en dos funciones. Por ejemplo:

        ((\x -> x * 4) . (\y -> y - 3)) 10 devuelve 28.
    + `flip` que intercambia el orden de los argumentos de una función. Por ejemplo:

        flip (\x y -> x - y) 1 5, devuelve 4.
    + `($)` que aplica una función a un argumento. Por ejemplo:

        id $ 6 devuelve 6.
    + `const` que, dado un valor, retorna una función constante que devuelve siempre ese valor. Por ejemplo:
        
        const 5 "casa" devuelve 5
2. ¿Qué hace flip ($) 0?
3. ¿Y (==0) . (flip mod 2)?
Respuesta

```hs
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
const :: a -> b -> a
const x y = x
``` 

2. ¿Qué hace `flip ($) 0`?

Respuesta:

```hs
flip ($) 0 = ($) 0 = 0
```

3. ¿Y `(==0) . (flip mod 2)`?



> Hay más funciones útiles en la sección `útil` del campus. 

## Listas
Hay varias macros para definir listas:
+ Por extensión
    Esto es una lista explícita, escribiendo todos sus elementos `[1,5,6,5,4,8,6,1,3]`
+ Secuencias
    Son progresiones aritméticas en un rango particular`[1..10]`
+ Por comparación:
    def [expresión | selectores, condiciones]
    por ejemplo: `[(x,y) | x <- [0..5], y <- [0..3], x+y==4]` es una lista de pares (1,3), (2,2), (3,1) y (4,0).

Haskell también nos permite trabajar con listas infinitas
Algunos ejemplos:
+ naturales = [1..]
+ multiplos de 3 = [0, 3..]
+ repeat "hola"
+ primos = [n | n <- [2..], esPrimo n]
+ infinitosUnos = 1 : infinitosUnos

## Evaluación lazy
```hs
take :: Int -> [a] ->[a]
take 0 _ = []
take _ [] = []
take n (x:xs) = x : take (n-1) xs

infinitosUnos :: [Int]
infinitosUnos = 1 : infinitosUnos

nUnos :: Int -> [Int]
nUnos n = take n infinitosUnos
```
+ Si ejecutamos nUnos 2 ...
```hs
nUnos 2 → take 2 infinitosUnos → take 2 (1:infinitosUnos)→
1 : take (2-1) infinitosUnos → 1 : take 1 infinitosUnos →
1 : take 1 (1:infinitosUnos)→ 1 : 1: take (1-1)
infinitosUnos → 1 : take 0 infinitosUnos → 1 : 1 : []
```
+ ¿Qué sucedería si usáramos otra estrategia de redicción?

Si para algún término existe una reducción finita, entonces la estrategia de reducción lazy termina.

## Funciones de alto orden
Definamos las siguientes funciones:
Precondición: Todas las listas tienen algún elemento

+ maximo :: Ord a => [a] -> a
+ minimo :: Ord a => [a] -> a
+ listaMasCorta :: [[a]] -> [a]

Solución:

```hs
maximo :: Ord a => [a] -> a
maximo [x] = x
maximo (x:y:xs)
    | x > y = maximo (x:xs)
    | otherwise = maximo (y:xs)

minimo :: Ord a => [a] -> a
minimo [x] = x
minimo (x:y:xs)
    | x < y = minimo (x:xs)
    | otherwise = minimo (y:xs)

listaMasCorta :: [[a]] -> [a]
listaMasCorta [x] = x
listaMasCorta (x:y:xs)
    | length x < length y = listaMasCorta (x:xs)
    | otherwise = listaMasCorta (y:xs)

```
Siempre hago lo mismo... ¿Se podrá generalizar? ¿Cómo?

Ejercicio:
+ `mejorSegun :: (a -> a -> Bool) -> [a] -> a`
+ reescribir maximo y listaMasCorta en base a mejorSegun

Respuesta:

```hs
mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun f [x] = x
mejorSegun f (x:y:xs)
    | f x y = mejorSegun f (x:xs)
    | otherwise = mejorSegun f (y:xs)

maximo :: Ord a => [a] -> a
maximo = mejorSegun (>) 

listaMasCorta :: [[a]] -> [a]
listaMasCorta = mejorSegun (\x y -> length x < length y)
```

Filtrar elementos de una lista

```
filter :: (a->Bool) -> [a] -> [a]
filter p [] = []
filter p (x:xs) = 
    if p x
    then x : filter p xs
    else filter p xs
```
> Si P de x es verdadero hace todo lo que sigue, si no, hace lo que sigue del else.

Ejercicios Definir usando filter:

+ `deLongitudN :: Int -> [a] -> [a]`
+ `soloPuntosFijosEnN :: Int -> [Int -> Int] -> [Int -> Int]` Dados un número n y una lista de funciones, dejas las funciones que al aplicarlas a n dan n.

Respuesta:
```hs
deLongitudN :: Int -> [a] -> [a]
deLongitudN n xs = filter (\x -> length x == n) xs

soloPuntosFijosEnN :: Int -> [Int -> Int] -> [Int -> Int]
soloPuntosFijosEnN n xs = filter (\f -> f n == n) xs
```

Transformar elementos de una lista
```hs
map :: (a->b) -> [a] -> [b]
map f [] = []
map f (x:xs) = f x : map f xs
```
Ejercicio:
+ `reverseAnidado :: [[Char]] -> [[Char]]` que, dada una lista de strings, devuelve una lista con cada string dado vuelta y la lista completa dada vuelta. 
+ `paresCuadrados :: [Int] -> [Int]` que, dada una lista de enteros, devuelve una lista con los cuadrados de los números pares y los impares sin modificar.
Respuesta:
```hs
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
```

¿Hay similitud entre estas definiciones?

```hs
filter :: (a -> Bool) -> [a] -> [a]
filter [] = []
filter p (x:xs) = 
    if p x 
        then x : filter p xs
    else filter p xs
```

```hs
map :: (a -> b) -> [a] -> [b]
map [] = []
map f (x:xs) = f x : map f xs
```
+ En el caso base devolvemos un valor determinado.
En el caso recursivo devolvemos algo en funci´on de:
    + La cabeza de la lista.
    + El llamado recursivo sobre la cola de la lista.

```hs
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr z [] = z
foldr f z (x:xs) = f x (foldr f z xs)
```
+ z es el valor que devolvemos para una lista vacía. 
+ f es una función que computa el resultado sobre la listaentera a partir de:
    + La cabeza de la lista.
    + El llamado recursivo sobre la cola de la lista.

>Ejemplo:
>
>Si xs = [x1, x2, x3] entonces:
>
>foldr f z xs = f x1 (f x2 (f x3 z))
>
>Equivalentemente con notaci´on infija:
>
>foldr ⋆ z xs = x1 ⋆ (x2 ⋆ (x3 ⋆ z))

Reescribiendo filter y map con foldr


```hs
filter :: (a -> Bool) -> [a] -> [a]
filter p xs = 
    foldr (\x r -> if p x then x:r else r) [] xs

map :: (a -> b) -> [a] -> [b]
map f xs = foldr (\x r -> f x : r ) [] xs
```
> En este caso no es necesario el `xs` porque `foldr` ya captura la lista como su último argumento, permitiendo una definición más elegante y en estilo `point-free`.

Definir una expresión equivalente a las siguiente utilizando map y filter:
```hs
-- Ejercicio
listaComp :: (a -> Bool) -> (a -> b) -> [a] -> [b]
listaComp p f xs = [f x | x <- xs, p x]
```
Respuesta:
```hs
listaComp :: (a -> Bool) -> (a -> b) -> [a] -> [b]
listaComp p f xs = map f (filter p xs)
```
