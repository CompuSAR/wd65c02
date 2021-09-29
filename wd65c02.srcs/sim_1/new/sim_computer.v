`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
//
// Create Date: 09/18/2021 08:06:23 PM
// Design Name: WD65C02S core almost compatible design 
// Module Name: sim_computer
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
wire sync;

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
    .sync(sync),
    .RES(RESET)
);

reg [7:0]memory[65535:0];

/*
    Structure:
    Bits        Meaning
    47:44       line type:
    0 - opcode - immediate
    1 - opcode - read
    2 - opcode - write
    3 - expected bus
    4 - set pin state
    5 - wait

    Bit layout for opcode type

    55:52       Event type
    51:48       Number of cycles in command
    47:40       Opcode
    39:24       First address bus access
    23:16       Data bus on last access (only read and write operations)
    15:0        Last address bus access

    Bit layout for set pin type
    0:0         reset value

    Bit layout for wait type
    39:0        Number of picoseconds to wait
 */
localparam BitsInExpectedResult = 56;
localparam OperationBitsHigh = 55;
localparam OperationBitsLow = 52;
localparam OpcodeBitsHigh = 47;
localparam OpcodeBitsLow = 40;
reg [BitsInExpectedResult-1:0]expected_results[7000:0];

initial begin
    $readmemh("memory.mem", memory);
    $readmemh("expected_results.mem", expected_results);
end

initial begin
    // Clock and memory access
    clock = 0;

    forever begin
        #tDHR data_bus_in = 8'bX;
        #(tPWL-tDHR) clock = 1;
        #(tPWH-tDSR) data_bus_in=memory[address_bus];
        #tDSR clock = 0;
    end
end

localparam EndMarker = {4'hf, {BitsInExpectedResult-4{1'b0}}};
integer results_index;
integer opcode_cycle_count;
reg [BitsInExpectedResult-1:0]current_command;
initial begin
    RESET = 0;

    #321 RESET = 1;

    // Wait for the CPU to start after reset
    @(negedge clock)
    @(negedge clock)
    results_index = 0;
    while( expected_results[results_index] != EndMarker ) begin
        current_command = expected_results[results_index];
        case( current_command[OperationBitsHigh:OperationBitsLow] )
        4'h0: expect_opcode();
        4'h1: expect_opcode();
        4'h2: expect_opcode();
        default: begin
            $display("Expected result %d is of unknown type %x at time %t", results_index, current_command[OperationBitsHigh:OperationBitsLow], $time);
            $finish;
        end
        endcase

        results_index = results_index+1;
    end

    $display("Verified simulation run ended at %t after verifying %d events", $time, results_index);
    $finish();
end

task expect_opcode();
begin
    opcode_cycle_count = 0;
    @(posedge clock)
    assert(sync, 0); // "Opcode does not start on fetch cycle"
    assert( address_bus==current_command[39:24], 1 ); // "Command read from wrong address"
    @(negedge clock)
    assert( data_bus_in == current_command[47:40], 2 ); // "Wrong command read"
    opcode_cycle_count = 1;
    while( opcode_cycle_count < current_command[51:48] ) begin
        @(posedge clock)
        assert(!sync, 3 ); // "Opcode shorter than expected"
        
        @(negedge clock)
        opcode_cycle_count = opcode_cycle_count+1;
    end
    
    assert( current_command[15:0] == address_bus, 4 ); // "Last address bus different than expected"
    case( current_command[OperationBitsHigh:OperationBitsLow] )
    4'h0: ; // nothing
    4'h1: begin
        assert( data_bus_rW, 5 ); // "Data bus in write when it should be in read mode"
        assert( current_command[23:16] == data_bus_in, 6 ); // "Last access data incorrect"
    end
    4'h2: begin
        assert( ~data_bus_rW, 7 ); // "Data bus in read when it should be in write mode"
        assert( current_command[23:16] == data_bus_out, 8 ); // "Last access data incorrect"
    end
    endcase
end
endtask

task assert(input cond, input integer msg);
    if( !cond ) begin
        $display("ASSERT failed event %d time %t: %d", results_index, $time, msg);
        $finish();
    end
endtask

endmodule
