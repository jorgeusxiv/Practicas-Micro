
;*****************************************************************************
; PRACTICA 1 SISTEMAS BASADOS EN MICROPROCESADORES
;
;  GRUPO 2302 PAREJA 4
;
; Jorge Santisteban Rivas ---> jorge.santisteban@estudiante.uam.es
; Santiago Valderrabano Zamorano ---> santiago.valderrabano@estudiante.uam.es
;
;*****************************************************************************

;**************************************************************************
; SBM 2019. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
;-- rellenar con los datos solicitados

  matriz DB -3, -11, 1
          DB 15, 12, -7
          DB 3, 9, -7

  resultado DW ?

  eleccionOp DB 4 dup (?)
  matrizUsuario DB 37 dup (?)

  imprimirEleccion DB 13, 10, "  ELIJA LA OPERACION QUE DESEA REALIZAR: ", 13, 10,"  - Determinante con valores predeterminados (1) ",13, 10,"  - Determinante con valores por pantalla (2)",13, 10, 13, 10, " INTRODUZCA LA OPCION QUE DESEA ---> $"

  imprimirError1 DB 13, 10, "  ERROR AL METER LOS ARGUMENTOS!", 13, 10, 13, 10, "  $"

  imprimirLectura1 DB  13, 10, 13, 10, "  PARA INTRODUCIR LA MATRIZ DESEADA POR PANTALLA, DEBERA INTRODUCIR:", 13, 10, "   1 -> LOS 9 NUMEROS SEPARADOS POR ESPACIOS", 13, 10, "   2 -> ESPACIO Y ENTER AL FINAL", 13, 10, 13, 10, "  POR EJEMPLO, LA MATRIZ:", 13, 10, "      | 10 - 5   3| ", 13, 10, "      |- 8 -12   5|", 13, 10, "      |  1   6   8| ", 13, 10, 13, 10, "  SE INTRODUCIRIA DE LA SIGUIENTE MANERA:", 13, 10, " --> 10 -5 3 -8 -12 5 1 6 8 $"
  imprimirLectura2 DB  13, 10, "  Y A CONTINUACION PULSARIAMOS ENTER",13,10, 13, 10, "  MUY IMPORTANTE EL ESPACIO DESPUES DEL ULTIMO NUMERO!!!", 13, 10,13, 10, "  TODOS LOS NUMERO DEBEN ESTAR ENTRE -15 Y 15" ,13, 10,13, 10, "  SI ESCRIBE MAS DE 9 NUMEROS SERAN OMITIDOS" ,13, 10,13, 10, " INTRODUZCA LA MATRIZ:", 13, 10,  " --> $"

  vaciarPantalla	DB 	1BH,"[2","J$"
  ;;OJO CON LO DEL ESPACIO Y EL ENTER POSIBLE CAMBIO

  imprimirFinal DB  13, 10, 13, 10, '      |             |', 13, 10, '|A| = |             | =       ', 13, 10, '      |             |',13, 10, "  $"

  det_aux DB (?)

DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES)
EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL

INICIO PROC
  ; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
  MOV AX, DATOS
  MOV DS, AX
  MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
  ; FIN DE LAS INICIALIZACIONES

  ; COMIENZO DEL PROGRAMA
  MOV AH, 9
  MOV DX, OFFSET vaciarPantalla
  INT 21h


NOLIMPIAPANTALLA:

  CALL ELECCION

  MOV AL, 31h
  CMP AL, eleccionOp[2]
  JZ DETMATRIZ

  MOV AL, 32h
  CMP AL, eleccionOp[2]
  JNZ ERROR

  CALL LECTURAMATRIZ

FIN:
  MOV AX, 4C00H
  INT 21H

INICIO ENDP

; FUNCION QUE IMPRIME POR PANTALLA LA ELECCION DE OPERACION Y RECOGE LA ELECCION Y LA DEVUELVE
ELECCION PROC


  MOV AH, 9
  MOV DX, OFFSET imprimirEleccion
  INT 21h

  MOV AH, 0AH
  MOV DX, OFFSET eleccionOp
  MOV eleccionOp[0], 2
  INT 21h

  RET

ELECCION ENDP

;;FUNCION QUE EN CASO DE NO INTRODUCIR UNA OPCION CORRECTA REINICIA EL PROGRAMA

ERROR PROC

  ;;Volvemos a poner los valores por defecto (no se si habrá un método más rápido)
  MOV matriz[0], -3
  MOV matriz[1], -11
  MOV matriz[2], 1
  MOV matriz[3], 15
  MOV matriz[4], 12
  MOV matriz[5], -7
  MOV matriz[6], 3
  MOV matriz[7], 9
  MOV matriz[8], -7


  MOV AH, 9
  MOV DX, OFFSET vaciarPantalla
  INT 21h

  MOV AH, 9
  MOV DX, OFFSET imprimirError1
  INT 21h

  JMP NOLIMPIAPANTALLA

