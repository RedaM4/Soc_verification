
interrupt_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

fffff000 <exit-0x3c>:
fffff000:	00000297          	auipc	t0,0x0
fffff004:	04028293          	addi	t0,t0,64 # fffff040 <trap_handler>
fffff008:	305293f3          	csrrw	t2,mtvec,t0
fffff00c:	200012b7          	lui	t0,0x20001
fffff010:	c0028293          	addi	t0,t0,-1024 # 20000c00 <exit-0xdfffe43c>
fffff014:	40000313          	li	t1,1024
fffff018:	0062a023          	sw	t1,0(t0)
fffff01c:	0002a223          	sw	zero,4(t0)
fffff020:	000012b7          	lui	t0,0x1
fffff024:	88028293          	addi	t0,t0,-1920 # 880 <exit-0xffffe7bc>
fffff028:	304293f3          	csrrw	t2,mie,t0
fffff02c:	00800293          	li	t0,8
fffff030:	3002a3f3          	csrrs	t2,mstatus,t0
fffff034:	800002b7          	lui	t0,0x80000
fffff038:	00028067          	jr	t0 # 80000000 <exit-0x7ffff03c>

fffff03c <exit>:
fffff03c:	0000006f          	j	fffff03c <exit>

fffff040 <trap_handler>:
fffff040:	80070137          	lui	sp,0x80070
fffff044:	f8410113          	addi	sp,sp,-124 # 8006ff84 <exit-0x7ff8f0b8>
fffff048:	00112023          	sw	ra,0(sp)
fffff04c:	00212223          	sw	sp,4(sp)
fffff050:	00312423          	sw	gp,8(sp)
fffff054:	00412623          	sw	tp,12(sp)
fffff058:	00512823          	sw	t0,16(sp)
fffff05c:	00612a23          	sw	t1,20(sp)
fffff060:	00712c23          	sw	t2,24(sp)
fffff064:	00812e23          	sw	s0,28(sp)
fffff068:	02912023          	sw	s1,32(sp)
fffff06c:	02a12223          	sw	a0,36(sp)
fffff070:	02b12423          	sw	a1,40(sp)
fffff074:	02c12623          	sw	a2,44(sp)
fffff078:	02d12823          	sw	a3,48(sp)
fffff07c:	02e12a23          	sw	a4,52(sp)
fffff080:	02f12c23          	sw	a5,56(sp)
fffff084:	03012e23          	sw	a6,60(sp)
fffff088:	05112023          	sw	a7,64(sp)
fffff08c:	05212223          	sw	s2,68(sp)
fffff090:	05312423          	sw	s3,72(sp)
fffff094:	05412623          	sw	s4,76(sp)
fffff098:	05512823          	sw	s5,80(sp)
fffff09c:	05612a23          	sw	s6,84(sp)
fffff0a0:	05712c23          	sw	s7,88(sp)
fffff0a4:	05812e23          	sw	s8,92(sp)
fffff0a8:	07912023          	sw	s9,96(sp)
fffff0ac:	07a12223          	sw	s10,100(sp)
fffff0b0:	07b12423          	sw	s11,104(sp)
fffff0b4:	07c12623          	sw	t3,108(sp)
fffff0b8:	07d12823          	sw	t4,112(sp)
fffff0bc:	07e12a23          	sw	t5,116(sp)
fffff0c0:	07f12c23          	sw	t6,120(sp)
fffff0c4:	200012b7          	lui	t0,0x20001
fffff0c8:	c0028293          	addi	t0,t0,-1024 # 20000c00 <exit-0xdfffe43c>
fffff0cc:	0002a303          	lw	t1,0(t0)
fffff0d0:	40030313          	addi	t1,t1,1024
fffff0d4:	0062a023          	sw	t1,0(t0)
fffff0d8:	0002a223          	sw	zero,4(t0)
fffff0dc:	00012083          	lw	ra,0(sp)
fffff0e0:	00412103          	lw	sp,4(sp)
fffff0e4:	00812183          	lw	gp,8(sp)
fffff0e8:	00c12203          	lw	tp,12(sp)
fffff0ec:	01012283          	lw	t0,16(sp)
fffff0f0:	01412303          	lw	t1,20(sp)
fffff0f4:	01812383          	lw	t2,24(sp)
fffff0f8:	01c12403          	lw	s0,28(sp)
fffff0fc:	02012483          	lw	s1,32(sp)
fffff100:	02412503          	lw	a0,36(sp)
fffff104:	02812583          	lw	a1,40(sp)
fffff108:	02c12603          	lw	a2,44(sp)
fffff10c:	03012683          	lw	a3,48(sp)
fffff110:	03412703          	lw	a4,52(sp)
fffff114:	03812783          	lw	a5,56(sp)
fffff118:	03c12803          	lw	a6,60(sp)
fffff11c:	04012883          	lw	a7,64(sp)
fffff120:	04412903          	lw	s2,68(sp)
fffff124:	04812983          	lw	s3,72(sp)
fffff128:	04c12a03          	lw	s4,76(sp)
fffff12c:	05012a83          	lw	s5,80(sp)
fffff130:	05412b03          	lw	s6,84(sp)
fffff134:	05812b83          	lw	s7,88(sp)
fffff138:	05c12c03          	lw	s8,92(sp)
fffff13c:	06012c83          	lw	s9,96(sp)
fffff140:	06412d03          	lw	s10,100(sp)
fffff144:	06812d83          	lw	s11,104(sp)
fffff148:	06c12e03          	lw	t3,108(sp)
fffff14c:	07012e83          	lw	t4,112(sp)
fffff150:	07412f03          	lw	t5,116(sp)
fffff154:	07812f83          	lw	t6,120(sp)
fffff158:	07c10113          	addi	sp,sp,124
fffff15c:	30200073          	mret

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	2641                	.insn	2, 0x2641
   2:	0000                	.insn	2, 0x
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <exit-0xfffff028>
   c:	001c                	.insn	2, 0x001c
   e:	0000                	.insn	2, 0x
  10:	7205                	.insn	2, 0x7205
  12:	3376                	.insn	2, 0x3376
  14:	6932                	.insn	2, 0x6932
  16:	7032                	.insn	2, 0x7032
  18:	5f31                	.insn	2, 0x5f31
  1a:	697a                	.insn	2, 0x697a
  1c:	32727363          	bgeu	tp,t2,342 <exit-0xffffecfa>
  20:	3070                	.insn	2, 0x3070
  22:	0800                	.insn	2, 0x0800
  24:	0a01                	.insn	2, 0x0a01
  26:	Address 0x26 is out of bounds.

