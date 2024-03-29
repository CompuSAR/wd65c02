`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
//
// Create Date: 09/17/2021 05:06:22 PM
// Design Name: WD65C02S core almost compatible design
// Module Name: input_data_latch
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
///////////////////////////////////////////////////////////////////////////////////

module input_data_latch(
    input [7:0] data_in_low,
    input data_in_low_enable,
    input [7:0] data_in_high,
    input data_in_high_enable,
    input clock,
    output reg [15:0] data_out
    );

always_ff@(negedge clock) begin
    if( data_in_low_enable )
        data_out[7:0] <= data_in_low;
    if( data_in_high_enable )
        data_out[15:8] <= data_in_high;
end

endmodule
