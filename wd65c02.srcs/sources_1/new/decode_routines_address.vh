`define Addr_invalid    0
`define Addr_abs        1
`define Addr_abs_x_ind  2
`define Addr_abs_x      3
`define Addr_abs_y      4
`define Addr_abs_ind    5
`define Addr_acc        6
`define Addr_immediate  7
`define Addr_implied    8
`define Addr_pc_rel     9
`define Addr_stack      10
`define Addr_zp         11
`define Addr_zp_x_ind   12
`define Addr_zp_x       13
`define Addr_zp_y       14
`define Addr_zp_ind     15
`define Addr_zp_ind_y   16

`define Addr__Count     17
`define Addr__NBits     $clog2(`Addr__Count)

`include "decode_routines_opcodes.vh"

task fetch_operand();
begin
    case(active_address_resolution)
    `Addr_abs: do_addr_abs();
    `Addr_abs_x: do_addr_abs_x();
    `Addr_abs_y: do_addr_abs_y();
    //`Addr_immediate: do_addr_imm();
    `Addr_zp: do_addr_zp();
    `Addr_zp_x_ind: do_addr_zp_x_ind();
    `Addr_zp_x: do_addr_zp_x();
    `Addr_zp_y: do_addr_zp_y();
    `Addr_zp_ind: do_addr_zp_ind();
    `Addr_zp_ind_y: do_addr_zp_ind_y();
    default: begin end
    endcase
end
endtask

task setup_addr_abs();
begin
    // Absolute address: a
    active_address_resolution <= `Addr_abs;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_abs();
begin
    if( timing_counter==1 ) begin
        control_signals[`CtlSig_PcAdvance] <= 1;
        address_bus_source <= `AddrBusSrc_Pc;
        data_latch_ctl_high <= `DlhSrc_DataIn;
    end else begin
        address_bus_source <= `AddrBusSrc_Dl;

        handover_instruction(active_op);
    end
end
endtask

task setup_addr_abs_x_ind();
    // Absolute address + X indirect: (a,x)
    // TODO implement
endtask

task setup_addr_abs_x();
begin
    // Absolute + X: a,x
    active_address_resolution <= `Addr_abs_x;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_bus_source <= `DataBusSrc_Mem;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_abs_x();
begin
    if( timing_counter==1 ) begin
        // Load address MSB
        control_signals[`CtlSig_PcAdvance] <= 1;
        address_bus_source <= `AddrBusSrc_Pc;
        data_latch_ctl_high <= `DlhSrc_DataIn;
        
        // Add X to LSB
        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_RegX;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_Zero;
        data_latch_ctl_low <= `DllSrc_AluRes;
    end else if( timing_counter==2 && alu_carry ) begin
        // Adding X transitioned a page
        alu_in_bus_src <= `AluInSrc_DlHigh;
        data_bus_source <= `DataBusSrc_Zero;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_One;
        data_latch_ctl_high <= `DlhSrc_AluRes;
    end else begin
        address_bus_source <= `AddrBusSrc_Dl;

        handover_instruction(active_op);
    end
end
endtask

task setup_addr_abs_y();
begin
    // Absolute + Y: a,y
    active_address_resolution <= `Addr_abs_y;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_bus_source <= `DataBusSrc_Mem;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_abs_y();
begin
    if( timing_counter==1 ) begin
        // Load address MSB
        control_signals[`CtlSig_PcAdvance] <= 1;
        address_bus_source <= `AddrBusSrc_Pc;
        data_latch_ctl_high <= `DlhSrc_DataIn;
        
        // Add X to LSB
        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_RegY;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_Zero;
        data_latch_ctl_low <= `DllSrc_AluRes;
    end else if( timing_counter==2 && alu_carry ) begin
        // Adding X transitioned a page
        alu_in_bus_src <= `AluInSrc_DlHigh;
        data_bus_source <= `DataBusSrc_Zero;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_One;
        data_latch_ctl_high <= `DlhSrc_AluRes;
    end else begin
        address_bus_source <= `AddrBusSrc_Dl;

        handover_instruction(active_op);
    end
end
endtask

task setup_addr_abs_ind();
    // Absolute indirect: (a)
    // TODO implement
endtask

task setup_addr_acc();
    // Accumulator: A
    // TODO implement
endtask

task setup_addr_imm(input [`Op__NBits-1:0]op);
begin
    // Immediate: #
    address_bus_source <= `AddrBusSrc_Pc;
    control_signals[`CtlSig_PcAdvance] <= 1;
    handover_instruction(op);
end
endtask

