`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
// 
// Create Date: 10/29/2021 05:57:06 PM
// Design Name: WD65C02S core almost compatible design
// Module Name: async_edge_signal
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
// Report falling edge of an async signal has happened for 1 clock cycle (low
// then high) after it happened
// 
//////////////////////////////////////////////////////////////////////////////////


module async_edge_signal(
    input clock,
    input signal,
    output triggered
    );

localparam NumClocksToReport = 1;

int clocksUntilReset = 0;
logic lastKnownState = 0;

assign triggered = clocksUntilReset!=0;

always_ff@(negedge clock) begin
    if( clocksUntilReset!=0 )
        clocksUntilReset <= clocksUntilReset-1;

    if( lastKnownState ) begin
        if( !signal ) begin
            clocksUntilReset <= NumClocksToReport;
        end
    end

    lastKnownState <= signal;
end

endmodule
