
;*****************************************************************************
; PRACTICA 1 APARTADO B SISTEMAS BASADOS EN MICROPROCESADORES
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

	CONTADOR DB ?                                       ;; Un byte y como no lo inicializamos ponemos ?
	TOME DW 0CAFEh                                       ;; Como queremos 2 bytes ponemos DW y lo inicializamos a CAFEh
	TABLA100 DB 100 dup (?)                             ;; Como queremos 100 bytes ponemos 100 dup y como no lo inicializamos ponemos ?
	ERROR1 DB "Atención: Entrada de datos incorrecta."  ;;Cada caracter ASCII ocupa 1 byte.


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
MOV AX, DATOS
MOV DS, AX
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA

;; Accion 1:

MOV AL, ERROR1[2]     ;; Como solo movemos un caracter podemos usar AL de buffer en vez de todo AX
MOV TABLA100[63h], AL

;; Accion 2:

MOV AX, TOME
MOV TABLA100[23h], AL
MOV TABLA100[24h], AH

;; Accion 3:

MOV CONTADOR, AH  ;; Como ya tenemos TOME copiado en AX podemos coger AH que es el byte mas significativo de AX


; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
