// Signals that go out of the CPU
`define CtlSig_rW           0
`define CtlSig_halted       1
`define CtlSig_sync         2

// CPU internal signals
`define CtlSig_RegYWrite    3
`define CtlSig_RegXWrite    4
`define CtlSig_RegSWrite    5
`define CtlSig_RegAccWrite  6
`define CtlSig_PcAdvance    7
`define CtlSig_Jump         8
`define CtlSig_IrIn         9

`define CtlSig__NumSignals  10
