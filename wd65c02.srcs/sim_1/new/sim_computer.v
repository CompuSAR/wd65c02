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
    .IRQ(1'b1),
    .NMI(1'b1),
    .phi2(clock),
    .rW(data_bus_rW),
    .rdy(1'b1),
    .RES(RESET)
);

reg [7:0]memory[65535:0];

initial begin
    memory[16'h0000] = 8'hea; // NOP
    memory[16'h0001] = 8'ha9; // LDA #$75
    memory[16'h0002] = 8'h75;
    memory[16'h0003] = 8'ha9; // LDA #$2a
    memory[16'h0004] = 8'h2a;
    memory[16'h0005] = 8'ha5; // LDA $a9
    memory[16'h0006] = 8'ha9;
    memory[16'h0007] = 8'hea; // NOP
    memory[16'h0008] = 8'had; // LDA $8623
    memory[16'h0009] = 8'h23;
    memory[16'h000a] = 8'h86;
    memory[16'h000b] = 8'hea; // NOP
    memory[16'h000c] = 8'ha2; // LDX #$4
    memory[16'h000d] = 8'h04;
    memory[16'h000e] = 8'hbd; // LDA $3781,x
    memory[16'h000f] = 8'h81;
    memory[16'h0010] = 8'h37;
    memory[16'h0011] = 8'hea; // NOP

    memory[16'h00a9] = 8'h17; // Command at adderss 5 should load this value
    memory[16'h3785] = 8'h9c; // Command at address e should load this value
    memory[16'h8623] = 8'hf2; // Command at address 8 should load this value
    
    clock = 0;
    
    forever
        #500 clock = ~clock;
end

initial begin
    RESET = 0;
    
    #4004 RESET = 1;
end

endmodule
