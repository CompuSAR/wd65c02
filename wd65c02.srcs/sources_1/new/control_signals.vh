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
`define CtlSig_StatUpdateC      0
`define CtlSig_StatUpdateI      1
`define CtlSig_StatUpdateD      2
`define CtlSig_StatOutputB      3
`define CtlSig_StatUpdateV      4
`define CtlSig_StatUpdateN      5

`define CtlSig_RegYWrite        6
`define CtlSig_RegXWrite        7
`define CtlSig_RegAccWrite      8
`define CtlSig_PcAdvance        9
`define CtlSig_Jump             10
`define CtlSig_AluInverse       11
`define CtlSig_ResetStatus      12

`define CtlSig__NumSignals      13

`define StatusZeroCtl_Preserve          0
`define StatusZeroCtl_Data              1
`define StatusZeroCtl_Calculate         2

`define StatusZeroCtl__NumSignals       3
`define StatusZeroCtl__NBits            $clog2(`StatusZeroCtl__NumSignals)

`define AluOp_pass              0
`define AluOp_add               1
`define AluOp_and               2
`define AluOp_or                3
`define AluOp_xor               4
`define AluOp_shift_left        5
`define AluOp_shift_right       6

`define AluOp__NumOps           7
`define AluOp__NBits    $clog2( `AluOp__NumOps )

`define Flags_Carry         0
`define Flags_Zero          1
`define Flags_IrqDisable    2
`define Flags_Decimal       3
`define Flags_Brk           4
`define Flags__Unused       5
`define Flags_oVerflow      6
`define Flags_Neg           7
