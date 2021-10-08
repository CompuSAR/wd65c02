`define DataBusSrc_Zero     0
`define DataBusSrc_RegY     1
`define DataBusSrc_RegX     2
`define DataBusSrc_RegS     3
`define DataBusSrc_ALU      4
`define DataBusSrc_RegAcc   5
`define DataBusSrc_PCL      6
`define DataBusSrc_PCH      7
`define DataBusSrc_Status   8

`define DataBusSrc_Mem      9

`define DataBusSrc__NumOptions 10
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


`define AddrBusSrc_Pc       0
`define AddrBusSrc_Dl       1
`define AddrBusSrc_Sp       2
`define AddrBusSrc_Alu      3

`define AddrBusSrc__NumOptions 4
`define AddrBusSrc__NBits $clog2( `AddrBusSrc__NumOptions )


`define AluInSrc_Zero      0
`define AluInSrc_Acc       1
`define AluInSrc_RegX      2
`define AluInSrc_RegY      3
//`define AluInSrc_RegS      3
`define AluInSrc_DlLow     4
`define AluInSrc_DlHigh    5
`define AluInSrc_PcLow     6
`define AluInSrc_PcHigh    7

`define AluInSrc__NumOptions 8
`define AluInSrc__NBits $clog2( `AluInSrc__NumOptions )


`define AluCarryIn_Zero         0
`define AluCarryIn_One          1

`define AluCarryIn__NumOptions  2
`define AluCarryIn__NBits $clog2( `AluCarryIn__NumOptions )


`define PcLowIn_Dl              0

`define PcLowIn__NumOptions     1
`define PcLowIn__NBits  $clog2( `PcLowIn__NumOptions )


`define PcHighIn_Mem            0

`define PcHighIn__NumOptions     1
`define PcHighIn__NBits  $clog2( `PcHighIn__NumOptions )

`define StatusSrc_Data          0
`define StatusSrc_ALU           1

`define StatusSrc__NumOptions   2
`define StatusSrc__NBits    $clog2(`StatusSrc__NumOptions)
