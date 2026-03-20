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
```hs
f1 :: Int -> (Int -> Int)
f2 :: (Int -> Int) -> Int
f3 :: Int -> Int -> Int
```
¿De que tipo son las siguientes expresiones?

```hs
f1 5 :: Int -> Int
f1 5 8 :: Int
f3 5 8 :: Int 
f3 5 :: Int -> Int
f2 5 :: error
f2 (+1) :: Int
```

## Convenciones de precedencia y asociatividad

+ Los tipos tienen asociatividad a derecha

$$a \to b \to c = a \to (b \to c) \neq (a \to b) \to c$$

+ La aplicación tiene asociatividad a izquierda
$$f x y = (f x) y \neq f (x y)$$

+ La aplicación tiene mayor precedencia que los operadores binarios 

$$f x + y = (f x) + y \neq f (x + y)$$

+ Los operadores binarios se pueden usar como funciones:
$$x + y = (+) \ x \ y$$

+ Las funciones se pueden usar como operadores binarios

$f x y = x f y$ 

## Tipos de datos algebraicos

```hs
data Bool = True | False

True :: Bool
False :: Bool
```

```hs
data Maybe a = Nothing | Just a
Nothing :: Maybe a
Just :: a -> Maybe a
```
> `Maybe a` es un tipo de dato que puede ser `Nothing` o `Just a`.
> + `Nothing` es un valor que representa la ausencia de un valor.
> + `Just a` es un valor que representa la presencia de un valor de tipo `a`.

```hs
data Either a b = Left a | Right b
Left :: a -> Either a b
Right :: b -> Either a b
```
> `Either a b` es un tipo de dato que puede ser `Left a` o `Right b`.
> + `Left a` es un valor que representa un error de tipo `a`.
> + `Right b` es un valor que representa un valor de tipo `b`.

Ejemplos:
+ `inverso :: Float -> Maybe Float`: Dado un número, devuelve su inverso multiplicativo si está definido, o Nothing en caso contrario.

+ `aEntero :: Either Int Bool -> Int`: Convierte una expresión que puede ser booleana o entera. En caso de los booleanos, el entero que corresponde es 0 para el False y 1 para el True.

```hs
inverso :: Float -> Maybe Float
inverso 0 = Nothing
inverso x = Just (1 / x)

aEntero :: Either Int Bool -> Int
aEntero (Left x) = x
aEntero (Right True) = 1
aEntero (Right False) = 0
```
