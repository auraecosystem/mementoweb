; Z80 Implementation
; Entry: BC = Count, DE = Source, HL = Target
memcpy:
            ld      a, b
            or      c
            ret     z           ; Safe check: LDIR copies 65,536 bytes if BC starts at 0

            ex      de, hl      ; Z80 LDIR requires HL = Source, DE = Target
            ldir                ; Block copy: (HL) -> (DE), inc HL/DE, dec BC until BC=0
            ret

