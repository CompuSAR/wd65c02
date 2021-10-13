`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
//
// Create Date: 09/19/2021 05:42:25 PM
// Design Name: WD65C02S core almost compatible design
// Module Name: alu
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

module alu(
        input [7:0]a,
        input [7:0]b,
        output reg [7:0]result,
        input carry_in,
        output reg [7:0]status_out,
        input [`AluOp__NBits-1:0]control
    );

always_comb
begin
    status_out = 0;

    case(control)
        `AluOp_pass:            result = a;
        `AluOp_add:             do_plus();
        `AluOp_and:             result = a & b;
        `AluOp_or:              result = a | b;
        `AluOp_xor:             result = a ^ b;
        `AluOp_shift_left:      { status_out[`Flags_Carry], result } = { b, carry_in };
        `AluOp_shift_right:     { result, status_out[`Flags_Carry] } = { carry_in, b };
        default:
            result = 8'bX;
    endcase

    status_out[`Flags_Zero] = result==0;
    status_out[`Flags_Neg] = result[7];
end

reg [8:0]intermediate_result;

task do_plus();
begin
    intermediate_result = a+b+carry_in;
    result = intermediate_result[7:0];

    status_out[`Flags_Carry] = intermediate_result[8];

    if( a[7]==b[7] && a[7]!=result[7] )
        // Adding same sign integer resulted in opposite sign integer: must be an overflow
        status_out[`Flags_oVerflow] = 1;

end
endtask

endmodule
