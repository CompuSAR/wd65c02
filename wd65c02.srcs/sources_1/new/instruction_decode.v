`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
// 
// Create Date: 09/15/2021 10:43:31 PM
// Design Name: WD65C02S core almost compatible design 
// Module Name: instruction_decode
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

`include "bus_sources.vh"
`include "control_signals.vh"

module instruction_decode(
        input [7:0]data_in,
        input clock,
        input RESET,
        output reg [`CtlSig__NumSignals-1:0]control_signals,
        output reg [`DataBusSrc__NBits-1:0]data_bus_source,
        output reg [`AddrBusSrc__NBits-1:0]address_bus_source
    );

reg [3:0]timing_counter; // 4 bits ought to be enough for anybody

initial begin
    clear_signals();
    control_signals[`CtlSig_halted] <= 1;
end

always@(negedge clock) begin
    clear_signals();
    if( ! RESET )
        do_reset();
    else begin
        if( timing_counter==0 ) begin
            control_signals[`CtlSig_PcAdvance] <= 1;
        end else if( timing_counter==1 ) begin
        end
    end
end

task do_reset();
begin
    timing_counter <= 0;
    clear_signals();
end
endtask

task clear_signals();
begin
    control_signals <= {`CtlSig__NumSignals{1'b0}};
    data_bus_source <= {`DataBusSrc__NumOptions{1'b0}};
    address_bus_source <= {`AddrBusSrc__NumOptions{1'b0}};
end
endtask

endmodule