task setup_addr_i(input [`Op__NBits-1:0]op);
    // Implied: i
    handover_instruction(op);
endtask

task setup_addr_pc_rel();
    // Program counter relative: r
    // TODO implement
endtask

task setup_addr_stack();
    // Stack operation: s
    // TODO implement
    // TODO no standard handling
endtask

task setup_addr_zp();
begin
    // Zero page: zp
    active_address_resolution <= `Addr_zp;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_latch_ctl_high <= `DlhSrc_Zero;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_zp();
begin
    address_bus_source <= `AddrBusSrc_Dl;
    handover_instruction(active_op);
end
endtask

task setup_addr_zp_x_ind();
begin
    // Zero page + X: (zp,x)
    active_address_resolution <= `Addr_zp_x_ind;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_latch_ctl_high <= `DlhSrc_Zero;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_zp_x_ind();
begin
    if( timing_counter==1 ) begin
        // Load address MSB
        address_bus_source <= `AddrBusSrc_Dl;    // XXX 6502 cycle 3 is dummy read from unmodified address. Need to test on 65c02
        
        // Add X to LSB
        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_RegX;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_Zero;
        data_latch_ctl_low <= `DllSrc_AluRes;
    end else if( timing_counter==2 ) begin
        address_bus_source <= `AddrBusSrc_Dl;
        
        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_Zero;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_One;

        data_latch_ctl_low <= `DllSrc_DataIn;
    end else if( timing_counter==3 ) begin
        address_bus_source <= `AddrBusSrc_Alu;

        data_latch_ctl_high <= `DlhSrc_DataIn;
    end else begin
        address_bus_source <= `AddrBusSrc_Dl;
        handover_instruction(active_op);
    end
end
endtask

task setup_addr_zp_x();
begin
    // Zero page + X: zp,x
    active_address_resolution <= `Addr_zp_x;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_latch_ctl_high <= `DlhSrc_Zero;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_zp_x();
begin
    if( timing_counter==1 ) begin
        // Load address MSB
        address_bus_source <= `AddrBusSrc_Dl;    // XXX 6502 cycle 3 is dummy read from unmodified address. Need to test on 65c02
        
        // Add X to LSB
        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_RegX;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_Zero;
        data_latch_ctl_low <= `DllSrc_AluRes;
    end else begin
        address_bus_source <= `AddrBusSrc_Dl;
        handover_instruction(active_op);
    end
end
endtask

task setup_addr_zp_y();
begin
    // Zero page + Y: zp,y
    active_address_resolution <= `Addr_zp_y;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_latch_ctl_high <= `DlhSrc_Zero;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_zp_y();
begin
    if( timing_counter==1 ) begin
        // Load address MSB
        address_bus_source <= `AddrBusSrc_Dl;    // XXX 6502 cycle 3 is dummy read from unmodified address. Need to test on 65c02
        
        // Add X to LSB
        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_RegY;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_Zero;
        data_latch_ctl_low <= `DllSrc_AluRes;
    end else begin
        address_bus_source <= `AddrBusSrc_Dl;
        handover_instruction(active_op);
    end
end
endtask

task setup_addr_zp_ind();
begin
    // Zero page indirect: (zp)
    active_address_resolution <= `Addr_zp_ind;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_latch_ctl_high <= `DlhSrc_Zero;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_zp_ind();
begin
    if( timing_counter==1 ) begin
        // Load address MSB
        address_bus_source <= `AddrBusSrc_Dl;    // XXX 6502 cycle 3 is dummy read from unmodified address. Need to test on 65c02

        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_Zero;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_One;

        data_latch_ctl_low <= `DllSrc_DataIn;
    end else if( timing_counter==2 ) begin
        address_bus_source <= `AddrBusSrc_Alu;

        data_latch_ctl_high <= `DlhSrc_DataIn;
    end else begin
        address_bus_source <= `AddrBusSrc_Dl;
        handover_instruction(active_op);
    end
end
endtask

task setup_addr_zp_ind_y();
begin
    // Zero page indirect + Y: (zp),y
    active_address_resolution <= `Addr_zp_ind_y;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source <= `AddrBusSrc_Pc;
    data_latch_ctl_high <= `DlhSrc_Zero;
    data_latch_ctl_low <= `DllSrc_DataIn;
end
endtask

task do_addr_zp_ind_y();
begin
    if( timing_counter==1 ) begin
        // Load address MSB
        address_bus_source <= `AddrBusSrc_Dl;

        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_Zero;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_One;

        data_latch_ctl_low <= `DllSrc_DataIn;
    end else if( timing_counter==2 ) begin
        address_bus_source <= `AddrBusSrc_Alu;

        alu_in_bus_src <= `AluInSrc_DlLow;
        data_bus_source <= `DataBusSrc_RegY;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_Zero;

        data_latch_ctl_low <= `DllSrc_AluRes;
        data_latch_ctl_high <= `DlhSrc_DataIn;
    end else if( timing_counter==3 && alu_carry ) begin
        if( PageBoundryWrongAccess )
            address_bus_source <= `AddrBusSrc_Dl;
        else
            address_bus_source <= `AddrBusSrc_Pc;

        alu_in_bus_src <= `AluInSrc_DlHigh;
        data_bus_source <= `DataBusSrc_Zero;
        alu_op <= `AluOp_add;
        alu_carry_src <= `AluCarryIn_One;

        data_latch_ctl_high <= `DlhSrc_AluRes;
    end else begin
        address_bus_source <= `AddrBusSrc_Dl;
        handover_instruction(active_op);
    end
end
endtask

task handover_instruction(input [`Op__NBits-1:0]op);
begin
    active_address_resolution <= `Addr_invalid;
    timing_counter <= OpCounterStart;
    
    perform_instruction(op);
end
endtask