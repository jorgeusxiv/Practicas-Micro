;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																																				;
; 					PRACTICA 3 SISTEMAS BASADOS EN MICROPROCESADORES						;
;																																				;
;  								 Pareja	4		Grupo 2302		Apartado a)									;
;																																				;
; Autores:																															;
;																																				;
; - Jorge Santisteban Rivas --> jorge.santisteban@estudiante.uam.es  		;
;	- Santiago Valderrabano --> santiago.valderrabano @estudiante.uam.es 	;
;																																				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DGROUP GROUP _DATA, _BSS						;; Se agrupan segmentos de datos en uno

_DATA SEGMENT WORD PUBLIC 'DATA' 		;; Segmento de datos DATA publico

_DATA ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'			;; Segmento de datos BSS publico

_BSS ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' 		;; Definicion del segmento de codigo
ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP

PUBLIC _computeControlDigit, _decodeBarCode


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FUNCION: _computeControlDigit
; AUTORES: Jorge Santisteban y Santiago Valderrabano
;
; Esta función recibe por pila un código de barras y calcula su digito de
; control segun se desribe en el enunciado y este queda almacenado en AX.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_computeControlDigit PROC FAR

	PUSH BP
	MOV BP, SP
	PUSH BX DI CX DX SI

	LES BX, [BP + 6] 		; LEEMOS LO QUE NOS PASAN COMO PARAMETRO

	MOV CX, 0 					; INICIALIZAMOS CX QUE VA A SER NUESTRA VARIABLE DONDE ALMACENEMOS LA SUMA A 0

	MOV DI, 0						; INICIALIZAMOS DI QUE VA A SER NUESTRO CONTADOR A 0

	MOV DX, 3

BUCLE:
	MOV AX, 0						; INICIALIZAMOS AX QUE VA A SER NUESTRA VARIABLE PARA MULTIPLICAR POR 3 LOS ELEMENTOS PARES A 0

	MOV CL, ES:BX[DI] 	; SACAMOS EL ELEMENTO IMPAR Y SE LO SUMAMOS A CX

	SUB CL, 30h

	ADD SI, CX

	MOV AH, 0
	MOV AL, ES:BX[DI+1]	; SACAMOS EL ELEMENTO PAR Y LO METEMOS EN AX

	SUB AL, 30h
	MUL DX							; MULTIPLICAMOPS POR 3 EL ELEMENTO IMPAR
	ADD SI, AX					; SUMAMOS EL ELEMENTO MULTIPLICADO POR 3 A DX

	MOV AX, 10
	SUB AX, DI					; VEMOS SI EL CONTADOR A LLEGADO AL FINAL DEL BUCLE
	JZ PASOC						; SI HA LLEGADO SALTA AL PASO C DEL APARTADO

	ADD DI, 2						; EN OTRO CASO SUMA 2 AL CONTADOR Y VOLVEMOS AL PRINCIPIO DEL BUCLE
	JMP BUCLE


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Para realizar el apartado c, que es obtener el numero de la decena superior
; más cercana al numero que hemos calculado en el bucle, dividimos este numero
; entre 10 y le restamos el resto de esta división.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PASOC:

	MOV AX, 0
	MOV AX, SI

	MOV DI, 10

	DIV DI

	MOV CX, 10

	SUB CX, DX

	MOV AX, 10
	SUB AX, CX

	JZ FIN

	MOV AX, CX

FIN:

	POP SI DX CX DI BX BP 					;recuperar registros usados

	RET

