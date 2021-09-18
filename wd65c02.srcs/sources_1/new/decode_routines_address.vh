`define Addr_implied 0

`define Addr__Count 1
`define Addr__NBits $clog2(`Addr__Count)

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
    // Immediate: #
    // TODO implement
endtask

task setup_addr_i();
    // Implied: i
    // TODO implement
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
