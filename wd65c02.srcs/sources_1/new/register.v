`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
//
// Create Date: 09/11/2021 06:02:01 PM
// Design Name: WD65C02S core almost compatible design
// Module Name: register
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


module register#(parameter DataBits = 8)(
    input [DataBits-1:0] data_in,
    output [DataBits-1:0] data_out,
    input clock,
    input write_enable,
    input bReset
    );

reg [DataBits-1:0]data;
assign data_out = data;

always@(posedge clock, negedge bReset)
begin
    if( !bReset )
        data <= 0;
    else if( write_enable )
        data <= data_in;
end

endmodule
