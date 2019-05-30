all: pract2.exe

pract2.exe: pract2.obj
	tlink /v pract2
pract2.obj: pract2.asm
	tasm /zi pract2.asm

clean:
	DEL pract2.obj
	DEL pract2.exe
	DEL pract2.map
