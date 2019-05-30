;*****************************************************************************
; PRACTICA 4 APARTADO A SISTEMAS BASADOS EN MICROPROCESADORES
;
;  GRUPO 2302 PAREJA 4
;
; Jorge Santisteban Rivas ---> jorge.santisteban@estudiante.uam.es
; Santiago Valderrabano Zamorano ---> santiago.valderrabano@estudiante.uam.es
;
;*****************************************************************************

codigo SEGMENT
  ASSUME CS : codigo
  ORG 256

inicio:
  JMP instalador

  matrizEncriptar DB 5,6, 6,1, 6,2, 6,3, 6,4, 6,5, 6,6, 1,1, 1,2, 1,3 	        ; 0,1,2,3,4,5,6,7,8,9
                  DB 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0				                  ; Caracteres especiales
                  DB 1,4, 1,5, 1,6, 2,1, 2,2, 2,3, 2,4, 2,5, 2,6		            ; A,B,C,D,E,F,G,H,I
                  DB 3,1, 3,2, 3,3, 3,4, 3,5, 3,6						                    ; J,K,L,M,N,O
                  DB 4,1, 4,2, 4,3, 4,4, 4,5, 4,6					                    	; P,Q,R,S,T,U
                  DB 5,1, 5,2, 5,3, 5,4, 5,5					   		                    ; V,W,X,Y,Z

;Nuestra matriz de  Polibio tiene la letra A en la posicion 14 al ser la pareja 4

  matrizPolibio DB 7, 8, 9, 'A', 'B', 'C'
                DB 'D','E', 'F', 'G', 'H', 'I'
                DB 'J', 'K', 'L', 'M', 'N', 'O'
                DB 'P', 'Q', 'R', 'S', 'T', 'U'
                DB 'V', 'W', 'X', 'Y', 'Z', 0
                DB 1, 2, 3, 4, 5, 6

  ; CADENAS A IMPRIMIR POR PANTALLA

  vaciarPantalla	DB 	1BH,"[2","J$"

  separador DB "--------------------------------------------------------------", 13, 10, "$"

  driverInstalado	DB 	1BH,"[3;1f Driver Status: Instalado", 13, 10, "$"

  driverNoInstalado	DB 	1BH,"[3;1f Driver Status: No instalado", 13, 10, "$"

  datosPareja	DB 	1BH, "[5;1f Numero de pareja (Polibio): 4", 13, 10, " Autores: Jorge Santisteban y Santiago Valderrabano$"

  instruccionesUso	DB 	1BH, "[7;1f  - Para instalar el driver usar /I", 13, 10, "  - Para desinstalar el driver usar /D", 13, 10, "$"

  firma DW 1010

rsi PROC FAR

  PUSH AX BX CX DI DX SI

  ;Si AH==10h llamamos a ENCRIPTAR

  CMP AH, 10h
  JZ ENCRIPTAR

  ;Si AH==11h llamamos a ENCRIPTAR

  CMP AH, 11h
  JZ DESENCRIPTAR

  JMP FIN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ENCRIPTAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ENCRIPTAR:

  MOV BX, DX
  MOV DI, 0

NUEVOCARACTERE:

  MOV AX, 0
  MOV AL, DS:[BX][DI]

  ;Comprobamos si nos encontramos al final de la cadena

  CMP AL, "$"
  JZ FIN

  ;Restamos 30h y multiplicamos por 2 para conocer la posicion en matrizEncriptar

  SUB AL, 30h
  MOV AH, 0
  MOV CX, 2
  MUL CX
  MOV SI, AX
  MOV CX, WORD PTR matrizEncriptar[SI]

  ; Imprimimos el primer caracter
  MOV DL, CL
  ADD DL, 30h
  MOV AH, 2
  INT 21h

  ; Imprimimos el segundo caracter
  MOV DL, CH
  ADD DL, 30h
  MOV AH, 2
  INT 21h

  ; Leemos el siguiente caracter

  INC DI
  JMP NUEVOCARACTERE


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DESENCRIPTAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DESENCRIPTAR:

  MOV BX, DX
  MOV SI, 0

