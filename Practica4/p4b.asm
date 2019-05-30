;*****************************************************************************
; PRACTICA 4 APARTADO B SISTEMAS BASADOS EN MICROPROCESADORES
;
;  GRUPO 2302 PAREJA 4
;
; Jorge Santisteban Rivas ---> jorge.santisteban@estudiante.uam.es
; Santiago Valderrabano Zamorano ---> santiago.valderrabano@estudiante.uam.es
;
;*****************************************************************************

DATOS SEGMENT

  ; Declaramos todas las lineas de texto que vamos a utilzar, incluyendo nuestra matriz de Polibio

  vaciarPantalla	DB 	1BH,"[2","J$"

  saltoDeLinea DB 13, 10, "$"

  separador DB "--------------------------------------------------------------", 13, 10, "$"

  textoCodificar	DB "PACOPAQUERAS$"

  textoDecodificar	DB "162616464514$"

  codificando	DB "  CODIFICANDO...", 13, 10, "$"
  decodificando	DB "  DECODIFICANDO...", 13, 10, "$"
  aCodificar	DB "El texto a codificar es --> $"
  aDecodificar	DB "El texto a decodificar es --> $"
  codificado	DB "El texto codificado es --> $"
  decodificado	DB "El texto decodificado es --> $"

  matrizPolibioTexto DB 1BH, "[3;1f Matriz de Polibio:", 13, 10, "$"
  matrizPolibioCabecera DB 1BH, "[5;1f  F/C   1   2   3   4   5   6  $"
  matrizPolibioCabecera2 DB 1BH, "[6;1f  ---   -   -   -   -   -   -  $"
  matrizPolibioFila1 DB 1BH, "[7;1f   1  | 7 | 8 | 9 | A | B | C |$"
  matrizPolibioFila2 DB 1BH, "[8;1f   2  | D | E | F | G | H | I |$"
  matrizPolibioFila3 DB 1BH, "[9;1f   3  | J | K | L | M | N | O |$"
  matrizPolibioFila4 DB 1BH, "[10;1f   4  | P | Q | R | S | T | U |$"
  matrizPolibioFila5 DB 1BH, "[11;1f   5  | V | W | X | Y | Z | 0 |$"
  matrizPolibioFila6 DB 1BH, "[12;1f   6  | 1 | 2 | 3 | 4 | 5 | 6 |", 13, 10, "$"


DATOS ENDS

PILA SEGMENT STACK "STACK"
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS


CODE SEGMENT
ASSUME CS: CODE, DS: DATOS,  SS: PILA

test_imprimir PROC

  MOV AX, DATOS
  MOV DS, AX
  MOV AX, PILA
  MOV SS, AX
  MOV SP, 64

 ; Imprimimos la matriz de polibio
  MOV AH, 9
  MOV DX, OFFSET vaciarPantalla
  INT 21h

  MOV DX, OFFSET matrizPolibioTexto
  INT 21h
  MOV DX, OFFSET separador
  INT 21h
  MOV DX, OFFSET matrizPolibioCabecera
  INT 21h
  MOV DX, OFFSET matrizPolibioCabecera2
  INT 21h
  MOV DX, OFFSET matrizPolibioFila1
  INT 21h
  MOV DX, OFFSET matrizPolibioFila2
  INT 21h
  MOV DX, OFFSET matrizPolibioFila3
  INT 21h
  MOV DX, OFFSET matrizPolibioFila4
  INT 21h
  MOV DX, OFFSET matrizPolibioFila5
  INT 21h
  MOV DX, OFFSET matrizPolibioFila6
  INT 21h
  MOV DX, OFFSET separador
  INT 21h

  ;Imprimimos la cadena a codificar

  MOV DX, OFFSET codificando
  INT 21h
  MOV DX, OFFSET separador
  INT 21h

  MOV DX, OFFSET aCodificar
  INT 21h

  MOV DX, OFFSET textoCodificar
  INT 21h

  MOV DX, OFFSET saltoDeLinea
  INT 21h

  MOV DX, OFFSET codificado
  INT 21h

  ; Metemos offset en dx y segmento en bx para pasarselo como parametros
  PUSH DS

  MOV DX, OFFSET textoCodificar
  MOV BX, SEG textoCodificar
  MOV DS, BX
  MOV AH, 10h ;Metenmos en AX la instruccion 10h
  INT 1Ch
  INT 57h

  ;Imprimimos la cadena a decodificar

  MOV AH, 9
  MOV DX, OFFSET saltoDeLinea
  INT 21h

  MOV DX, OFFSET separador
  INT 21h
  MOV DX, OFFSET decodificando
  INT 21h
  MOV DX, OFFSET separador
  INT 21h

  MOV DX, OFFSET aDecodificar
  INT 21h

  MOV DX, OFFSET textoDecodificar
  INT 21h

  MOV DX, OFFSET saltoDeLinea
  INT 21h

  MOV DX, OFFSET decodificado
  INT 21h

  ; Metemos offset en dx y segmento en bx para pasarselo como parametros
  MOV DX, OFFSET textoDecodificar
  MOV BX, SEG textoDecodificar
  MOV DS, BX
  MOV AH, 11h    ; Metemos en ax la instruccion 11h
  INT 57h

  POP DS

  MOV AH, 9
  MOV DX, OFFSET saltoDeLinea
  INT 21h
  MOV DX, OFFSET separador
  INT 21h

  MOV AX, 4C00h
  INT 21h

test_imprimir ENDP
; Fin del segmento de codigo
CODE ENDS
; Fin del programa indicando donde comienza la ejecucion
END test_imprimir
