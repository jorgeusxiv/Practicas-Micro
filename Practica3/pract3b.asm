;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																																				;
; 					PRACTICA 3 SISTEMAS BASADOS EN MICROPROCESADORES						;
;																																				;
;  								 Pareja	4		Grupo 2302		Apartado b)									;
;																																				;
; Autores:																															;
;																																				;
; - Jorge Santisteban Rivas --> jorge.santisteban@estudiante.uam.es  		;
;	- Santiago Valderrabano --> santiago.valderrabano @estudiante.uam.es 	;
;																																				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DGROUP GROUP _DATA, _BSS				;; Se agrupan segmentos de datos en uno

_DATA SEGMENT WORD PUBLIC 'DATA' 		;; Segmento de datos DATA p�blico

_DATA ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'			;; Segmento de datos BSS p�blico

_BSS ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' 		;; Definici�n del segmento de c�digo
ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP

PUBLIC _createBarCode


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FUNCION: _createBarCode
; AUTORES: Jorge Santisteban y Santiago Valderrabano
;
; Esta función recibe por pila cada uno de los codigos que componen un codigo
; de barras. Los iremos leyendo uno a uno y convirtiendolos a ASCII para a
; continuacion formar el codigo de barras entero.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_createBarCode PROC FAR

  PUSH BP
  MOV BP, SP
  PUSH AX BX CX DX DI DS ES ; HACEMOS PUSH DE TODOS LOS REGISTROS QUE VAMOS A USAR

  LDS DI, [BP + 16] 	; AQUI ES DONDE VAMOS A PASAR LO QUE TENEMOS QUE DEVOLVER


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LA MECANICA PARA OBTENER EL CODIGO PEDIDO SERÁ LA SIGUIENTE:
;
; 1: Leemos de pila el codigo especifico (pais, empresa, producto, ...). Para
;    leer el codigo accedemos directamente a la posicion de pila ya que se
;    nos pasan como una variable y no como un puntero.
; 2: Despues, iremos dividiendo el numero por 10, sumaremos 30h al resto para
;    convertirlo a ASCII y lo meteremos en la posicion correspondiente del
;    codigo de barras que vamos a devolver que esta apuntado por DS:DI
;
; Nota: En algunos casos, dividimos por CL y en otros por CX. Esto se debe a
;       hay codigos que tiene un mayor tamaño y por tanto hay que hacer division
;       por un numero de 16 bits y por tanto el resto nos queda en DX no en AH.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; CODIGO DEL PAIS

  MOV AX, 0
  MOV DX, 0
  MOV AX, [BP + 6]

  MOV CX, 10
  DIV CX

  ADD DL, 30h

  MOV DS:[DI + 2], DL

  DIV CL

  ADD AH, 30h
  ADD AL, 30h

  MOV DS:[DI + 1], AH

  MOV DS:[DI], AL


; CODIGO DE EMPRESA

  MOV AX, 0
  MOV DX, 0
  MOV AX, [BP + 8]

  MOV CX, 10
  DIV CX

  ADD DX, 30h

  MOV DS:[DI + 6], DL

  MOV DX, 0
  DIV CX

  ADD DL, 30h

  MOV DS:[DI + 5], DL

  DIV CL

  ADD AH, 30h
  ADD AL, 30h

  MOV DS:[DI + 4], AH

  MOV DS:[DI + 3], AL

; CODIGO DE PRODUCTO

  MOV AX, 0
  MOV DX, 0
  MOV DX, [BP + 12]
  MOV AX, [BP + 10]

  MOV CX, 10

  DIV CX

  ADD DX, 30h

  MOV DS:[DI + 11], DL

  MOV DX, 0
  DIV CX

  ADD DL, 30h

  MOV DS:[DI + 10], DL

  MOV DX, 0
  DIV CX

  ADD DL, 30h

  MOV DS:[DI + 9], DL

  DIV CL

  ADD AH, 30h
  ADD AL, 30h

  MOV DS:[DI + 8], AH

  MOV DS:[DI + 7], AL

; CODIGO DE CONTROL

  MOV AX, 0
  MOV AX, [BP + 14]

  ADD AL, 30h

  MOV DS:[DI + 12], AL
  MOV DS:[DI + 13], WORD PTR 0


	POP ES DS DI DX CX BX AX BP

	RET

_createBarCode ENDP

_TEXT ENDS
END
