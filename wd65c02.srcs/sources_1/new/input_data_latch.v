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
//////////////////////////////////////////////////////////////////////////////////

`include "control_signals.vh"

module input_data_latch(
    input [7:0] data_in,
    output reg [15:0] data_out,
    input clock,
    input [`DataLatch__NBits-1:0] control
    );

always@(posedge clock) begin
    case(control)
    `DataLatch_Nop: ;
    `DataLatch_LoadHiAndPush: begin
        data_out[7:0] <= data_out[15:8];
        data_out[15:8] <= data_in;
    end
    `DataLatch_LoadLowHiZero:
        data_out <= {8'b0, data_in};
    `DataLatch_LoadLowHiOne:
        data_out <= {7'b0, 1'b1, data_in};
    endcase
end

endmodule
