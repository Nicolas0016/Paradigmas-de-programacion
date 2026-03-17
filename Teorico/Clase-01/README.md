El objetivo de la materia es el estudio de los fundamentos de los lenguajes de programación, abordando diferentes paradigmas (maneras de formular soluciones a problemas algorítmicos), con un enfoque fuerte en la programación funcional mediante el lenguaje haskell.

Para entender a fondo, no basta con saber escribir código; se deben estudiar cuatro aspectos formales:

+ **Gramática**: Define el alfabeto, los tokens (palabras) y la sintaxis.
+ **Semántica**: Le asigna un significado riguroso a cada frase sintácticamente correcta. Esto es vital para probar teoremas sobre el comportamiento del software, especialmente en sistemas críticos (aeronáutica, reactores nucleares, medicina) donde un fallo cuesta vidas o recursos.
+ **Pragmática**: Estudia cómo usar esas frases en contexto para lograr un código más elegante o eficiente.
+ **Implementación**: Cómo la maquina ejecuta esas frases respetando la semántica (mediante intérpretes, compiladores o inferencia de tipos).


### Fundamentos del Paradigma Funcional
El enfoque funcional modela la programación puramente como el procesamiento de información (una entrada se computa y da una salida). SUS pilares son:
+ **Funciones matemáticas puras**: Aplicar una función no tiene efectos secundarios. A la misma entrada, siempre le corresponde la misma salida.
+ **Inmutabilidad**: Las estructuras de datos no cambian (no hay asignaciones destructivas ni ciclos while que muten variables)

### Expresiones
Las expresiones son secuencias de símbolos que sirven para representar datos, funciones y funciones aplicadas a los datos.

> OBS: Las funciones también son datos

Una expresión puede ser:
```hs
True False [] (:) 0 1 2 ...
```
Una variable:
```hs
longitud ordenar x xs (+) (*) ...
```
3. La aplicación de una expresión a otra:
```hs
ordenar lista
not True
not (not True)
(+) 1
((+) 1) (alCuadrado 5)
```
Convenimos en que la aplicación es asociativa a izquierda:
```hs
f x y ≡ (f x) y !≡ f (x y)
```
Ejemplo:
```hs
sumarUno = (+) 1

sumarUno (sumarUno 5)
= ((+) 1) (sumarUno 5)
≡ 1 + sumarUno 5
= 1 + ((+) 1) 5
≡ 1 + (1 + 5)
= 1 + 6
= 7
```

### Tipos
Un tipo es una especificación del invariante de un dato o de una función.

Ejemplo:
```hs
99 :: Int
not :: Bool -> Bool
not True :: Bool
(+) :: Int -> (Int -> Int)
(+) 1 :: Int -> Int
((+) 1) 2 :: Int
```
El tipo de una función expresa un **contrato**.
Condiciones de tipado

>Para que un programa esté **bien tipado**:
>1. Todas las expresiones deben tener tipo.
>2. Cada variable se debe usar siempre con un mismo tipo.
>3. Los dos lados de una ecuación deben tener el mismo tipo.
>4. El argumento de una función debe tener el tipo del dominio.
>5. El resultado de una función debe tener el tipo del codominio.
<center>

$\huge \frac{f :: a \rightarrow b \quad x :: a}{f~x :: b}$

</center>
Lo que esta por encima de la linea:

+ `f :: a -> b`: Significa que tengo función llamada `f`. Esta recibe como argumento un dato de tipo `a` y devuelve como resultado un dato de tipo `b`.
+ `x :: a`: Significa que tengo un valor o expresión llamado `x` que es exactamente del tipo `a`.

Lo que está abajo de la línea:
+ `f x :: b`: Significa que si aplicas la función `f` al valor `x`, el resultado de toda esa expresión será inevitablemente del tipo `b`

> No es necesario escribir explícitamente los tipos. (Inferencia)

Convenimos en que “->” es asociativo a derecha:

```hs
a -> b -> c ≡ a -> (b -> c) !≡ (a -> b) -> c
a -> b -> c -> d ≡ a -> (b -> (c -> d))
```
Ejemplo:
```hs
suma4 :: Int -> Int -> Int -> Int -> Int
suma4 a b c d = a + b + c + d
```
Se puede pensar así:
```hs
suma4 :: Int -> (Int -> (Int -> (Int -> Int)))
(((suma4 a) b) c) d = a + b + c + d
```

### Polimorfismo
Hay expresiones que tienen más de un tipo. Usamos variables de tipo a, b, c para denotar tipos desconocidos:

```hs
id :: a -> a
[] :: [a]
(:) :: a -> [a] -> [a]
fst :: (a, b) -> a
snd :: (a, b) -> b
```
Ejemplo
```hs
flip f x y = f y x
```
¿Qué tipo tiene flip?
```hs
flip (:) [2, 3] 1
= (:) 1 [2, 3]
≡ 1 : [2, 3]
= [1, 2, 3]
```
Respuesta
```hs
flip :: (a -> b -> c) -> b -> a -> c
```