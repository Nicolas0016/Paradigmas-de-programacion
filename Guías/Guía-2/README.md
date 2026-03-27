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
