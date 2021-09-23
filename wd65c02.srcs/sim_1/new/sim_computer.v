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


module sim_computer();

// Timing parameters for 14Mhz operation
localparam tACC = 30;       // Access time (min)
localparam tAH = 10;        // Address hold time (min)
localparam tADS = 30;       // Address setup time (max)
localparam tBVD = 25;       // BE to valid data (max)
localparam tPWH = 35;       // Clock pulse width high (min)
localparam tPWL = 35;       // Clock pulse width low (min)
localparam tCYC = 70;       // Cycle time (min)
localparam tF = 5;          // Fall time (max)
localparam tR = 5;          // Rise time (max)
localparam tPCH = 10;       // Processor control hold time (min)
localparam tPCS = 10;       // Processor control setup time (min)
localparam tDHR = 10;       // Read data hold time (min)
localparam tDSR = 10;       // Read data setup time (min)
localparam tMDS = 25;       // Write data delay time (max)
localparam tDHW = 10;       // Write data hold time (min)

wire [15:0]address_bus;
wire [7:0]data_bus_out;
wire data_bus_rW;

reg clock;
reg RESET;
reg [7:0]data_bus_in;

wd65c02 cpu(
    .address(address_bus),
    .data_out(data_bus_out),
    .data_in(data_bus_in),
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
    memory[16'h0001] = 8'ha9; // LDA #$01
    memory[16'h0002] = 8'h01;
    memory[16'h0003] = 8'ha9; // LDA #$03
    memory[16'h0004] = 8'h03;
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
    memory[16'h0012] = 8'ha2; // LDX #$c1
    memory[16'h0013] = 8'hc1;
    memory[16'h0014] = 8'hbd; // LDA $3781,x
    memory[16'h0015] = 8'h81;
    memory[16'h0016] = 8'h37;
    memory[16'h0017] = 8'hbd; // LDA $fff0,x
    memory[16'h0018] = 8'hf0;
    memory[16'h0019] = 8'hff;
    memory[16'h001a] = 8'hea; // NOP

    memory[16'h00b1] = 8'h17; // Command at adderss 17 should load this value
    memory[16'h00a9] = 8'h05; // Command at adderss 5 should load this value
    memory[16'h01b1] = 8'hXX; // Command at adderss 17 should NOT load this value
    memory[16'h3785] = 8'h0e; // Command at address e should load this value
    memory[16'h3742] = 8'hXX; // Command at address 14 should NOT load this value
    memory[16'h3842] = 8'h14; // Command at address 14 should load this value
    memory[16'h8623] = 8'h08; // Command at address 8 should load this value
    memory[16'hffb1] = 8'hXX; // Command at adderss 17 should NOT load this value
end

initial begin    
    clock = 0;
    
    forever begin
        #tDHR data_bus_in = 8'bX;
        #(tPWL-tDHR) clock = 1;
        #(tPWH-tDSR) data_bus_in=memory[address_bus];
        #tDSR clock = 0;
    end
end

initial begin
    RESET = 0;
    
    #4004 RESET = 1;
end

endmodule
