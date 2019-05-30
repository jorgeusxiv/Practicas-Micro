
;*****************************************************************************
; PRACTICA 1 APARTADO A SISTEMAS BASADOS EN MICROPROCESADORES
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
  MOV AX, 5000h
  MOV DS, AX
  MOV AX, 6000h
  MOV ES, AX
  MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
  ; FIN DE LAS INICIALIZACIONES

  ; COMIENZO DEL PROGRAMA

  MOV AX, 15h          ;; Cargamos 15h en AX
  MOV BX, 0BBh          ;; Cargamos BBh en BX
  MOV CX, 3412h        ;; Cargamos 3412h en CX
  MOV DX, CX           ;; Metemos CX en DX
  MOV BH, ES:[5536h]      ;; Cargar en BH el contenido de la posición de memoria 65536H
  MOV BL, ES:[5537h]      ;; Cargar en BL en contenido de la posición 65537H
  MOV DS:[0005h], CH   ;; Cargar en la posición de memoria 50005H el contenido de CH
  MOV AX, [SI]         ;; Cargar en AX el contenido de la dirección de memoria apuntada por SI
  MOV BX, [BP + 10]    ;; Cargar en BX el contenido de la dirección de memoria que está 10 bytes por encima de la dirección apuntada por BP

  ; FIN DEL PROGRAMA
  MOV AX, 4C00H
  INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
