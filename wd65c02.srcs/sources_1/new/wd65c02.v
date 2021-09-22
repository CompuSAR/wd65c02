`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
// 
// Create Date: 09/15/2021 09:12:26 PM
// Design Name: WD65C02S core almost compatible design 
// Module Name: wd65c02
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
// This is an almost compatible version of the WD65C02S core CPU. It includes the separation of the RDY and wait signals.
//
// The following differences are intended between them:
// * There is no use of tri-state. As a result:
//   * The data bus has been split into data_in and data_out
//   * The Bus Enable (BE) signal has been removed, as all it does it place the outputs in high impedance.
// * Removed the deprecated Set Overflow (SOB) signal.
// * The CPU does not produce both waitP and waitN. The implementor feels confident in the user's ability to apply the NOT
//   gate herself, if applicable.
// 
// The implementation follows the WD65C02S data sheet from October 08, 2018, downloaded from
// https://www.westerndesigncenter.com/wdc/documentation/w65c02s.pdf
//
//////////////////////////////////////////////////////////////////////////////////

`include "bus_sources.vh"
`include "control_signals.vh"

module wd65c02(
    output [15:0]address,
    output reg [7:0]data_out,
    input [7:0] data_in,
    input IRQ,
    output reg ML,
    input NMI,
    input phi2,
    output rW,
    input rdy,
    input RES,
    output sync,
    output VP,
    output waitP
    );

wire [7:0]data_bus;
wire [`DataBusSrc__NBits-1:0]data_bus_source;
wire [7:0]data_bus_inputs[`DataBusSrc__NumOptions-1:0];

assign data_bus = data_bus_inputs[data_bus_source];
reg [7:0]data_in_latched;

wire [15:0]address_bus;
wire [`AddrBusSrc__NBits-1:0]address_bus_source;
wire [15:0]address_bus_inputs[`AddrBusSrc__NumOptions-1:0];

assign address_bus = address_bus_inputs[address_bus_source];
assign address = address_bus;

wire [7:0]alu_bus;
wire [`AluBusSrc__NBits-1:0]alu_bus_source;
wire [7:0]alu_bus_inputs[`AluBusSrc__NumOptions-1:0];

assign alu_bus = alu_bus_inputs[alu_bus_source];

wire [`CtlSig__NumSignals-1:0] control_signals;

assign sync = control_signals[`CtlSig_sync];
assign waitP = control_signals[`CtlSig_halted];
assign rW = ~control_signals[`CtlSig_write];

assign data_bus_inputs[`DataBusSrc_Mem] = data_in_latched;

register register_y(
    .data_in(data_bus),
    .data_out(data_bus_inputs[`DataBusSrc_RegY]),
    .clock(phi2),
    .write_enable(control_signals[`CtlSig_RegYWrite]),
    .bReset(1)
);

register register_x(
    .data_in(data_bus),
    .data_out(data_bus_inputs[`DataBusSrc_RegX]),
    .clock(phi2),
    .write_enable(control_signals[`CtlSig_RegXWrite]),
    .bReset(1)
);

register register_s(
    .data_in(data_bus),
    .data_out(data_bus_inputs[`DataBusSrc_RegS]),
    .clock(phi2),
    .write_enable(control_signals[`CtlSig_RegSWrite]),
    .bReset(1)
);

register register_accumulator(
    .data_in(data_bus),
    .data_out(data_bus_inputs[`DataBusSrc_RegAcc]),
    .clock(phi2),
    .write_enable(control_signals[`CtlSig_RegAccWrite]),
    .bReset(1)
);

wire [15:0]pc_value;
program_counter pc(
    .addr_in(address_bus),
    .addr_out(pc_value),
    .advance(control_signals[`CtlSig_PcAdvance]),
    .jump(control_signals[`CtlSig_Jump]),
    .clock(phi2),
    .RESET(RES)
);
latch#(.NBits(16)) pc_latch(.in(pc_value), .out(address_bus_inputs[`AddrBusSrc_Pc]), .clock(~phi2));
assign data_bus_inputs[`DataBusSrc_PCL] = address_bus_inputs[`AddrBusSrc_Pc][7:0];
assign data_bus_inputs[`DataBusSrc_PCH] = address_bus_inputs[`AddrBusSrc_Pc][15:8];

wire [`DataLatch__NBits-1:0]data_latch_control;
input_data_latch data_latch(
    .data_in( data_in ),
    .data_out( address_bus_inputs[`AddrBusSrc_Dl] ),
    .clock(~phi2),
    .control( data_latch_control )
);

alu alu(
    .a(alu_bus),
    .b(control_signals[`CtlSig_AluInverse] ? ~data_bus : data_bus),
    .result(data_bus_inputs[`DataBusSrc_ALU]),
    .control()
);

instruction_decode decoder(
    .data_in(data_in),
    .clock(phi2),
    .RESET(RES),
    .control_signals(control_signals),
    .data_latch_control(data_latch_control),
    .data_bus_source(data_bus_source),
    .address_bus_source(address_bus_source)
);

always@(posedge phi2) begin
    data_out <= control_signals[`CtlSig_write] ? data_bus : 8'b0;
end

always@(negedge phi2) begin
    data_in_latched <= data_in;
end

endmodule
