`define DataBusSrc_Zeros    0
`define DataBusSrc_RegY     1
`define DataBusSrc_RegX     2
`define DataBusSrc_RegS     3
`define DataBusSrc_ALU      4
`define DataBusSrc_RegAcc   5

`define DataBusSrc_Mem      6

`define DataBusSrc__NumOptions 9
`define DataBusSrc__NBits $clog2( `DataBusSrc__NumOptions )


// Data latch low sources
`define DllSrc_None         0
`define DllSrc_DataIn       1
`define DllSrc_AluRes       2

`define DllSrc__NumOptions  3
`define DllSrc__NBits $clog2( `DllSrc__NumOptions )


// Data latch high sources
`define DlhSrc_None         0
`define DlhSrc_Zero         1
`define DlhSrc_One          2
`define DlhSrc_DataIn       3
`define DlhSrc_AluRes       4

`define DlhSrc__NumOptions  5
`define DlhSrc__NBits $clog2( `DlhSrc__NumOptions )


`define AddrBusLowSrc_Pc        0
`define AddrBusLowSrc_Dl        1
`define AddrBusLowSrc_Sp        2
`define AddrBusLowSrc_DataIn    3

`define AddrBusLowSrc__NumOptions 4
`define AddrBusLowSrc__NBits $clog2( `AddrBusLowSrc__NumOptions )

`define AddrBusHighSrc_Zero     0
`define AddrBusHighSrc_One      1
`define AddrBusHighSrc_Pc       2
`define AddrBusHighSrc_Dl       3

`define AddrBusHighSrc__NumOptions 4
`define AddrBusHighSrc__NBits $clog2( `AddrBusHighSrc__NumOptions )


`define AluInSrc_Acc       0
`define AluInSrc_RegX      1
`define AluInSrc_RegY      2
//`define AluInSrc_RegS      3
`define AluInSrc_DlLow     3
`define AluInSrc_DlHigh    4
`define AluInSrc_PcLow     5
`define AluInSrc_PcHigh    6

`define AluInSrc__NumOptions 7
`define AluInSrc__NBits $clog2( `AluInSrc__NumOptions )


`define AluCarryIn_Zero         0
`define AluCarryIn_One          1

`define AluCarryIn__NumOptions  2
`define AluCarryIn__NBits $clog2( `AluCarryIn__NumOptions )