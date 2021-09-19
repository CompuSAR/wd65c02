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

task fetch_operand();
begin
    case(active_address_resolution)
    default: begin end
    endcase
end
endtask

task setup_addr_abs();
    // Absolute address: a
    // TODO implement
endtask

task setup_addr_abs_x_ind();
    // Absolute address + X indirect: (a,x)
    // TODO implement
endtask

task setup_addr_abs_x();
    // Absolute + X: a,x
    // TODO implement
endtask

task setup_addr_abs_y();
    // Absolute + Y: a,y
    // TODO implement
endtask

task setup_addr_abs_ind();
    // Absolute indirect: (a)
    // TODO implement
endtask

task setup_addr_acc();
    // Accumulator: A
    // TODO implement
endtask

task setup_addr_imm();
begin
    // Immediate: #
    active_address_resolution <= `Addr_invalid;
    control_signals[`CtlSig_PcAdvance] <= 1;
    address_bus_source = `AddrBusSrc_Pc;
end
endtask

task setup_addr_i();
    // Implied: i
    active_address_resolution <= `Addr_invalid;
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
    // Zero page: zp
    // TODO implement
endtask

task setup_addr_zp_x_ind();
    // Zero page + X: (zp,x)
    // TODO implement
endtask

task setup_addr_zp_x();
    // Zero page + X: zp,x
    // TODO implement
endtask

task setup_addr_zp_y();
    // Zero page + Y: zp,y
    // TODO implement
endtask

task setup_addr_zp_ind();
    // Zero page indirect: (zp)
    // TODO implement
endtask

task setup_addr_zp_ind_y();
    // Zero page indirect + Y: (zp),y
    // TODO implement
endtask
