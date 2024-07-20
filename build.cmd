del SPTablet32.exe
del SPTablet32.obj
c:\masm32\bin\ml /c /coff /Zf /Zd /Zi .\SPTablet32.asm
c:\masm32\bin\link /DEBUG /SUBSYSTEM:WINDOWS SPTablet32.obj

