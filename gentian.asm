; Copyright 2015-2020 Matt "MateoConLechuga" Waltz
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; 1. Redistributions of source code must retain the above copyright notice,
;    this list of conditions and the following disclaimer.
;
; 2. Redistributions in binary form must reproduce the above copyright notice,
;    this list of conditions and the following disclaimer in the documentation
;    and/or other materials provided with the distribution.
;
; 3. Neither the name of the copyright holder nor the names of its contributors
;    may be used to endorse or promote products derived from this software
;    without specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.

flash_privilege:
	dl	0

gentian:

.port_setup:
	push	af, iy, ix, de, bc
	call    $021ED4
	push	hl
	pop	ix
	ld	hl,(ix + 6)
	ld	a,l
	cp	a,5
	jq	nz,.invalid_os
	ld	a,h
	cp	a,5
	jq	c,.ospre55
	ld	de,$010505
	or	a,a
	sbc	hl,de
	add	hl,de
	jq	z,.os551
	ld	de,$020505
	or	a,a
	sbc	hl,de
	add	hl,de
	jq	z,.os552
	ld	de,$050505
	or	a,a
	sbc	hl,de
	add	hl,de
	jq	z,.os555
	ld	de,$000605
	or	a,a
	sbc	hl,de
	add	hl,de
	jq	nz,.invalid_os
.os560:
	ld	hl,port_os560.unlock
	ld	de,port_os560.lock
	jq	.computeos
.os555:
	ld	hl,port_os555.unlock
	ld	de,port_os555.lock
	jq	.computeos
.os552:
	ld	hl,port_os552.unlock
	ld	de,port_os552.lock
	jq	.computeos
.os551:
	ld	hl,port_os551.unlock
	ld	de,port_os551.lock
	jq	.computeos
.ospre55:
	ld	hl,port_ospre55.unlock
	ld	de,port_ospre55.lock
	jq	.computeos
.computeos:
	ld	(gentian.ucode),hl
	ld	(gentian.lcode),de
	or	a, a
	sbc	hl, hl
	pop	bc, de, ix, iy, af
	ret
.invalid_os:
	pop	bc, de, ix, iy, af
	ld	hl, 1
	ret

.unlock:
	push	de,bc,hl
	call	0
.ucode := $-3
.pop:
	pop	hl,bc,de
	ret

.lock:
	push	de,bc,hl
	call	0
.lcode := $-3
	jr	.pop

port_ospre55:
.unlock:
	ld	bc,$24
	ld	a,$8c
	call	.write
	ld	bc,$06
	call	.read
	or	a,4
	call	.write
	ld	bc,$28
	ld	a,$4
	call	.write
	ld	bc, $1D
	call	.read
	ld	(flash_privilege), a
	inc	bc
	call	.read
	ld	(flash_privilege+1), a
	inc	bc
	call	.read
	ld	(flash_privilege+2), a
	ld	bc, $1D
	ld	a, $FF
	call	.write
	inc	bc
	call	.write
	ld	a, $3F
	inc	bc
	jr	.write
.lock:
	ld	bc,$28
	xor	a,a
	call	.write
	ld	bc,$06
	call	.read
	res	2,a
	call	.write
	ld	bc,$24
	ld	a,$88
	call	.write
	ld	a, $7C
	ld	bc, $20
	call	.write
	ld	a, $88
	inc	bc
	call	.write
	ld	a, $D1
	inc	bc
	call	.write
	ld	a, $7C
	inc	bc
	call	.write
	ld	a, $88
	inc	bc
	call	.write
	ld	a, $D1
	inc	bc

.write:
	ld	de,$c979ed
	ld	hl, ti.heapBot - 3
	ld	(hl),de
	jp	(hl)
.read:
	ld	de,$c978ed
	ld	hl, ti.heapBot - 3
	ld	(hl),de
	jp	(hl)

port_os560:
.helper:
	push	hl
	ld	hl,$d09466
	push	hl
	push	de
	xor	a,a
	jp	(ix)
.unlock:
	ld	ix,$b99bb
.unlock0:
	ld	hl,.unlockhelper
	jq	.helper
.unlockhelper:
	ld	a,$8c
	out0	($24),a
	in0	a,($06)
	or	a,$04
	out0	($06),a
	ld	a,$04
	out0	($28),a
; full flash privilege
	in0	a, ($1D)
	ld	(flash_privilege), a
	in0	a, ($1E)
	ld	(flash_privilege+1), a
	in0	a, ($1F)
	ld	(flash_privilege+2), a
	ld	a, $FF
	out0	($1D), a
	out0	($1E), a
	ld	a, $3F
	out	($1F), a
	ret
.lock:
.lock0:
	xor	a,a
	out0	($28),a
	in0	a,($06)
	res	2,a
	out0	($06),a
	ld	a,$88
	out0	($24),a
	ld	a,$d1
	out0	($22),a
	ld	a, (flash_privilege)
	out0	($1D), a
	ld	a, (flash_privilege+1)
	out0	($1E), a
	ld	a, (flash_privilege+2)
	out	($1F), a
	ld	a, $7C
	out0	($20), a
	out0	($23), a
	ld	a, $88
	out0	($21), a
	out0	($24), a
	ld	a, $D1
	out0	($22), a
	out0	($25), a
	ret

port_os555:
.unlock:
	ld	ix,$b96df
	jq	port_os560.unlock0
.lock:
	jq	port_os560.lock0

port_os552:
.unlock:
	ld	ix,$bd573
	jq	port_os560.unlock0
.lock:
	jq	port_os560.lock0

port_os551:
.unlock:
	ld	ix,$bd55f
	jq	port_os560.unlock0
.lock:
	jq	port_os560.lock0
