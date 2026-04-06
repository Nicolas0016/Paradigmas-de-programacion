# Razonamiento ecuacional, Introducción estructural.

El objetivo es demostrar que ciertas expresiones son equivalentes

¿Para qué?
Para justificar que un algoritmo es correcto

Por ejemplo, si logramos demostrar que: 

```hs
∀ xs::[Int]. quickSort xs = insertionSort xs
```

Esto nos da confianza relativa de un algoritmo con respecto a otro. 

### Para posibilitar optimizaciones
¿Siempre es correcto que las siguientes optimizaciones?

```hs
f x + f x -> 2 * f x
map f (map g xs) -> map (f . g) xs
```

> En lenguaje funcional `sí`. Pero en lenguaje imperativo `no`, ya que pueden tener efectos.

Para razonar sobre equivalencias de expresiones vamos a asumir:
1. Que trabajamos sobre estructuras de datos `finitas`.
2. Que trabajamos con `funciones totales`.
    + Las ecuaciones deben cubrir todos los casos.
    + La recursión siempre debe terminar.
3. Que el programa `no depende de un orden` de las ecuaciones.

```hs
vacia [] = True -> vacia [] = True
vacia _ = False -> vacia (_:_) = False
```

### Igualdades por definición
## Principio de reemplazo
Sea $e_1 = e_2$ una ecuación incluida en el programa.

Las siguientes operaciones preservan la igualdad de expresiones:
1. Reemplazar `cualquier instancia` de $e_1$ por $e_2$.
2. Reemplazar `cualquier instancia` de $e_2$ por $e_1$.
Si una igualdad se puede demostrar con el principio del reemplazo, decimos que la igualdad vale `por definición`.

### Ejemplo: Principio de remplazo
```hs
length [] = 0
length (_:xs) = 1 + length xs

suma [] = 0
suma (x:xs) = x + suma xs 
```

Veamos que `length ["a", "b"] = suma[1,1]`:
```hs
length ["a", "b"]
= 1 + length ["b"]
= 1 + (1 + length [])
= 1 + (1 + 0)
= 1 + (1 + suma [])
= 1 + suma[1]
= suma[1,1]
```

## Inducción estructural
El principio de remplazo no alcanza para probar todas las equivalencias que nos interesan.

>Ejemplo
```hs
not True = False
not False = True
```
¿Podemos probar que `∀x::Bool. not (not x) = x`?

El problema es que la expresión `not (not x)` está trabada: no se puede aplicar ninguna ecuación.

## Principio de inducción sobre booleanos

Si $P(True)$ y $P(False)$ entonces `∀x:: Bool. P(x)`.

Ejemplo
```hs
not True = False
not False = True
```

Para probar `∀x :: Bool. not (not x) = x` basta probar:

1. `not (not True) = True`
    + `not False = True`
    + `True = True`
2. `not (not False) = False`
    + `not True = False`
    + `False = False`

## Principio de inducción sobre naturales
Si $P(Zero)$ y `∀n::Nat. P(n) => P(Suc n)`, entonces $∀n:: Nat. P(n)$

Ejemplo
```hs
suma Zero m = m
suma (Suc n) m = Suc (suma n) m 
```

Para probar `∀n:: Nat. suma n Zero = n` basta probar:

1. `suma Zero Zero = Zero`
2. suma n Zero = n => suma (Suc n) Zero = Suc n

suma(Suc n) Zero = Suc (suma n Zero) = Suc n

## Principio de inducción sobre pares
Si $\forall x :: a. \forall y::b. \ P((x,y))$ entonces $\forall p :: (a,b). P(p)$

Ejemplo:
```hs
fst (x,_) = x
snd (_,y) = y
swap (x,y) = (y,x)
```

Para probar `∀p :: (a, b). fst p = snd (swap p)` basta probar:

> $∀x :: a. ∀y :: b. fst (x, y) = snd (swap (x, y))$

