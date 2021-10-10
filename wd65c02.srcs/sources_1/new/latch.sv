`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
//
// Create Date: 09/19/2021 12:51:04 PM
// Design Name: WD65C02S core almost compatible design
// Module Name: latch
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


module latch#(parameter NBits=8)(
    input [NBits-1:0] in,
    output reg [NBits-1:0] out,
    input clock
    );

always_ff@(posedge clock)
    out <= in;

endmodule
