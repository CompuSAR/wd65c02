`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
// 
// Create Date: 10/07/2021 05:07:16 PM
// Design Name: WD65C02S core almost compatible design
// Module Name: status_register
// Project Name: CompuSAR
// Target Devices: Xilinx Spartan-7
// Tool Versions: Vivado 2021.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
// License:
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
//
//////////////////////////////////////////////////////////////////////////////////


module status_register(
    input [7:0] data_in,
    output reg [7:0]data_out,
    input clock,
    input RESET,

    input update_c,
    input [`StatusZeroCtl__NBits-1:0] update_z,
    input update_i,
    input update_d,
    input output_b,
    input update_v,
    input update_n
);

reg [7:0]status = 8'b0011_0100;

always_comb
begin
    data_out = status;
    data_out[`Flags_Brk] = output_b;
    data_out[`Flags__Unused] = 1'b1;
end

always_ff@(posedge clock)
begin
    if( RESET ) begin
        status[`Flags_Decimal] <= 1'b0;
        status[`Flags_IrqDisable] <= 1'b1;
    end else begin
        if( update_c )
            status[`Flags_Carry] <= data_in[`Flags_Carry];
        case(update_z)
            `StatusZeroCtl_Preserve:        ;
            `StatusZeroCtl_Data:            status[`Flags_Zero] <= data_in[`Flags_Zero];
            `StatusZeroCtl_Calculate:       status[`Flags_Zero] <= data_in == 7'b0;
            default:                        status[`Flags_Zero] <= 1'bX;
        endcase
        if( update_i )
            status[`Flags_IrqDisable] <= data_in[`Flags_IrqDisable];
        if( update_d )
            status[`Flags_Decimal] <= data_in[`Flags_Decimal];
        if( update_v )
            status[`Flags_oVerflow] <= data_in[`Flags_oVerflow];
        if( update_n )
            status[`Flags_Neg] <= data_in[7];
    end
end

endmodule
