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

Ejemplos de recursión iterativa:

```hs
-- Reverse con acumulador
reverse' :: [a] -> [a] -> [a]
reverse' [] ac = ac
reverse' (x:xs) ac = reverse' xs (x:ac)

-- reverse' [1,2,3] []
-- reverse' [2,3] [1]
-- reverse' [3] [2,1]
-- reverse' [] [3,2,1]
-- [3,2,1]

-- Pasaje de binario a decimal con acumulador.
bin2dec' :: [Int] -> Int -> Int
bin2dec' [] ac = ac
bin2dec' (x:xs) ac = bin2dec' xs (ac * 2 + x)

-- bin2dec' [1,0,1,1] 0
-- bin2dec' [0,1,1] 1
-- bin2dec' [1,1] 2
-- bin2dec' [1] 5
-- bin2dec' [] 11
-- 11

-- Insertion sort con acumulador
insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys)
    | x <= y    = x : y : ys
    | otherwise = y : insert x ys

isort' :: Ord a => [a] -> [a] -> [a]
isort' [] ac = ac
isort' (x:xs) ac = isort' xs (insert x ac)

-- isort' [3,1,2] []
-- isort' [1,2] [3]
-- isort' [2] [1,3]
-- isort' [] [1,2,3]
-- [1,2,3]
```

## Plegado de listas a izquierda

Escribimos una función `foldl` para abstrer el esquema de recursión iterativa:
```hs
foldl f ac [] = ac 
foldl f ac (x:xs) = foldl f (f ac x) xs
```

**Toda recursión iterativa es una instancia de `foldl`.**

En general `foldl` y `foldr` tienen comportamientos diferentes: 


$$foldr \star z [x_1,x_2,x_3] = x_1 \star (x_2 \star (x_3 \star z))$$

$$foldl \star z [x_1,x_2,x_3] = ((z \star x_1) \star x_2) \star x_3$$

> Si $\ \star$ es asociativa, entonces `foldr` y `foldl` son equivalentes.

Ejemplo -  pasaje de binario a decimal

```hs
bin2dec :: [Int] -> Int
bin2dec = foldl (\ac x -> ac * 2 + x) 0
-- bin [1,0,1]
-- foldl (\ ac x -> ac * 2 + x) 0 [1,0,1]
-- foldl (\ ac x -> ac * 2 + x) (0 * 2 + 1) [0,1]
-- foldl (\ ac x -> ac * 2 + x) 1 [0,1]
-- foldl (\ ac x -> ac * 2 + x) (1 * 2 + 0) [1]
-- foldl (\ ac x -> ac * 2 + x) 2 [1]
-- foldl (\ ac x -> ac * 2 + x) (2 * 2 + 1) []
-- foldl (\ ac x -> ac * 2 + x) 5 []
-- 5
```

En particular, se puede demostrar que:

```hs
foldl (flip (:)) [] = reverse
```
Vimos los siguientes esquemas de recursión sobre listas:
1. $\text{Recursión estructural} \implies \text{foldr}$
2. $\text{Recursión primitiva} \implies \text{recr}$
3. $\text{Recursión iterativa} \implies \text{foldl}$

# Tipos de datos algebraicos
Conocemos los tipos de datos primitivos:

```hs
Char Int Float (a->b) (a,b) [a]
```

Se pueden definir nuevos tipos de datos con la cláusula `data`:
```hs
data Tipo = <Declarción de los constructores>
```

> Ejemplo tipos enumerados:
Muchos constructores sin parámetros

```hs
data Dia = Lun | Mar | Mie | Jue | Vie | Sab | Dom
```
Declara que existen constructores:
```hs
Domingo :: Dia 
```
Declara además esos son los únicos constructores del tipo Dia.

```hs
esFinDeSemana :: Dia -> Bool
esFinDeSemana Sab = True
esFinDeSemana Dom = True
esFinDeSemana _ = False
```

> Ejemplo tipos producto (tuplas/estructuras/registros)

Un solo constructor con muchos parámetros:
```hs
data Persona = LaPersona String String Int
```
> Donde el primer string es el nombre, el segundo el apellido y el tercero la edad.
La declara el tipo Persona un constructor (y solo ese):
```hs
LaPersona :: String -> String -> Int -> Persona
nombre, apellido :: Persona -> String
nombre (LaPersona n _ _) = n
apellido (LaPersona _ a _) = a
fechaNacimiento :: Persona -> Int
fechaNacimiento (LaPersona _ _ f) = f
```

Un tipo puede tener muchos constructores con muchos parámetros:
```hs
data Figura = 
    Rectangulo Float Float 
    | Circulo Float
```
Declara que el tipo Forma tiene dos constructores: `Rectangulo` y `Circulo`.

```hs
Rectangulo :: Float -> Float -> Figura
Circulo :: Float -> Figura
```

```hs
area :: Figura -> Float
area (Rectangulo base altura) = base * altura
area (Circulo radio) = pi * radio * radio
```

