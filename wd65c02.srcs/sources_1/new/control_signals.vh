// Signals that go out of the CPU
`define CtlSig_write        0
`define CtlSig_halted       1
`define CtlSig_sync         2

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

`define CtlSig_DataLatchBase    11
`define DataLatch_Nop           2'b00
`define DataLatch_LoadHiAndPush 2'b01
`define DataLatch_LoadLowHiZero 2'b10
`define DataLatch_LoadLowHiOne  2'b11
`define DataLatch__NBits        2

`define CtlSig__NumSignals  13
