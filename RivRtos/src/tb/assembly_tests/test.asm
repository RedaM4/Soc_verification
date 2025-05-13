
test.elf:     file format elf32-littleriscv


Disassembly of section .text:

10000000 <Reset_Handler>:
10000000:	3e800113          	li	sp,1000
10000004:	2021                	jal	1000000c <main>
10000006:	a001                	j	10000006 <Reset_Handler+0x6>
10000008:	0000                	unimp
	...

1000000c <main>:
1000000c:	4781                	li	a5,0
1000000e:	4651                	li	a2,20
10000010:	00178713          	addi	a4,a5,1
10000014:	0ff77693          	zext.b	a3,a4
10000018:	00d78023          	sb	a3,0(a5)
1000001c:	87ba                	mv	a5,a4
1000001e:	fec719e3          	bne	a4,a2,10000010 <main+0x4>
10000022:	4781                	li	a5,0
10000024:	4751                	li	a4,20
10000026:	0007c683          	lbu	a3,0(a5)
1000002a:	0785                	addi	a5,a5,1
1000002c:	fee79de3          	bne	a5,a4,10000026 <main+0x1a>
10000030:	00001023          	sh	zero,0(zero) # 0 <Reset_Handler-0x10000000>
10000034:	9002                	ebreak
	...

Disassembly of section .init:

10000038 <_start>:
10000038:	fc9ff06f          	j	10000000 <Reset_Handler>

Disassembly of section .eh_frame:

1000003c <.eh_frame>:
1000003c:	0010                	.insn	2, 0x0010
1000003e:	0000                	unimp
10000040:	0000                	unimp
10000042:	0000                	unimp
10000044:	00527a03          	.insn	4, 0x00527a03
10000048:	7c01                	lui	s8,0xfffe0
1000004a:	0101                	addi	sp,sp,0
1000004c:	00020c1b          	.insn	4, 0x00020c1b
10000050:	0010                	.insn	2, 0x0010
10000052:	0000                	unimp
10000054:	0018                	.insn	2, 0x0018
10000056:	0000                	unimp
10000058:	ffb4                	.insn	2, 0xffb4
1000005a:	ffff                	.insn	2, 0xffff
1000005c:	002a                	c.slli	zero,0xa
1000005e:	0000                	unimp
10000060:	0000                	unimp
	...

Disassembly of section .eh_frame_hdr:

10000064 <__GNU_EH_FRAME_HDR>:
10000064:	1b01                	addi	s6,s6,-32
10000066:	ffd43b03          	.insn	4, 0xffd43b03
1000006a:	ffff                	.insn	2, 0xffff
1000006c:	0001                	nop
1000006e:	0000                	unimp
10000070:	ffa8                	.insn	2, 0xffa8
10000072:	ffff                	.insn	2, 0xffff
10000074:	ffec                	.insn	2, 0xffec
10000076:	ffff                	.insn	2, 0xffff

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	3841                	jal	fffff890 <__GNU_EH_FRAME_HDR+0xeffff82c>
   2:	0000                	unimp
   4:	7200                	.insn	2, 0x7200
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <Reset_Handler-0xfffffec>
   c:	002e                	c.slli	zero,0xb
   e:	0000                	unimp
  10:	1004                	addi	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	li	t5,-20
  1c:	3261                	jal	fffff9a4 <__GNU_EH_FRAME_HDR+0xeffff940>
  1e:	3170                	.insn	2, 0x3170
  20:	635f 7032 5f30      	.insn	6, 0x5f307032635f
  26:	617a                	.insn	2, 0x617a
  28:	6d61                	lui	s10,0x18
  2a:	3070316f          	jal	sp,3b30 <Reset_Handler-0xfffc4d0>
  2e:	7a5f 6c61 7372      	.insn	6, 0x73726c617a5f
  34:	30703163          	.insn	4, 0x30703163
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	2029                	jal	10 <Reset_Handler-0xffffff0>
   8:	3431                	jal	fffffa14 <__GNU_EH_FRAME_HDR+0xeffff9b0>
   a:	322e                	.insn	2, 0x322e
   c:	302e                	.insn	2, 0x302e
	...
