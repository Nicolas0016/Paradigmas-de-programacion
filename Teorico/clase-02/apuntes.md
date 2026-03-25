# Resumen de la Clase 2: Programación Funcional Avanzada en Haskell

El texto aborda conceptos fundamentales del paradigma funcional, profundizando en funciones de orden superior, esquemas de recursión (principalmente sobre listas) y el diseño de datos propios.

### 1. Funciones de Orden Superior y Abstracciones
*   **`map` y `filter`:** Las herramientas principales para procesar y transformar listas. Al componerlas (ej. pasándole un filtro seguido de un mapeo), evitamos código duplicado.
*   **Funciones Anónimas (Expresiones Lambda):** Sintaxis `\x -> e` que permite definir funciones "al vuelo" (sin nombre), extremadamente útiles como parámetros de funciones de orden superior.
*   **`curry` y `uncurry`:** Explica dos formas de pasar parámetros a las funciones. *Curry* es el estándar en Haskell (pasar los argumentos de a uno), mientras que *uncurry* consiste en pasar los argumentos empaquetados juntos en una tupla. 

### 2. Esquemas de Recursión sobre Listas
El documento clasifica el procesamiento iterativo de listas en 3 patrones recursivos definidos, con un mecanismo general para cada uno:

*   **Recursión Estructural $\implies$ `foldr` (Plegado a derecha)**
    *   **Funcionamiento:** Reemplaza la lista vacía (`[]`) por un valor inicial y el constructor de la lista (`:`) por una función. Procesa agrupando de derecha a izquierda.
    *   **Observación:** En el caso recursivo solo requiere el elemento actual y el resultado del llamado recursivo del resto de los elementos (nunca ve el "resto de la lista" original en sí mismo).
*   **Recursión Primitiva $\implies$ `recr`**
    *   **Funcionamiento:** Generaliza la recursión estructural, dándole al caso recursivo el "poder" adicional de acceder al **resto de la lista (`xs`)** además del resultado recursivo del procesamiento de esta.
    *   **Observación:** Toda recursión estructural es también recursión primitiva, pero no al revés. Es útil en algoritmos que, dependiendo de una condición, decidan cancelar o frenar el avance procesando lo que queda sin alterar.
*   **Recursión Iterativa $\implies$ `foldl` (Plegado a izquierda)**
    *   **Funcionamiento:** Utiliza un **acumulador**. Este acumulador se va actualizando en el caso base y se transfiere de forma recursiva invocando inmediatamente la operación con el nuevo estado del acumulador. Se procesa desde el principio hacia el final.
    *   **Observación:** Diferencia matemática clave: `foldl` y `foldr` procesan los árboles de llamadas en sentidos opuestos. Solo son equivalentes si la operación que se les pasa es **asociativa**.

### 3. Tipos de Datos Algebraicos (ADTs)
Haskell permite modelar el dominio de los problemas creando nuevos tipos de datos a través de la instrucción `data`.
*   **Tipos enumerados:** Múltiples constructores sin parámetros (Ej: `Día = Lun | Mar...`).
*   **Tipos producto (Estructuras):** Un constructor con múltiples campos (Ej: `Persona String String Int`).
*   **Sumas de productos:** Permiten construir funciones donde un tipo puede tener múltiples formas (Ej: `Figura = Rectangulo Float Float | Circulo Float`).
*   **Tipos recursivos:** Permiten definir estructuras infinitas al usar a los mismos tipos para su definición (Ej: Los Números Naturales, y de hecho, las listas estándar de Haskell se definen así `data [a] = [] | a : [a]`).

### 4. Recursión sobre Otras Estructuras (Árboles)
*   **Observación clave final:** Todo lo visto de recursión estructural para listas puede generalizarse para cualquier ADT de manera análoga. 
*   Así como las listas tienen su estructura que se abstrae con `foldr`, el documento muestra cómo un **Árbol Binario (`AB`)** puede definir una función análoga `foldAB`, construida para recorrer todos sus nodos, permitiendo derivar el cálculo de su longitud, mapeos, máximos y altura de forma simple.
