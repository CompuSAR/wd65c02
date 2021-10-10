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
    output ML,
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
wire [`AluInSrc__NBits-1:0]alu_bus_source;
wire [7:0]alu_bus_inputs[`AluInSrc__NumOptions-1:0];

assign alu_bus = alu_bus_inputs[alu_bus_source];

wire [7:0]pc_low_in;
wire [7:0]pc_low_in_inputs[`PcLowIn__NumOptions:0];
wire [`PcLowIn__NBits-1:0]pc_low_in_src;
wire [15:8]pc_high_in;
wire [7:0]pc_high_in_inputs[`PcHighIn__NumOptions:0];
wire [`PcHighIn__NBits-1:0]pc_high_in_src;

assign pc_low_in = pc_low_in_inputs[ pc_low_in_src ];
assign pc_high_in = pc_high_in_inputs[ pc_high_in_src ];

wire [`CtlSig__NumSignals-1:0] control_signals;

reg reset_latched;

register register_y(
    .data_in(data_bus),
    .data_out(data_bus_inputs[`DataBusSrc_RegY]),
    .clock(phi2),
    .write_enable(control_signals[`CtlSig_RegYWrite]),
    .bReset(1'b1)
);

register register_x(
    .data_in(data_bus),
    .data_out(data_bus_inputs[`DataBusSrc_RegX]),
    .clock(phi2),
    .write_enable(control_signals[`CtlSig_RegXWrite]),
    .bReset(1'b1)
);

wire [7:0]register_s_value;
register register_s(
    .data_in(data_bus),
    .data_out(register_s_value),
    .clock(phi2),
    .write_enable(control_signals[`CtlSig_RegSWrite]),
    .bReset(1'b1)
);

