# Repaso
## Las funciones map y filter 

```haskell
map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x:xs) = f x : map f xs

filter :: (a -> Bool) -> [a] -> [a]
filter f [] = []
filter f (x:xs)
    | f x       = x : filter f xs
    | otherwise = filter f xs
```
¿Qué tipo tiene la expresión map filter?
¿Cómo la podríamos usar?

> Respuesta

El tipo es `(a -> b) -> (a -> Bool) -> [a] -> [b]`

```haskell
map filter :: (a -> b) -> (a -> Bool) -> [a] -> [b]
map filter f g xs = map f (filter g xs)
```

## Funciones anonimas 

### Notación "lambda"
Una expresión de la forma 
```hs
\x -> e
```
Representa una función que recibe un párametro x y devuelve e. 
$$(\ x_1 x_2 ... x_n -> e) ≡ (\ x_1 -> (\ x_2 -> ... (\ x_n -> e)))$$

> Ejemplo

```hs
map(\x ->(x,x)) [1,2,3]
-- resultado: [(1,1),(2,2),(3,3)]
```

## Funciones de orden superior
¿Qué relación hay entre las siguientes funciones?
```hs
suma :: Int -> Int -> Int
suma x y = x + y

suma' :: (Int, Int) -> Int
suma' (x, y) = x + y
```
Estan relacionadas del siguiente modo:

```hs
curry :: ((a,b) -> c) -> a -> b -> c
curry f x y = f (x,y)

uncurry :: (a -> b -> c) -> (a,b) -> c
uncurry f (x,y) = f x y
```
> llamamos curry a la forma de pasarle los argumentos de a uno y uncurry a la forma de pasarle los argumentos de a dos.

# Esquemas de recursión sobre listas
Pensemos algunas funciones sobre listas
+ sumaL: suma todos los valores de una lista de enteros
+ concatena: la concatenación de todos los elementos de una lista de listas
+ reverso: el reverso de una lista

```hs
sumaL :: [Int] -> Int
sumaL [] = 0
sumaL (x:xs) = x + sumaL xs

concatena :: [[a]] -> [a]
concatena [] = []
concatena (xs:xss) = xs ++ concatena xss

reverso :: [a] -> [a]
reverso [] = []
reverso (x:xs) = reverso xs ++ [x]
```

Tienen una relación cada una:
Sea `g:: [a] -> b` definida por dos ecuaciones:
    + `g [] = y` (caso base)
    + `g (x:xs) = h x (g xs)` (caso recursivo)

> `g` esta dada por una **recursión estructural** si:
> + El caso base devuelve un valor fijo `z`
> + El caso recursivo se escribe usando (cero, una o muchas veces) `x y (g xs)`, pero sin usar el valor de `xs` ni otros llamados recursivos.
>
>   `g [] = z`
>
>   `g (x:xs) = ... x ... (g xs) ...`


## Ejemplos de recursión estructural

```hs
suma::[Int] -> Int
suma [] = 0
suma (x:xs) = x + suma xs

(++) :: [a] -> [a] -> [a]
[] ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)

-- Insertion sort
isort :: Ord a => [a] -> [a]
isort [] = []
isort (x:xs) = insert x (isort xs)

```
> insert: es una función que recibe un elemento y una lista ordenada y devuelve una lista ordenada con el elemento insertado.

Ejemplo
```hs
-- Selection sort
ssort :: Ord a => [a] -> [a]
ssort [] = []
ssort xs = minimo xs : ssort (borrar (minimo xs) xs)
```
¿Es una recursión estructural?

> Respuesta: No, porque en el caso recursivo se usa el valor de `xs`.

## Plegado de listas a la derecha

La función `foldr` es una función estructural:

```hs
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z [] = z
foldr f z (x:xs) = f x (foldr f z xs)
```
> Lo que hace es reemplazar cada `[]` por `z` y cada `(:)` por `f`. Logrando que la recursión estructural se pueda escribir como un plegado.
> Ejemplo:

```hs
sumaL :: [Int] -> Int
sumaL [] = 0
sumaL (x:xs) = x + sumaL xs

-- Usando foldr
sumaL' :: [Int] -> Int
sumaL' = foldr (+) 0
```

Entonces:
```hs
suma[1,2] -> foldr (+) 0 [1,2]
          -> (+) 1 + (foldr (+) 0 [2])
          -> (+) 1 + ((+) 2 + (foldr (+) 0 []))
          -> (+) 1 + ((+) 2 + 0)
          -> (+) 1 + 2
          -> 3
```

Análogicamente:
```hs
producto :: [Int] -> Int
producto = foldr (*) 1

and, or :: [Bool] -> Bool
and = foldr (&&) True
or = foldr (||) False
```
Otro ejemplo:
```hs
reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = reverse xs ++ [x]

-- Usando foldr
reverse' :: [a] -> [a]
reverse' = foldr (\x rec -> rec ++ [x]) []
```
Ilustración gráfica del plegado a derecha:

$$
\begin{array}{ccccccccc}
 & & f & & & & & & \\
 & \swarrow & & \searrow & & & & & \\
x_1 & & & & f & & & & \\
 & & & \swarrow & & \searrow & & & \\
 & & x_2 & & & & f & & \\
 & & & & & \swarrow & & \searrow & \\
 & & & & x_3 & & & & z \\
\end{array}
$$

En particular se puede demostrar que:

```hs
foldr (:) [] = id
foldr (: . f) [] = map f
foldr (const (+ 1)) 0 = length
```

## Recursión primitiva
Sea `g :: [a] -> b` definida por dos ecuaciones:

+ `g [] = y` (caso base)
+ `g (x:xs) = h x (g xs)` (caso recursivo)

Decimos que `g` es una **recursión primitiva** si:
1. El caso recursivo devuelve un valor fijo z
2. El caso recursivo se escribe usando cero, una o muchas veces `x` y `g xs`, **también `xs`**, pero sin hacer otros llamados recursivos

```hs
g [] = z
g (x:xs) = ... x ... xs ... (g xs) ...
```

> Similar a la recursión estructural, pero permite referirse a `xs`.

> Observación:
> + Todas las definiciones dadas por recursión estructural también estan dadas por recursión primitiva
> + Hay definiciones dadas por recursión primitiva que no están dadas por recursión estructural.

Ejemplo: Dado un texto borrar todos sus espacios iniciales
```hs
trim :: String -> String
-- trim "     Hola PLP" = "Hola PLP"
trim [] = []
trim (x:xs)
    | x == ' ' = trim xs
    | otherwise = x:xs
```
Intenten hacerlo con foldr
```hs
trim = foldr (\x rec -> if x == ' ' then rec else x:rec) []
```
¿Es una recursión estructural?

> Respuesta: No, porque en el caso recursivo se usa el valor de `xs`.

Escribamos una función recr para abstraer el esquema de recursión primitiva.

```hs
recr :: (a -> b -> [a] -> b) -> b -> [a] -> b
recr f z [] = z
recr f z (x:xs) = f x (recr f z xs) xs
```
**Toda recursión primitiva es una instancia de `recr`.**

Escribamos `trim` ahora usando recr:
```hs
trim = recr (\x xs rec -> if x == ' ' then rec else x:xs) []
```
## Recursión iterativa

Sea `g :: [a] -> b` definida por dos ecuaciones:

+ `g [] = y` (caso base)
+ `g (x:xs) = g (f x xs)` (caso recursivo)

Decimos que la definición es una **recursión iterativa** si:
+ El caso base devuelve el acumulador `ac`
+ El caso recursivo invoca inmediatamente a `(g ac' xs)` donde `ac'` es el nuevo acumulador y el valor de x.