ERROR ENDP

;;EN ESTA FUNCION CALCULAMOS EL DETERMINANTE DE LA MATRIZ

DETMATRIZ PROC


  MOV AX, 0000h

  MOV AL, DS:matriz[0]
  MOV AH, DS:matriz[4]
  MOV BH, DS:matriz[8]

  ;;PARA QUE LA MULTIPLICACION FINAL SEA CORRECTA TENEMOS QUE EXTENDER EL SIGNO DEL TERCER OPERANDO
  ;;YA QUE LA FUNCION SAR UTILIZA EL CL, GUARDAREMOS EN MEMORIA DE MANERA TEMPORAL LO QUE ALLI GUARDEMOS A LO LARGO DEL PROCESO

  MOV det_aux, CL
  MOV CL, 8
  SAR BX, CL
  MOV CL, det_aux
  IMUL AH
  IMUL BX

  MOV CX, AX

  MOV AX, 0000h

  MOV AL, DS:matriz[1]
  MOV AH, DS:matriz[5]
  MOV BH, DS:matriz[6]

  MOV det_aux, CL
  MOV CL, 8
  SAR BX, CL
  MOV CL, det_aux
  IMUL AH
  IMUL BX

  ADD CX, AX

  MOV AX, 0000h

  MOV AL, DS:matriz[2]
  MOV AH, DS:matriz[3]
  MOV BH, DS:matriz[7]

  MOV det_aux, CL
  MOV CL, 8
  SAR BX, CL
  MOV CL, det_aux
  IMUL AH
  IMUL BX

  ADD CX, AX

  MOV AX, 0000h

  MOV AL, DS:matriz[2]
  MOV AH, DS:matriz[4]
  MOV BH, DS:matriz[6]

  MOV det_aux, CL
  MOV CL, 8
  SAR BX, CL
  MOV CL, det_aux
  IMUL AH
  IMUL BX

  SUB CX, AX

  MOV AX, 0000h

  MOV AL, DS:matriz[0]
  MOV AH, DS:matriz[5]
  MOV BH, DS:matriz[7]

  MOV det_aux, CL
  MOV CL, 8
  SAR BX, CL
  MOV CL, det_aux
  IMUL AH
  IMUL BX

  SUB CX, AX

  MOV AX, 0000h

  MOV AL, DS:matriz[1]
  MOV AH, DS:matriz[3]
  MOV BH, DS:matriz[8]

  MOV det_aux, CL
  MOV CL, 8
  SAR BX, CL
  MOV CL, det_aux
  IMUL AH
  IMUL BX

  SUB CX, AX

; METEMOS EL RESULTADO EN LA CADENA A IMPRIMIR

  MOV AX, CX
  MOV SI, 6 ;;EL CONTADOR COMIENZA EN 6
  CMP AX, 0
  JNS HEXTOASCII

  ;;PONEMOS UN - EN LA POSICION 51 PARA INDICAR QUE EL DETERMINANTE ES NEGATIVO Y TRANSFORMAMOS EL DETERMINANTE A UN NUMERO POSITIVO
  NEG AX
  MOV imprimirFinal[51], '-'

;;AQUI TRANSFORMAMOS EL DETERMINANTE EN HEXADECIMAL A CODIGO ASCII (COMENZANDO DESDE EL FINAL)
HEXTOASCII:

  MOV BX, 10
  MOV DX, 0
  DIV BX
  ADD DL, 30h
  MOV imprimirFinal[50+SI], DL
  DEC SI
  CMP AX, 0
  JNZ HEXTOASCII

  ;;MOV DS:resultado, DX

  CALL IMPRIMIRMATRIZ

  JMP FIN

DETMATRIZ ENDP

; FUNCION QUE LEE LA MATRIZ QUE INTRODUCE EL USUARIO
LECTURAMATRIZ PROC


  MOV AH, 9
  MOV DX, OFFSET vaciarPantalla
  INT 21h


  MOV AH, 9
  MOV DX, OFFSET imprimirLectura1
  INT 21h

  MOV AH, 9
  MOV DX, OFFSET imprimirLectura2
  INT 21h

  MOV AH, 0AH
  MOV DX, OFFSET matrizUsuario
  MOV matrizUsuario[0], 37
  INT 21h

  CMP matrizUsuario[1], 18
  JNS NUM_ARG_OK
  CALL ERROR


