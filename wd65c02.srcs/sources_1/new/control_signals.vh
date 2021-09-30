// Signals that go out of the CPU
`define CtlSig_write        0
`define CtlSig_halted       1

// Decoder internal signals
//`define CtlSig_IrIn         3
//`define CtlSig_OprandDone   4

// CPU internal signals
`define CtlSig_RegYWrite    5
`define CtlSig_RegXWrite    6
`define CtlSig_RegSWrite    7
`define CtlSig_RegAccWrite  8
`define CtlSig_PcAdvance    9
`define CtlSig_Jump         10
`define CtlSig_AluInverse   11

`define CtlSig__NumSignals  12

`define DataLatch_Nop           2'b00
`define DataLatch_LoadHi        2'b01
`define DataLatch_LoadLowHiZero 2'b10
`define DataLatch_LoadLowHiOne  2'b11
`define DataLatch__NBits        2

`define AluOp_pass  0
`define AluOp_add   1
`define AluOp_and   2
`define AluOp_or    3
`define AluOp_xor   4

`define AluOp__NumOps   8
`define AluOp__NBits    $clog2( `AluOp__NumOps )

`define Flags_Carry         0
`define Flags_Zero          1
`define Flags_IrqDisable    2
`define Flags_Decimal       3
`define Flags_Brk           4
`define Flags_oVerflow      6
`define Flags_Neg           7
