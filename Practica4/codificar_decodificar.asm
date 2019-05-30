
;*****************************************************************************
; PRACTICA 4 APARTADO A SISTEMAS BASADOS EN MICROPROCESADORES
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
  palabra DB "PACOPAQUERAS$"
  matrizEncriptar DB 5,6, 6,1, 6,2, 6,3, 6,4, 6,5, 6,6, 1,1, 1,2, 1,3 	; 0,1,2,3,4,5,6,7,8,9
				          DB 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0				          ; Caracteres especiales
				          DB 1,4, 1,5, 1,6, 2,1, 2,2, 2,3, 2,4, 2,5, 2,6		    ; A,B,C,D,E,F,G,H,I
				          DB 3,1, 3,2, 3,3, 3,4, 3,5, 3,6						            ; J,K,L,M,N,O
				          DB 4,1, 4,2, 4,3, 4,4, 4,5, 4,6					            	; P,Q,R,S,T,U
				          DB 5,1, 5,2, 5,3, 5,4, 5,5					   		            ; V,W,X,Y,Z

  matrizPolibio DB 7, 8, 9, 'A', 'B', 'C'
                DB 'D','E', 'F', 'G', 'H', 'I'
                DB 'J', 'K', 'L', 'M', 'N', 'O'
                DB 'P', 'Q', 'R', 'S', 'T', 'U'
                DB 'V', 'W', 'X', 'Y', 'Z', 0
                DB 1, 2, 3, 4, 5, 6

	resultado DW 128 dup (?)


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ENCRIPTAR
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ENCRIPTAR:

  MOV BX, 0
  MOV DI, 0


NUEVOCARACTERE:

  MOV AX, 0

  MOV AL, DS:BX

  CMP AL, "$"

  JZ FIN

  ;Control de error para caracteres no codificables


  SUB AL, 30h
  MOV AH, 0
  MOV CX, 2
  MUL CX
  MOV SI, AX
  MOV AX, WORD PTR DS:matrizEncriptar[SI]
  MOV DS:resultado[DI], AX

  INC BX
  ADD DI, 2

  JMP NUEVOCARACTERE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; DESENCRIPTAR
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DESENCRIPTAR:

  MOV DX, 0
  MOV BX, 0

NUEVOCARACTERD:

  MOV AX, DS:BX

  CMP CX, "$"

  JZ FIN


FIN:

  MOV DS:resultado[BX], "$"

  MOV AX, 4C00H
  INT 21H

INICIO ENDP


; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