$fst(x, y ) = x = snd (y,x) = snd (swap (x,y))$

¿Qué habría que hacer para probar una propiedad sobre las listas?
¿Se podrá generalizar?


## Intruducción estructural
En el caso general, tenemos un tipo de datos inductivo:

```hs
data T = 
    CBase1 <Parámetros>
    ...
    | Cbasen <Parámetros>
    | CRecursivo <Parámetros>
    ...
    | CRecursivom <Parámetros>
```

Sea $P$ una propiedad acerca de las expresiones tipo $T$ tal que:
+ $P$ vale sobre todos los constructore base de $T$
+ $P$ vale sobre todos los constructores recursivos de $T$, suponiendo como hipótesis inductiva vale para los parámetros de tipo $T$

entonces $\forall x :: T. P(x)$.

### Ejemplo: Principio de inducción sobre listas

```hs
data [a] = [] | a : [a]
```
Sea $P$ una propiedad sobre expresiones de tipo $[a]$ tal que:
+ P([])
+ $\forall x :: a. \forall xs::[a]. (P(xs) => P(x:xs))$

Entonces $\forall xs :: [a]. P(xs)$
### Ejemplo: Principio de inducción sobre árboles binarios
```hs
data AB a = Nil | Bin (AB a) a (AB a)
```
Sea $P$ una propiedad sobre expresiones de tipo $AB$ a tal que:

+ $P(\text{Nil})$
+ $\forall i :: AB a. \ \ \forall r::a. \ \ \forall d :: AB \ a.$
    
    `((P(i) ∧ P(d)) => P(Bin i r d))`

Entonces $\forall x :: AB \ a. \ \ P(x)$

### Ejemplo: Principio de inducción sobre polinomios

```hs
data Poli = X
    | Cte a
    | Suma (Poli a) (Poli a)
    | Prod (Poli a) (Poli a)
```

Sea $P$ una propiedad sobre expresiones de tipo Poli que:

+ $P(x)$
+ $\forall k :: a. \ \ P(Cte \ k)$
+ $\forall p :: Poli \ a. \ \ \forall q :: Poli \ a.$
    + $P(p) \land P(q) \to P(Suma p q)$
+ $\forall p :: Poli \ a. \ \ \forall q :: Poli \ a.$
    + $((P(p) \land P(q)) \to P(Prod p q))$

entonces $\forall x :: Poli \ a. \ \ P(x)$


## Inducción sobre listas

```hs
map f [] = []
map f (x:xs) = f x : map f xs

[] ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)
```

Propiedad `∀f :: a -> b. ∀xs :: [a]. ∀ys :: [a]`

```hs
map f (xs ++ ys) = map f xs ++ map f ys
```

1. Caso base P([])
2. Caso inducivo, `∀x :: a. ∀xs :: [a]. (P(xs) ⇒ P(x : xs))`.

Caso Base:
```hs
map f ([] ++ xs)
= map f ys
= [] ++ map f ys
= map f [] ++ map f ys
```

Caso Inductivo:

$H.I \equiv \forall f :: a\to b$

$\forall ys ::[a].\ map f \ (xs ++ ys) = map\ f \ xs ++ map \ f\  xs$

```hs
map f ((x:xs) ++ ys)
= map f (x : (xs++ys))
= f x : map f (xs++ys)
= f x : (map f xs ++ map f ys)
= (f x : map f xs) ++ map f ys
= map f (x:xs) ++ map f ys
```

## Extensionalidad 
Si $\forall x :: a$ `f x = g x` entonces `f = g`

## Isomorfismo de tipos 
Decimos que dos tipos de datos A y B son isomorfos si:

1. Hay una función `f :: A -> B total`.
2. Hay una función `g :: B -> B total`.
3. Se puede demostrar que `g . f = id :: A -> A`
4. Se puede demostrar que `f . g = id :: B -> B`

Escribimos $A \approx B$ para indicar que son isomorfos.