register register_accumulator(
    .data_in(data_bus),
    .data_out(data_bus_inputs[`DataBusSrc_RegAcc]),
    .clock(phi2),
    .write_enable(control_signals[`CtlSig_RegAccWrite]),
    .bReset(1'b1)
);

wire [15:0]pc_value;
program_counter pc(
    .addr_in( {pc_high_in, pc_low_in} ),
    .addr_out(pc_value),
    .advance(control_signals[`CtlSig_PcAdvance]),
    .jump(control_signals[`CtlSig_Jump]),
    .clock(phi2),
    .RESET(reset_latched)
);

wire [7:0]data_latch_low_inputs[`DllSrc__NumOptions-1:0];
wire [`DllSrc__NBits-1:0]data_latch_low_source;
wire [7:0]data_latch_high_inputs[`DlhSrc__NumOptions-1:0];
wire [`DlhSrc__NBits-1:0]data_latch_high_source;
wire [15:0]data_latch_value;
input_data_latch data_latch(
    .data_in_low( data_latch_low_inputs[data_latch_low_source] ),
    .data_in_low_enable( data_latch_low_source!=`DllSrc_None ),
    .data_in_high( data_latch_high_inputs[data_latch_high_source] ),
    .data_in_high_enable( data_latch_high_source!=`DlhSrc_None ),
    .clock(phi2),
    .data_out( data_latch_value )
);

wire [7:0]status_value;
wire [7:0]status_inputs[`StatusSrc__NumOptions-1:0];
wire [`StatusSrc__NBits-1:0]status_source;
wire [`StatusZeroCtl__NBits-1:0]status_zero_ctl;
status_register status_register(
    .data_in( status_inputs[status_source] ),
    .data_out(status_value),
    .clock(phi2),

    .update_c( control_signals[`CtlSig_StatUpdateC] ),
    .update_z( status_zero_ctl ),
    .update_i( control_signals[`CtlSig_StatUpdateI] ),
    .update_d( control_signals[`CtlSig_StatUpdateD] ),
    .output_b( control_signals[`CtlSig_StatOutputB] ),
    .update_v( control_signals[`CtlSig_StatUpdateV] ),
    .update_n( control_signals[`CtlSig_StatUpdateN] )
);

wire [7:0]alu_result;

wire alu_carry_inputs[`AluCarryIn__NumOptions-1:0];
wire [`AluCarryIn__NBits-1:0]alu_carry_source;
wire [`AluOp__NBits-1:0]alu_control;
wire [7:0]alu_status;
alu alu(
    .a(alu_bus),
    .b(control_signals[`CtlSig_AluInverse] ? ~data_bus : data_bus),
    .result(alu_result),
    .carry_in(alu_carry_inputs[alu_carry_source]),
    .control(alu_control),
    .status_out(alu_status)
);
wire [7:0]alu_latch_value;
latch#(.NBits(8)) alu_latch(.in(alu_result), .out(alu_latch_value), .clock(~phi2));

instruction_decode decoder(
    .data_in(data_in),
    .clock(phi2),
    .RESET(reset_latched),
    .status_register(status_value),
    .alu_carry(alu_status[`Flags_Carry]),
    .control_signals(control_signals),
    .data_latch_ctl_low(data_latch_low_source),
    .data_latch_ctl_high(data_latch_high_source),
    .data_bus_source(data_bus_source),
    .address_bus_source(address_bus_source),
    .alu_in_bus_src(alu_bus_source),
    .alu_op(alu_control),
    .alu_carry_src(alu_carry_source),
    .status_src(status_source),
    .pc_low_src(pc_low_in_src),
    .pc_high_src(pc_high_in_src),
    .status_zero_ctl(status_zero_ctl),
    .ext_ML(ML),
    .ext_rW(rW),
    .ext_sync(sync),
    .ext_VP(VP),
    .ext_waitP(waitP)
);

always_ff@(posedge phi2) begin
    data_out <= data_bus;
end

always_ff@(negedge phi2) begin
    data_in_latched <= data_in;
    reset_latched <= RES;
end

assign data_bus_inputs[`DataBusSrc_Zero] = 8'b0;
assign data_bus_inputs[`DataBusSrc_Ones] = ~8'b0;
assign data_bus_inputs[`DataBusSrc_RegS] = register_s_value;
// Temporarily disable to resolve asynchronous loop in logic
//assign data_bus_inputs[`DataBusSrc_ALU] = alu_result;
assign data_bus_inputs[`DataBusSrc_PCL] = address_bus_inputs[`AddrBusSrc_Pc][7:0];
assign data_bus_inputs[`DataBusSrc_PCH] = address_bus_inputs[`AddrBusSrc_Pc][15:8];
assign data_bus_inputs[`DataBusSrc_Mem] = data_in_latched;
assign data_bus_inputs[`DataBusSrc_Status] = status_value;

assign address_bus_inputs[`AddrBusSrc_Pc] = pc_value;
assign address_bus_inputs[`AddrBusSrc_Dl] = data_latch_value;
assign address_bus_inputs[`AddrBusSrc_Alu] = {8'b0, alu_latch_value};

assign alu_bus_inputs[`AluInSrc_Zero] = 8'b0;
assign alu_bus_inputs[`AluInSrc_Acc] = data_bus_inputs[`DataBusSrc_RegAcc];
assign alu_bus_inputs[`AluInSrc_RegX] = data_bus_inputs[`DataBusSrc_RegX];
assign alu_bus_inputs[`AluInSrc_RegY] = data_bus_inputs[`DataBusSrc_RegY];
assign alu_bus_inputs[`AluInSrc_DlLow] = data_latch_value[7:0];
assign alu_bus_inputs[`AluInSrc_DlHigh] = data_latch_value[15:8];
assign alu_bus_inputs[`AluInSrc_PcLow] = pc_value[7:0];
assign alu_bus_inputs[`AluInSrc_PcHigh] = pc_value[15:8];

assign data_latch_low_inputs[`DllSrc_None] = 8'bX;
assign data_latch_low_inputs[`DllSrc_DataIn] = data_in;
assign data_latch_low_inputs[`DllSrc_AluRes] = alu_result;

assign data_latch_high_inputs[`DlhSrc_None] = 8'bX;
assign data_latch_high_inputs[`DlhSrc_Zero] = 8'd0;
assign data_latch_high_inputs[`DlhSrc_One] = 8'd1;
assign data_latch_high_inputs[`DlhSrc_DataIn] = data_in;
assign data_latch_high_inputs[`DlhSrc_AluRes] = alu_result;

assign status_inputs[`StatusSrc_Data] = data_bus;
assign status_inputs[`StatusSrc_ALU] = alu_status;

assign alu_carry_inputs[`AluCarryIn_Zero] = 1'b0;
assign alu_carry_inputs[`AluCarryIn_One] = 1'b1;

assign pc_low_in_inputs[`PcLowIn_Preserve] = pc_value[7:0];
assign pc_low_in_inputs[`PcLowIn_Dl] = data_latch_value[7:0];
assign pc_low_in_inputs[`PcLowIn_Alu] = alu_result;

assign pc_high_in_inputs[`PcHighIn_Preserve] = pc_value[15:8];
assign pc_high_in_inputs[`PcHighIn_Mem] = data_in;
assign pc_high_in_inputs[`PcHighIn_Alu] = alu_result;

endmodule
