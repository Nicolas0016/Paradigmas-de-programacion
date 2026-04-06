Si quiero escribir la función `sublistaQueMasSuma :: [Int] -> [Int]`

```hs
sublistaQueMasSuma :: [Int] -> [Int]
sublistaQueMasSuma = 
    recr (\x xs res -> 
        if (sum . prefijoQueMasSuma) (x:xs) > sum res 
            then prefijoQueMasSuma (x:xs) 
            else res) []
```
> Esto lo que hace es recorrer la lista y en cada paso se fija si el prefijo que mas suma de la lista actual es mayor que el prefijo que mas suma del resto de la lista. Si es asi, se queda con el prefijo que mas suma de la lista actual, si no, se queda con el prefijo que mas suma del resto de la lista.

# Generación infinita:
pares :: [(Int,Int)], una lista infinita que contenga todos los pares de numeros naturales sin repetir.
```hs
pares = [(x,y) | x <- [0..], y <- [0..]]
```
¿Y en que posición está el (2,1)?¿Se genera?

```hs
pares :: [(Int,Int)]
pares = [p | k <- [0..], p <- paresDeSuma k]

paresDeSuma :: Int -> [(Int,Int)]
paresDeSuma k = [(i,k-i) | i <- [0..k]]
```


# Folds sobre nuevas estructuras

Sea el tipo data `AB a = Hoja a | Bin(AEB a) a Bin(AEB a)`

Definir el esquema de recursión estructural (fold) para árboles estrictamente binarios, y dar su tipo

El esquema debe permitir definir las funciones altura, ramas, cantidad de nodos, cantidad de hojas, espejo, etc.

¿Cómo hacemos?

Recordamos el tipo foldr, el esquema de recursión estructural para listas
```hs
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z [] = z
foldr f z (x:xs) = f x (foldr f z xs)
```
> ej: `sum`
```hs
sum :: Num a => [a] -> a
sum = foldr (+) 0
```
> sum [1,2,3] = foldr (+) 0 [1,2,3] = 1 + (foldr (+) 0 [2,3]) = 1 + (2 + (foldr (+) 0 [3])) = 1 + (2 + (3 + (foldr (+) 0 []))) = 1 + (2 + (3 + 0)) = 6

¿Por qué tiene este tipo?
Un esquema de recursión estructural espera recibir un argumento por cada constructor, y además la estructura que va a recorrer.

El tipo de cada argumento va a depender de lo que reciba el constructor correspondiente.

Si el constructor es recursivo, el argumento corresponde del fold va a recibir el resultado de cada llamada recursiva.

Si miramos bien la estructura del tipo, estamos ante un tipo inductivo con un contructor no recursivo y un constructor recursivo.

```hs
foldAEB :: (a->b) -> (b->a->b->b) -> AB a -> b
foldAEB fHoja fBin t = case t of 
    Hoja n -> fHoja n 
    Bin t1 n t2 -> fBin(rec t1) n (rec t2)
    where rec = foldAEB fHoja fBin
```
Esto funciona de esta manera:
+ (a->b): por cada hoja, recibimos un valor de tipo b
+ (b->a->b->b): por cada bin(nodo), recibimos el resultado de cada llamada recursiva, el valor del nodo y el resultado de la llamada recursiva
+ AB a: la estructura que vamos a recorrer
+ b: el resultado de cada llamada recursiva

# Funciones sobre árboles
Dado el tipo de datos:
```hs
data AB a = Nil | Bin (AB a) a (AB a)
```

¿Que tipo de recursión tiene cada una de las siguientes funciones? (Estructural, Primitiva, Global)
> Recordatorio:
> + Estructural: Remplaza la lista vacía por un valor inicial y el contructor de la lista por una función.
> + Primitiva: Generaliza la recursión estructural, dando al caso recursivo el poder adicional de acceder al resto de la lista además del resultado recursivo del procesamiento de esta.
> + Recursión Global: Utiliza un acumulador que se va actualizando en el caso base y se transfiere de forma recursiva invocando inmediatamente la operación con el nuevo estado del acumulador. Se procesa desde el principio hacia el final.
```hs
-- Primitiva
insertarABB :: Ord a => a -> AB a -> AB a
insertarABB x Nil = Bin Nil x Nil
insertarABB x (Bin i r d) = if x < r
    then Bin (insertarABB x i) r d
    else Bin i r (insertarABB x d)
```
```hs
-- Estructural 
truncar :: AB a -> Int -> AB a
truncar Nil _ = Nil
truncar (Bin i r d) n = if n == 0
    then Nil
    else Bin (truncar i (n-1)) r (truncar d (n-1))

```

Dado el siguiente tipo que representa polinomios:

```hs
data Polinomio a = X 
    | Cte a
    | Suma (Polinomio a) (Polinomio a)
    | Prod (Polinomio a) (Polinomio a)
```

+ Definir la función evaluar :: Num a => a -> Polinomio a -> a
+ Definir el esquema de recursión estructural foldPoli para polinomios 
+ Redefinir eval usando foldPoli.

```hs
evaluar x p = case p of 
    X -> x
    Cte a -> a
    Suma p1 p2 -> evaluar x p1 + evaluar x p2
    Prod p1 p2 -> evaluar x p1 * evaluar x p2
```

```hs
foldPoli :: (a->b) -> (b->b->b) -> (b->b->b) -> Polinomio a -> b
foldPoli fX fCte fSuma fProd p = case p of 
    X -> fX
    Cte a -> fCte a
    Suma p1 p2 -> fSuma (rec p1) (rec p2)
    Prod p1 p2 -> fProd (rec p1) (rec p2)
    where rec = foldPoli fX fCte fSuma fProd
```

```hs
evaluar x p = foldPoli (

)
```

# Estructura compleja
Dado el tipo de datos 
```hs
data RoseTree a = Rose a [RoseTree a]
```
de árboles donde cada nodo tiene una cantidad indeterminada de hijos.
1. Escribir el esquema de recursión estructural para RoseTree.
2. Usando el esquema definido, escribir las siguientes funciones:
    + hojas, que dado un RoseTree, devuelva una lista con sus hojas ordenadas de izquierda a derecha, según su aparición en el RoseTree.
    + ramas, que dado un RoseTree, devuelva los caminos de su raíz a una de sus hojas.
    + tamaño, que devuelve la cantidad de nodos de un RoseTree.
    + altura, que devuelve la altura más larga de un RoseTree. Si el RoseTree es una hoja se cosidera que su algura es 1.

# Funciones como estructuras de datos:
Se cuenta con la siguiente representación de conjuntos:
```hs
type Conj a = (a->Bool)
```
caracterizados por su función de pertenencia. De este modo, si c es un conjunto y e un elemento, la expresión c e devuelve True si e pertenece a c y False en caso contrario.

1. Definir la constante `vacío: Conj a`, y la función `agregar :: Eq a => a -> Conj a -> Conj a`
2. Escribir las funciones intersección, unión y diferencia (todas de tipo `Conj a -> Conj a -> Conj a`)