Algunos costructores pueden ser recursivos:

```hs
data Nat = Zero | Succ Nat

-- Zero es el 0
-- Succ n es el sucesor de n

-- 0 -> Zero
-- 1 -> Succ Zero
-- 2 -> Succ (Succ Zero)
-- 3 -> Succ (Succ (Succ Zero))
```

Declara que el tipo tiene dos constructores:
```hs
Zero :: Nat
Succ :: Nat -> Nat
```

En general un tipo de dato algebraico tiene la siguiente forma:

$$
\begin{align*}
data T = & CBase_1<Params_1> \mid 
\cdots \mid
CBase_n<Params_n> \mid \\
& CRec_1<Params_{n+1}> \mid 
\cdots \mid
CRec_k<Params_{n+k}>
\end{align*}
$$

+ Los constructores base no reciben parámetros T
+ Los constructores recursivos de tipo T.
+ Los valores de tipo T son los que se pueden construir aplicando constructores base y recursivos un número finito de veces y solo esos.

> Ejemplo cuentas corrientes
```hs
type Cuenta = String
data Banco = Iniciar
| Depositar Cuenta Int Banco
| Extraer Cuenta Int Banco
| Transferir Cuenta Cuenta Int Banco
bancoPLP = Transferir "A" "B" 3 (Depositar "A" 10 Iniciar)
saldo :: Cuenta -> Banco -> Int
saldo cuenta Iniciar = 0
saldo cuenta (Depositar cuenta’ monto banco)
| cuenta == cuenta’ = saldo cuenta banco + monto
| otherwise = saldo cuenta banco
saldo cuenta (Extraer cuenta’ monto banco)
| cuenta == cuenta’ = saldo cuenta banco - monto
| otherwise = saldo cuenta banco
saldo cuenta (Transferir origen destino monto banco)
| cuenta == origen = saldo cuenta banco - monto
| cuenta == destino = saldo cuenta banco + monto
| otherwise = saldo cuenta banc0
```
> OBS del ejemplo:
> + No hay constructores base
> + Todos los constructores son recursivos
> + No se puede construir un banco vacío
> + No se puede definir un banco sin operaciones

De hecho, las listas son un tipo de dato algebraico:
```hs
data [a] = [] | a : [a]
```

# Esquemas de recursión sobre otras estructuras: 

En caso de las listas, dada una función `g :: [a]-> b `:
```
g [] = <caso base>
g (x:xs) = <caso recursivo>
```
decíamos que `g` estaba dada por recursión estructural si:
+ El caso base devueñve un valor fijo z
+ El caso recursivo se escribe usando `x`, `xs` y `g`, pero sin usar el valor de xs ni otros llamdos recursivos.


## Recursión estructural
La recursión estructural se generaliza a tipos algebraicos en general. 
Supongamos que T es un tipo algebraico.
Dada una función `g :: T -> Y` definida por ecuaciones:

$$g(Cbase_1 <parámetros>) = <caso base_1>$$
...
$$g(Cbase_n <parámetros>) = <caso base_n>$$
$$g(Crecursivo_1 <parámetros>) = <caso recursivo_1>$$
...
$$g(Crecursivo_k <parámetros>) = <caso recursivo_k>$$

Decimos que g está dada por recursión estructural si:
+ Cada caso base se escribe combinando los parámetros
+ Cada caso recursivo se escribe combinando:
    + Los paráetros del constructor que no son tipo T
    + El llamado recursivo sobre cada parámetro de tipo T
Pero:
+ Sin usar los parámetros del constructor que son de tipo T.
+ Sin usar otros llamados recursivos.

```hs
data AB = Nil | A AB | B AB

-- Nil es el caso base
-- A y B son casos recursivos

-- length :: AB -> Int
-- length Nil = 0
-- length (A a) = 1 + length a
-- length (B b) = 1 + length b
```
Si definimos una función foldAB que abstraiga el esquema de recursión estructural sobre árboles binarios.
```hs
foldAB :: b -> (b -> a -> b -> b) -> AB a -> b
foldAB cNil cBin Nil = cNil
foldAB cNil cBin (Bin i r d) =
cBin (foldAB cNil cBin i) r (foldAB cNil cBin d)
```
>Ejemplo
1. ¿Qué función es `(foldAB Nil Bin)`?
2. Definir `mapAB :: (a -> b) -> AB a -> AB b` usando `foldAB`.
3. Definir `maximo :: AB a -> Maybe a` usando `foldAB`.
4. Definir `altura :: AB a -> Int` usando `foldAB`.
5. ¿Se puede definir la función `ordenado :: AB a -> Bool` usando `foldAB`?
6. ¿Se puede definir la función `caminoMasLargo :: AB a -> [a]` usando `foldAB`?
> Respuestas
1. La función `(foldAB Nil Bin)` es la función `id`.
2. `mapAB f = foldAB Nil (Bin . f)`