_computeControlDigit ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FUNCION: _decodeBarCode
; AUTORES: Jorge Santisteban y Santiago Valderrabano
;
; Esta función recibe por pila un código de barras y lo descompone en cada uno
; de los codigos que lo componen, devolviendolos uno a uno tambien por pila.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_decodeBarCode PROC FAR

	PUSH BP
	MOV BP, SP
	PUSH AX BX DI CX DX DS ES ; HACEMOS PUSH DE TODOS LOS REGISTROS QUE VAMOS A USAR

	LES BX, [BP + 6]  ; Apuntadomos ES:BX al codigo de barras que nos pasan por pila


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LA MECANICA PARA OBTENER CADA UNO DE LOS CODIGOS SERÁ LA SIGUIENTE:
;
; 1: APUNTAMOS DS Y DI A LA ZONA DE LA PILA DONDE ESTA LA VARIABLE QUE VAMOS
;    A CALCULAR CON LA INSTRUCCION: LDS DI, [BP + 10+ 4*N] N= 10, 14, 18, 22
;	2: METEMOS EN AL EL NUMERO QUE TOCA LEER
; 3: LO MULTIPLICAMOS POR LA POTENCIA DE 10 CORRESPONDIENTE DEPENDIENDO DE SI
;    ES DECENAS, CENTENAS, UNIDADES DE MILLAR...
; 4: SE LO SUMAMOS A CX QUE ES DONDE ALMACENAMOS LA CUENTA TOTAL
; 5: CUANDO ACABAMOS CON EL NUMERO CORRESPONDIENTE LO METEMOS EN DS:[DI] QUE
;    ES LO QUE APUNTA A LA VARIABLE QUE ESTAMOS CALCULANDO.
;
; CUANDO CALCULAMOS LA CIFRA DE LAS UNIDADES, QUE ES LA PRIMERA QUE CALCULAMOS,
; EN VEZ DE SUMARLE A CX AX, METEMOS EN CX EL VALOR DE AX PARA ASI INICIALIZARLO
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; CODIGO DEL PAIS

	LDS DI, [BP + 10] 	; AQUI ES DONDE VAMOS A PASAR LO QUE TIENE QUE DEVOLVER

	; CIFRA DE LAS UNIDADES


	MOV AH, 0
	MOV AL, ES:BX[2]

	SUB AL, 30h

	MOV CX, AX

	; CIFRA DE LAS DECENAS

	MOV AH, 0
	MOV AL, ES:BX[1]

	SUB AL, 30h

	MOV DX, 10

	MUL DX

	ADD CX, AX

	; CIFRA DE LAS CENTENAS

	MOV AH, 0
	MOV AL, ES:BX[0]

	SUB AL, 30h

	MOV DX, 100

	MUL DX

	ADD CX, AX

	MOV DS:[DI], CX


; CODIGO DE EMPRESA

	LDS DI, [BP + 14]

	; CIFRA DE LAS UNIDADES

	MOV AH, 0
	MOV AL, ES:BX[6]

	SUB AL, 30h

	MOV CX, AX

	; CIFRA DE LAS DECENAS

	MOV AH, 0
	MOV AL, ES:BX[5]

	SUB AL, 30h

	MOV DX, 10

	MUL DX

	ADD CX, AX

	; CIFRA DE LAS CENTENAS

	MOV AH, 0
	MOV AL, ES:BX[4]

	SUB AL, 30h

	MOV DX, 100

	MUL DX

	ADD CX, AX

	; CIFRA DE LOS MILLARES

	MOV AH, 0
	MOV AL, ES:BX[3]

	SUB AL, 30h

	MOV DX, 1000

	MUL DX

	ADD CX, AX

	MOV DS:[DI], CX


; CODIGO DE PRODUCTO

	LDS DI, [BP + 18]

	; CIFRA DE LAS UNIDADES

	MOV AH, 0
	MOV AL, ES:BX[11]

	SUB AL, 30h

	MOV CX, AX

	; CIFRA DE LAS DECENAS

	MOV AH, 0
	MOV AL, ES:BX[10]

	SUB AL, 30h

	MOV DX, 10

	MUL DX

	ADD CX, AX

	; CIFRA DE LAS CENTENAS

	MOV AH, 0
	MOV AL, ES:BX[9]

	SUB AL, 30h

	MOV DX, 100

	MUL DX

	ADD CX, AX

	; CIFRA DE LOS MILLARES

	MOV AH, 0
	MOV AL, ES:BX[8]

	SUB AL, 30h

	MOV DX, 1000

	MUL DX

	ADD CX, AX

	; CIFRA DE DECENAS DE MILLAR

	MOV AH, 0
	MOV AL, ES:BX[7]

	SUB AL, 30h

	MOV DX, 10000

	MUL DX

	ADD AX, CX

	ADC DX, 0

	MOV DS:[DI], AX

	MOV DS:[DI + 2], DX

;DIGITO DE CONTROL

	LDS DI, [BP + 22]

	; CIFRA DE LAS UNIDADES

	MOV AH, 0
	MOV AX, ES:BX[12]

	SUB AX, 30h

	MOV DS:[DI], AL

	POP ES DS DX CX DI BX AX BP

	RET

_decodeBarCode ENDP

_TEXT ENDS
END
