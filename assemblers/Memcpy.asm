org     1000h
memcpy      public

            ; --- 1. Guard against 0 total bytes ---
            mov     a,b
            ora     c
            ret     z           ; Return immediately if BC == 0

            ; --- 2. Handle Remainder Bytes (BC % 4) ---
            mov     a,c
            ani     03h         ; A = C & 3 (0, 1, 2, or 3 remainder bytes)
            jz      prep_blocks ; Skip if length is already a multiple of 4

rem_loop:   ldax    d           ; Copy one remainder byte
            mov     m,a
            inx     d
            inx     h
            dcx     b           ; Decrement total count
            dcr     a           ; Decrement remainder count
            jnz     rem_loop

            ; --- 3. Prepare Block Count (BC = BC / 4) ---
prep_blocks:
            mov     a,b
            ora     c
            ret     z           ; Return if total count was < 4 (BC is now 0)

            ; Shift BC right twice (divide by 4)
            ora     a           ; Clear carry flag
            mov     a,b
            rar
            mov     b,a
            mov     a,c
            rar
            mov     c,a         ; BC = BC >> 1

            ora     a           ; Clear carry flag
            mov     a,b
            rar
            mov     b,a
            mov     a,c
            rar
            mov     c,a         ; BC = BC >> 2

            ; --- 4. High-Speed 4x Unrolled Loop ---
loop4:      ldax    d           ; Byte 1
            mov     m,a
            inx     d
            inx     h

            ldax    d           ; Byte 2
            mov     m,a
            inx     d
            inx     h

            ldax    d           ; Byte 3
            mov     m,a
            inx     d
            inx     h

            ldax    d           ; Byte 4
            mov     m,a
            inx     d
            inx     h

            dcx     b           ; Decrement 4-byte block counter
            mov     a,b
            ora     c
            jnz     loop4       ; Loop until all 4-byte blocks are copied

            ret
