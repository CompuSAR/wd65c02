`define CtlSig_StatUpdateC      0
`define CtlSig_StatUpdateI      1
`define CtlSig_StatUpdateD      2
`define CtlSig_StatOutputB      3
`define CtlSig_StatUpdateV      4
`define CtlSig_StatUpdateN      5

`define CtlSig_RegYWrite        6
`define CtlSig_RegXWrite        7
`define CtlSig_RegSWrite        8
`define CtlSig_RegAccWrite      9
`define CtlSig_PcAdvance        10
`define CtlSig_Jump             11
`define CtlSig_AluInverse       12

`define CtlSig__NumSignals      13

`define StatusZeroCtl_Preserve          0
`define StatusZeroCtl_Data              1
`define StatusZeroCtl_Calculate         2

`define StatusZeroCtl__NumSignals       3
`define StatusZeroCtl__NBits            $clog2(`StatusZeroCtl__NumSignals)

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
`define Flags__Unused       5
`define Flags_oVerflow      6
`define Flags_Neg           7
