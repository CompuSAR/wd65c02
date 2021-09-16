`define DataBusSrc_Zeros    0
`define DataBusSrc_RegY     1
`define DataBusSrc_RegX     2
`define DataBusSrc_RegS     3
`define DataBusSrc_ALU      4
`define DataBusSrc_RegAcc   5
`define DataBusSrc_PCL      6
`define DataBusSrc_PCH      7

`define DataBusSrc_Mem      8

`define DataBusSrc__NumOptions 9

`define DataBusSrc__NBits $clog2( `DataBusSrc__NumOptions-1 )
