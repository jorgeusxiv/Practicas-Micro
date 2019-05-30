
;*****************************************************************************
; PRACTICA 1 APARTADO C SISTEMAS BASADOS EN MICROPROCESADORES
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

MOV AX, 0h
MOV DS, AX
MOV BX, 0210h
MOV DI, 1011h

; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA

;; INSTRUCCION 1

MOV AX, 0DAD0h
MOV DS:[6584h] , AX 	;; Metemos en la posicion de memoria que creemos que va a usar la instruccion un valor conocido para comprobar despues.


;; INSTRUCCION 2

MOV AX, 0B1C1h
MOV DS:[5560h], AX	 	;; Metemos en la posicion de memoria que creemos que va a usar la instruccion un valor conocido para comprobar despues.


MOV AX, 0535h
MOV DS, AX


MOV AL, DS:[1234h]  ;; 6584h = 5350h + 1234h es la direccion de memoria a la que accede y vemos que escribe D0 en AL

MOV AX, [BX]        ;; 5560h = 5350h + 0210h  es la direccion de memoria a la que accede y vemos que escribe B1C1 en AX


;; INSTRUCCION 3

MOV AL, 0BBh


MOV [DI], AL 		;; Observamos que en DS:1011 se escribe el valor BB que es el que hemos asignado a AL




; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
