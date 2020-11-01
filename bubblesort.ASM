;Автор: Федченко В.А
;Группа: БПИ199
;Вариант: 26
;Задание: Разработать программу сортировки по
;возрастанию методом попарного сравнения и
;перестановки элементов массива слов длиной
;N=15 элементов

format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize       db 'size of vector? ', 0
        strIncorSize     db 'Incorrect size of vector', 10, 0
        strIncorElelm    db 'Incorrect input', 10, 0
        strVecElemI      db '[%d]? ', 0
        strScanInt       db '%d', 0
        strVecElemOut    db '[%d] = %d', 10, 0
        strArrA          db 'Sorted Array:', 10, 0


        short_max_value  dd 32767
        short_min_value  dd -32768
        vec_size         dd 15
        size_minus_one   dd 14
        i                dd ?
        j                dd ?
        tmp              dd ?
        tmp2             dd ?
        tmpStack         dd ?
        vec              rd 15
;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector input
        call VectorInput
; 3) bubble sort vector
        call BubbleSort
; 4) vector out
        call VectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
;Код взят с сайта
;http://softcraft.ru/edu/comparch/practice/asm86/03-subprog/sum2-32/sum.asm
VectorInput:
getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector      ; to end of loop

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        ;i++
        mov ecx, [i]
        inc ecx

        ;vec.Next
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
;Код взят с сайта
;http://softcraft.ru/edu/comparch/practice/asm86/03-subprog/sum2-32/sum.asm
VectorOut:
        mov [tmpStack], esp
        push strArrA
        call [printf]
        mov esp, [tmpStack]

        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        je endOutputVector      ; to end of loop
        mov [i], ecx

        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
        ret

;--------------------------------------------------------------------------
BubbleSort:
getVecSort:
        xor ecx, ecx                               ; i = 0;
        mov ebx, vec                               ; ebx = &vec
outerLoop:                                         ;
        mov [tmp2], ebx                            ; while(i < vec.Size)
        mov [i], ecx                               ; {
        cmp ecx, [vec_size]                        ;
        jge endSort     ; to end of outerLoop      ;
                                                   ;
        xor edi, edi                               ;     j = 0;
                innerLoop:                         ;
                        mov [tmp], ebx             ;     while(j < vec.Size - 1)
                        mov [j], edi               ;     {
                        cmp edi, [size_minus_one]  ;
                        jge outerLoopNext          ;
                                                   ;
                        mov eax, dword[ebx]        ;         if(vec[i] < vec[i + 1])
                        cmp eax, [ebx + 4]         ;           continue;
                        jl next                    ;
                                                   ;
                        mov edx, dword[ebx]        ;         int temp = vec[i];  // На ассемблере не совсем
                        xchg edx, [ebx + 4]        ;         vec[i] = vec[i + 1];  // так, но суть такая же.
                        mov dword[ebx], edx        ;         vec[i + 1] = vec[i];
                 next:                             ;
                        mov edi, [j]               ;         j++;
                        inc edi                    ;
                                                   ;
                        mov ebx, [tmp]             ;
                        add ebx, 4                 ;
                        jmp innerLoop              ;     }
                                                   ;
outerLoopNext:                                     ;
        mov ebx, [tmp2]                            ;
        mov ecx, [i]                               ;     i++;
        inc ecx                                    ;
                                                   ;
        jmp outerLoop                              ;}
endSort:
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'