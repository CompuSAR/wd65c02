`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2021 08:06:23 PM
// Design Name: 
// Module Name: sim_computer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim_computer(

    );

wire [15:0]address_bus;
wire [7:0]data_bus_out;
wire data_bus_rW;

reg clock;
reg RESET;

wd65c02 cpu(
    .address(address_bus),
    .data_out(data_bus_out),
    .data_in(memory[address_bus]),
    .IRQ(1),
    .NMI(1),
    .phi2(clock),
    .rW(data_bus_rW),
    .rdy(1),
    .RES(RESET)
);

reg [7:0]memory[65535:0];

initial begin
    memory[0] = 8'ha9; // LDA #$7a
    memory[1] = 8'h7a;
    
    clock = 0;
    
    forever
        #500 clock = ~clock;
end

initial begin
    RESET = 0;
    
    #4000 RESET = 1;
end

endmodule
