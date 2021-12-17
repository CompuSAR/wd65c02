//   Copyright (C) 2021.
//   Copyright owners listed in AUTHORS file.
//
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation; either version 2 of the License, or
//   (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with this program; if not, write to the Free Software
//   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
`define DataBusSrc_Zero     0
`define DataBusSrc_Ones     1
`define DataBusSrc_RegY     2
`define DataBusSrc_RegX     3
`define DataBusSrc_RegS     4
`define DataBusSrc_ALU      5
`define DataBusSrc_RegAcc   6
`define DataBusSrc_PCL      7
`define DataBusSrc_PCH      8
`define DataBusSrc_Status   9

`define DataBusSrc_Mem      10

`define DataBusSrc__NumOptions 11
`define DataBusSrc__NBits $clog2( `DataBusSrc__NumOptions )


// Data latch low sources
`define DllSrc_None         0
`define DllSrc_DataIn       1
`define DllSrc_AluRes       2
`define DllSrc_Nmi          3
`define DllSrc_Reset        4
`define DllSrc_Irq          5

`define DllSrc__NumOptions  6
`define DllSrc__NBits $clog2( `DllSrc__NumOptions )


// Data latch high sources
`define DlhSrc_None         0
`define DlhSrc_Zero         1
`define DlhSrc_Ones         2
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


`define AluASrc_Zero      0
`define AluASrc_Acc       1
`define AluASrc_RegX      2
`define AluASrc_RegY      3
`define AluASrc_RegS      4
`define AluASrc_DlLow     5
`define AluASrc_DlHigh    6
`define AluASrc_PcLow     7
`define AluASrc_PcHigh    8

`define AluASrc__NumOptions 9
`define AluASrc__NBits $clog2( `AluASrc__NumOptions )


`define AluBSrc_Zero            0
`define AluBSrc_DataBus         1

`define AluBSrc__NumOptions     2
`define AluBSrc__NBits  $clog2( `AluBSrc__NumOptions )


`define AluCarryIn_Zero         0
`define AluCarryIn_One          1
`define AluCarryIn_Carry        2

`define AluCarryIn__NumOptions  3
`define AluCarryIn__NBits $clog2( `AluCarryIn__NumOptions )


`define PcLowIn_Preserve        0
`define PcLowIn_Dl              1
`define PcLowIn_Alu             2
`define PcLowIn_Mem             3

`define PcLowIn__NumOptions     4
`define PcLowIn__NBits  $clog2( `PcLowIn__NumOptions )


`define PcHighIn_Preserve       0
`define PcHighIn_Ones           1
`define PcHighIn_Mem            2
`define PcHighIn_Alu            3

`define PcHighIn__NumOptions    4
`define PcHighIn__NBits  $clog2( `PcHighIn__NumOptions )


`define StackIn_Preserve        0
`define StackIn_AluRes          1
`define StackIn_DataBus         2

`define StackIn__NumOptions     3
`define StackIn__NBits  $clog2( `StackIn__NumOptions )


`define StatusSrc_Data          0
`define StatusSrc_ALU           1

`define StatusSrc__NumOptions   2
`define StatusSrc__NBits    $clog2(`StatusSrc__NumOptions)
