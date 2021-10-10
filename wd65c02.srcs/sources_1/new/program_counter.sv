`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
//
// Create Date: 09/16/2021 06:54:27 AM
// Design Name: WD65C02S core almost compatible design
// Module Name: program_counter
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
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
    input [15:0] addr_in,
    output [15:0] addr_out,
    input advance,
    input jump,
    input clock,
    input RESET
    );

reg [15:0]address;
assign addr_out = address;

always@(negedge clock) begin
    if( ! RESET ) begin
        address <= 16'h0;
    end else if( advance && !jump ) begin
        address <= address + 1;
    end else if( jump && !advance ) begin
        address <= addr_in;
    end else if( jump && advance )
        address <= 15'bX; // Invalid state
end

endmodule