NUEVOCARACTERD:

  ;Leemos la fila

  MOV AL, DS:[BX][SI]
  MOV AH, 0

  ;Comprobamos que no sea el final de la cadena

  CMP AL, "$"
  JZ FIN

  ;Restamos 31h(30h del ASCII y 1 ya que empezamos a contar desde el 0 y no desde el 1)

  SUB AL, 31h

  ;Multiplicamos por 6 para poder tantas filas como sean necesarias en matrizPolibio
  MOV CX, 6
  MUL CX

  INC SI

  ;Leemos la columna

  MOV CL, DS:[BX][SI]
  MOV CH, 0

  CMP CL, "$"
  JZ FIN

  ;Restamos 31h(30h del ASCII y 1 ya que empezamos a contar desde el 0 y no desde el 1)

  SUB CL, 31h

  ;Sumamos la distancia de la fila más la de la columna

  MOV DI, CX
  ADD DI, AX

  ;Imprimimos el caracter decodificado

  MOV DL, matrizPolibio[DI]
  MOV DH, 0
  MOV AH, 2
  INT 21h

  ;Leemos un nuevo caracter

  INC SI
  JMP NUEVOCARACTERD

FIN:
  POP SI DX DI CX BX AX
  IRET

rsi ENDP

instalador PROC

  ;Compobramos que los parametros de entrada sean /I o /D

  CMP BYTE PTR ES:[82h], '/'
  JNE errorArgs
  CMP BYTE PTR ES:[83h], 'I'
  JE instalar1
  CMP BYTE PTR ES:[83h], 'D'
  JE desinstalar_57h
  JMP errorArgs

instalador ENDP

;Caso en el que no tengamos /I ni /D

errorArgs PROC
  ; Borramos la pantalla para imprimir
  MOV AH, 9
  MOV DX, OFFSET vaciarPantalla
  INT 21h

  ;Comprobamos si el driver esta instalado mediante la firma

  MOV AX, 0
  MOV ES, AX
  MOV DX, firma
  MOV BX, ES:[4*57h]
  MOV AX, ES:[4*57h + 2]
  MOV ES, AX
  CMP ES:[BX - 2], DX

  JNE NOINSTALADO

  ; Imprimir texto driver instalado
  MOV AH, 9
  MOV DX, OFFSET driverInstalado
  INT 21h
  JMP TERMINAR

  ; Imprimir texto driver no instalado

NOINSTALADO:
  MOV AH, 9
  MOV DX, OFFSET driverNoInstalado
  INT 21h

  ; Imprimir la pareja y las instrucciones de uso

TERMINAR:
  MOV DX, OFFSET separador
  INT 21h

  MOV DX, OFFSET datosPareja
  INT 21h

  MOV DX, OFFSET instruccionesUso
  INT 21h

  MOV DX, OFFSET separador
  INT 21h
  RET
errorArgs ENDP

instalar1:
    JMP instalar

    ;Desinstalación del driver

desinstalar_57h PROC

  PUSH AX BX CX DS ES
  MOV CX, 0
  MOV DS, CX              ; Segmento vectores interrupcion
  MOV ES, DS:[4*57h + 2]  ; Lee segmento de rsi
  MOV BX, ES:[2Ch]        ; Lee segmento de entorno del psp de rsi
  MOV AH, 49h   ; Libera segmento de rsi
  INT 21h
  MOV ES, BX   ; Libera segmento de variables de entorno de rsi
  INT 21h

  CLI
  MOV DS:[4*57h], CX
  MOV DS:[4*57h + 2], CX
  STI

  MOV AH, 9
  MOV DX, OFFSET vaciarPantalla
  INT 21h

  POP ES DS CX BX AX
  RET
desinstalar_57h ENDP

  ;Instalacion del driver

instalar:
  MOV AX, 0
  MOV ES, AX
  MOV CX, firma     ; Comprobamos si ya esta instalado o no
  MOV BX, ES:[4*57h]
  MOV AX, ES:[4*57h + 2]
  MOV ES, AX
  CMP ES:[BX - 2], CX

  ; Si la firma no coincide seguimos el proceso, sino volvemos
  JNE SEGUIRINSTALACION
  RET

SEGUIRINSTALACION:
  MOV AX, OFFSET rsi
  MOV BX, CS
  CLI
  ; Instalamos el programa
  MOV CX, firma
  MOV ES:[4*57h], AX
  MOV ES:[4*57h + 2], BX

  ; Ponemos la firma al principio
  MOV ES, AX
  MOV ES:[BX - 2], CX
  STI

  ; Imprimimos el estado de instalacion del driver
  MOV AH, 9
  MOV DX, OFFSET vaciarPantalla
  INT 21h

  MOV DX, OFFSET driverInstalado
  INT 21h

  MOV DX, OFFSET separador
  INT 21h

  MOV DX, OFFSET instalar
  INT 27h

codigo ENDS
END inicio