NUM_ARG_OK:
  MOV BX, 0 ; CONTADOR DE CARACTER LEIDOS
  MOV SI, 0 ; CONTADOR DE LA POSICION DE LA MATRIZ EN LA QUE HAY QUE METER EL NUMERO

LEERNUMERO:
  MOV DI, 1 ; SIGNO DEL NUMERO LEIDO

  CMP matrizUsuario[BX + 2], 20h
  JZ ESPACIO

  CMP matrizUsuario[BX + 2], 2Dh
  JNZ NUMEROPOSITIVO

  ; SI LEEMOS UN MENOS CAMBIAMOS EL SIGNO DE DI

  INC BX
  MOV DI, -1

NUMEROPOSITIVO:

  MOV AL, matrizUsuario[BX + 2]
  SUB AL, 30h

  CMP matrizUsuario[BX + 2 + 1], 20h ; Vemos si el siguiente byte es un espacio
  JZ UNDIGITO

  ; SI TIENE DOS DIGITOS HACEMOS LO SIGUIENTE...

  INC BX

  MOV AH, 0
  MOV DX, 10
  IMUL DX

  MOV DL, matrizUsuario[BX + 2]
  SUB DL, 30h
  ADD AL, DL
  CMP matrizUsuario[BX + 2 + 1], 20h ; Vemos si es un numero de 3 cifras (caso erroneo)
  JZ UNDIGITO
  CALL ERROR


UNDIGITO:

  IMUL DI

  MOV matriz[SI], AL

  INC SI
  CMP SI, 9
  JE VUELTA

ESPACIO:

  INC BX
  CMP BX, WORD PTR matrizUsuario[1]
  JNE LEERNUMERO

VUELTA:

  ;;REVISEMOS QUE TODOS LOS ARGUEMENTOS ESTAN ENTRE EL -15 Y EL 15

  MOV SI, 0 ;;CONTADOR QUE RECORRERA LA MATRIZ

CHECK_MATRIZ:
  MOV AL,matriz[SI]
  CMP AL, 0
  JNS VER_RANGO
  NEG AL ;;CAMBIAMOS EL SIGNO SI ES NEGATIVO

VER_RANGO:
  CMP AL, 16 ;;Comprobamos que sea menor que 15
  JS SIGUIENTE_ELEMENTO
  CALL ERROR ;;Si no lo es, ERROR

SIGUIENTE_ELEMENTO:
  INC SI
  CMP SI, 9
  JNZ CHECK_MATRIZ


  CALL DETMATRIZ

LECTURAMATRIZ ENDP

; FUNCION QUE IMPRIME POR PANTALLA EL DETERMINANTE DE LA MATRIZ Y LA MISMA
IMPRIMIRMATRIZ PROC

  MOV BX, 0 ;; CONTADOR PARA ESCRIBIR EN MATRIZ
  MOV SI, 0 ;; DESPLAZAMIENTO EN MATRIZ

ESCRIBIR_MATRIZ:

  MOV AL, matriz[BX]
  CMP AL, 0
  JNS NUMPOS
  MOV imprimirFinal[12+SI], '-' ;;Si es negativo el primer caracter es un -

  NEG AL

NUMPOS:
  ADD SI, 2 ;;Avanzamos 2 para ir a la posicion final y usamos el mismo algoritmo que imprime el determinante
  MOV CX, 10
  MOV DX, 0
  DIV CX
  ADD DL, 30h
  MOV imprimirFinal[12+SI], DL
  SUB SI, 2 ;;AQUI VOLVEMOS A LA POSICION INICIAL
  CMP AX, 0
  JZ UN_NUM

  ;;SI TENEMOS UN NUMERO DE DOS DIGITOS TENEMOS QUE ESCRIBIR EL SEGUNDO

  INC SI
  MOV CX, 10
  MOV DX, 0
  DIV CX
  ADD DL, 30h
  MOV imprimirFinal[12+SI], DL
  DEC SI

UN_NUM:
  CMP BX, 2
  JNZ SALTO1 ;;NO SALTA EN EL TERCER VALOR DE LA MATRIZ
  ADD SI, 11

SALTO1:
  CMP BX, 5
  JNZ SALTO2 ;;NO SALTA EN EL SEXTO VALOR DE LA MATRIZ
  ADD SI, 20

SALTO2:
  ADD SI, 4
  INC BX
  CMP BX, 9
  JNZ ESCRIBIR_MATRIZ


  MOV AH, 9
  MOV DX, OFFSET imprimirFinal
  INT 21h

  RET


IMPRIMIRMATRIZ ENDP

; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
