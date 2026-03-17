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