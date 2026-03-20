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