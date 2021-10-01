`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required Youtube channel https://www.youtube.com/channel/UCp5Z7utSI2IHQUsnkPH41bw
// Engineer: Shachar Shemesh
//
// Create Date: 09/15/2021 10:43:31 PM
// Design Name: WD65C02S core almost compatible design
// Module Name: instruction_decode
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

`include "bus_sources.vh"
`include "control_signals.vh"

module instruction_decode#(PageBoundryWrongAccess = 0, UnknownOpcodesNop = 1)
(
        input [7:0]data_in,
        input clock,
        input RESET,
        input [7:0]status_register,
        input alu_carry,
        output reg [`CtlSig__NumSignals-1:0]control_signals,
        output reg [`DlhSrc__NBits-1:0]data_latch_ctl_high,
        output reg [`DllSrc__NBits-1:0]data_latch_ctl_low,
        output reg [`DataBusSrc__NBits-1:0]data_bus_source,
        output reg [`AddrBusSrc__NBits-1:0]address_bus_source,
        output reg [`AluInSrc__NBits-1:0]alu_in_bus_src,
        output reg [`AluOp__NBits-1:0]alu_op,
        output reg [`AluCarryIn__NBits-1:0]alu_carry_src,
        output sync
    );

`include "decode_routines_address.vh"

localparam TimingCounterBits = 4; // 4 bits ought to be enough for anybody...
reg [TimingCounterBits-1:0]timing_counter;
localparam [TimingCounterBits-1:0]OpCounterStart = {1'b1, {TimingCounterBits-1{1'b0}}};

assign sync = timing_counter==0;

// Collectively, these serve as the instruction register
reg [`Addr__NBits-1:0]active_address_resolution;
reg [`Op__NBits-1:0]active_op;

initial begin
    timing_counter = 0;
    control_signals[`CtlSig_halted] = 1;
end

always@(negedge clock) begin
    clear_signals();
    timing_counter <= timing_counter+1;
    if( ! RESET )
        do_reset();
    else begin
        if( timing_counter==0 )
            do_opcode_decode();
        else if( active_address_resolution!=`Addr_invalid )
            fetch_operand();
        else
            perform_instruction(active_op);
    end
end

task do_reset();
begin
    active_address_resolution <= `Addr_invalid;
    active_op <= `Op__invalid;
    next_instruction();
end
endtask

task clear_signals();
begin
    control_signals <= {`CtlSig__NumSignals{1'b0}};
    data_latch_ctl_high <= `DlhSrc_None;
    data_latch_ctl_low <= `DllSrc_None;

    data_bus_source <= {`DataBusSrc__NBits{1'bX}};
    address_bus_source <= `AddrBusSrc_Pc;
    alu_in_bus_src <= {`AluInSrc__NBits{1'bX}};
    alu_op <= {`AluOp__NBits{1'bX}};
    alu_carry_src <= {`AluCarryIn__NBits{1'bX}};
end
endtask

task set_invalid_state();
begin
    control_signals <= {`CtlSig__NumSignals{1'bX}};
    data_latch_ctl_high <= {`DlhSrc__NBits{1'bX}};
    data_latch_ctl_low <= {`DllSrc__NBits{1'bX}};

    data_bus_source <= {`DataBusSrc__NBits{1'bX}};
    address_bus_source <= {`AddrBusSrc__NBits{1'bX}};
    alu_in_bus_src <= {`AluInSrc__NBits{1'bX}};
    alu_op <= {`AluOp__NBits{1'bX}};
    alu_carry_src <= {`AluCarryIn__NBits{1'bX}};
end
endtask

task do_opcode_decode();
begin
    case( data_in )
    /*
    8'h00: begin
        setup_addr_s();
        active_op <= `Op_brk;
    end
    8'h01: begin
        setup_addr_zpxi();
        active_op <= `Op_ora;
    end
    8'h04: begin
        setup_addr_zp();
        active_op <= `Op_tsb;
    end
    8'h05: begin
        setup_addr_zp();
        active_op <= `Op_ora;
    end
    8'h06: begin
        setup_addr_zp();
        active_op <= `Op_asl;
    end
    8'h07: begin
        setup_addr_zp();
        active_op <= `Op_rmb0;
    end
    8'h08: begin
        setup_addr_s();
        active_op <= `Op_php;
    end
    8'h09: begin
        setup_addr_imm();
        active_op <= `Op_ora;
    end
    8'h0a: begin
        setup_addr_acc();
        active_op <= `Op_asl;
    end
    8'h0c: begin
        setup_addr_abs();
        active_op <= `Op_tsb;
    end
    8'h0d: begin
        setup_addr_abs();
        active_op <= `Op_ora;
    end
    8'h0e: begin
        setup_addr_abs();
        active_op <= `Op_asl;
    end
    8'h0f: begin
        setup_addr_r();
        active_op <= `Op_bbr0;
    end
    8'h10: begin
        setup_addr_r();
        active_op <= `Op_bpl;
    end
    8'h11: begin
        setup_addr_zpi_y();
        active_op <= `Op_ora;
    end
    8'h12: begin
        setup_addr_zpi();
        active_op <= `Op_ora;
    end
    8'h14: begin
        setup_addr_zp();
        active_op <= `Op_trb;
    end
    8'h15: begin
        setup_addr_zpx();
        active_op <= `Op_ora;
    end
    8'h16: begin
        setup_addr_zpx();
        active_op <= `Op_asl;
    end
    8'h17: begin
        setup_addr_zp();
        active_op <= `Op_rmb1;
    end
    8'h18: begin
        setup_addr_i();
        do_opcode_clc();
    end
    8'h19: begin
        setup_addr_abs_y();
        active_op <= `Op_ora;
    end
    8'h1a: begin
        setup_addr_acc();
        active_op <= `Op_inc;
    end
    8'h1c: begin
        setup_addr_abs();
        active_op <= `Op_trb;
    end
    8'h1d: begin
        setup_addr_abs_x();
        active_op <= `Op_ora;
    end
    8'h1e: begin
        setup_addr_abs_x();
        active_op <= `Op_asl;
    end
    8'h1f: begin
        setup_addr_r();
        active_op <= `Op_bbr1;
    end
    8'h20: begin
        setup_addr_a();
        active_op <= `Op_jsr;
    end
    8'h21: begin
        setup_addr_zpxi();
        active_op <= `Op_and;
    end
    8'h24: begin
        setup_addr_zp();
        active_op <= `Op_bit;
    end
    8'h25: begin
        setup_addr_zp();
        active_op <= `Op_and;
    end
    8'h26: begin
        setup_addr_zp();
        active_op <= `Op_rol;
    end
    8'h27: begin
        setup_addr_zp();
        active_op <= `Op_rmb2;
    end
    8'h28: begin
        setup_addr_s();
        active_op <= `Op_plp;
    end
    8'h29: begin
        setup_addr_imm();
        active_op <= `Op_and;
    end
    8'h2a: begin
        setup_addr_acc();
        active_op <= `Op_rol;
    end
    8'h2c: begin
        setup_addr_abs();
        active_op <= `Op_bit;
    end
    8'h2d: begin
        setup_addr_abs();
        active_op <= `Op_and;
    end
    8'h2e: begin
        setup_addr_abs();
        active_op <= `Op_rol;
    end
    8'h2f: begin
        setup_addr_r();
        active_op <= `Op_bbr2;
    end
    8'h30: begin
        setup_addr_r();
        active_op <= `Op_bmi;
    end
    8'h31: begin
        setup_addr_zpi_y();
        active_op <= `Op_and;
    end
    8'h32: begin
        setup_addr_zpi();
        active_op <= `Op_and;
    end
    8'h34: begin
        setup_addr_zpx();
        active_op <= `Op_bit;
    end
    8'h35: begin
        setup_addr_zpx();
        active_op <= `Op_ora;
    end
    8'h36: begin
        setup_addr_zpx();
        active_op <= `Op_rol;
    end
    8'h37: begin
        setup_addr_zp();
        active_op <= `Op_rmb3;
    end
    8'h38: begin
        setup_addr_i();
        do_opcode_sec();
    end
    8'h39: begin
        setup_addr_abs_y();
        active_op <= `Op_and;
    end
    8'h3a: begin
        setup_addr_acc();
        active_op <= `Op_dec;
    end
    8'h3c: begin
        setup_addr_abs_x();
        active_op <= `Op_bit;
    end
    8'h3d: begin
        setup_addr_abs_x();
        active_op <= `Op_and;
    end
    8'h3e: begin
        setup_addr_abs_x();
        active_op <= `Op_rol;
    end
    8'h3f: begin
        setup_addr_r();
        active_op <= `Op_bbr3;
    end
    8'h40: begin
        setup_addr_s();
        active_op <= `Op_rti;
    end
    8'h41: begin
        setup_addr_zpxi();
        active_op <= `Op_eor;
    end
    8'h45: begin
        setup_addr_zp();
        active_op <= `Op_eor;
    end
    8'h46: begin
        setup_addr_zp();
        active_op <= `Op_lsr;
    end
    8'h47: begin
        setup_addr_zp();
        active_op <= `Op_rmb4;
    end
    8'h48: begin
        setup_addr_s();
        active_op <= `Op_pha;
    end
    8'h49: begin
        setup_addr_imm();
        active_op <= `Op_eor;
    end
    8'h4a: begin
        setup_addr_acc();
        active_op <= `Op_lsr;
    end
    8'h4c: begin
        setup_addr_abs();
        active_op <= `Op_jmp;
    end
    8'h4d: begin
        setup_addr_abs();
        active_op <= `Op_eor;
    end
    8'h4e: begin
        setup_addr_abs();
        active_op <= `Op_lsr;
    end
    8'h4f: begin
        setup_addr_r();
        active_op <= `Op_bbr4;
    end
    8'h50: begin
        setup_addr_r();
        active_op <= `Op_bvc;
    end
    8'h51: begin
        setup_addr_zpi_y();
        active_op <= `Op_eor;
    end
    8'h52: begin
        setup_addr_zpi();
        active_op <= `Op_eor;
    end
    8'h55: begin
        setup_addr_zpx();
        active_op <= `Op_eor;
    end
    8'h56: begin
        setup_addr_zpx();
        active_op <= `Op_lsr;
    end
    8'h57: begin
        setup_addr_zp();
        active_op <= `Op_rmb5;
    end
    8'h58: begin
        setup_addr_i();
        do_opcode_cli();
    end
    8'h59: begin
        setup_addr_abs_y();
        active_op <= `Op_eor;
    end
    8'h5a: begin
        setup_addr_s();
        active_op <= `Op_phy;
    end
    8'h5d: begin
        setup_addr_abs_x();
        active_op <= `Op_eor;
    end
    8'h5e: begin
        setup_addr_abs_x();
        active_op <= `Op_lsr;
    end
    8'h5f: begin
        setup_addr_r();
        active_op <= `Op_bbr5;
    end
    8'h60: begin
        setup_addr_s();
        active_op <= `Op_rts;
    end
    8'h61: begin
        setup_addr_zpxi();
        active_op <= `Op_adc;
    end
    8'h64: begin
        setup_addr_zp();
        active_op <= `Op_stz;
    end
    8'h65: begin
        setup_addr_zp();
        active_op <= `Op_adc;
    end
    8'h66: begin
        setup_addr_zp();
        active_op <= `Op_ror;
    end
    8'h67: begin
        setup_addr_zp();
        active_op <= `Op_rmb6;
    end
    8'h68: begin
        setup_addr_s();
        active_op <= `Op_pla;
    end
    8'h69: begin
        setup_addr_imm();
        active_op <= `Op_adc;
    end
    8'h6a: begin
        setup_addr_acc();
        active_op <= `Op_ror;
    end
    8'h6c: begin
        setup_addr_ind16();
        active_op <= `Op_jmp;
    end
    8'h6d: begin
        setup_addr_abs();
        active_op <= `Op_adc;
    end
    8'h6e: begin
        setup_addr_abs();
        active_op <= `Op_ror;
    end
    8'h6f: begin
        setup_addr_r();
        active_op <= `Op_bbr6;
    end
    8'h70: begin
        setup_addr_r();
        active_op <= `Op_bvs;
    end
    8'h71: begin
        setup_addr_zpi_y();
        active_op <= `Op_adc;
    end
    8'h72: begin
        setup_addr_zpi();
        active_op <= `Op_adc;
    end
    8'h74: begin
        setup_addr_zpx();
        active_op <= `Op_stz;
    end
    8'h75: begin
        setup_addr_zpx();
        active_op <= `Op_adc;
    end
    8'h76: begin
        setup_addr_zpx();
        active_op <= `Op_ror;
    end
    8'h77: begin
        setup_addr_zp();
        active_op <= `Op_rmb7;
    end
    8'h78: begin
        setup_addr_i();
        do_opcode_sei();
    end
    8'h79: begin
        setup_addr_abs_y();
        active_op <= `Op_adc;
    end
    8'h7a: begin
        setup_addr_s();
        active_op <= `Op_ply;
    end
    8'h7c: begin
        setup_addr_abs_x_i();
        active_op <= `Op_jmp;
    end
    8'h7d: begin
        setup_addr_abs_x();
        active_op <= `Op_adc;
    end
    8'h7e: begin
        setup_addr_abs_x();
        active_op <= `Op_ror;
    end
    8'h7f: begin
        setup_addr_r();
        active_op <= `Op_bbr7;
    end
    8'h80: begin
        setup_addr_r();
        active_op <= `Op_bra;
    end
    8'h81: begin
        setup_addr_zpxi();
        active_op <= `Op_sta;
    end
    8'h84: begin
        setup_addr_zp();
        active_op <= `Op_sty;
    end
    8'h85: begin
        setup_addr_zp();
        active_op <= `Op_sta;
    end
    8'h86: begin
        setup_addr_zp();
        active_op <= `Op_stx;
    end
    8'h87: begin
        setup_addr_zp();
        active_op <= `Op_smb0;
    end
    8'h88: begin
        setup_addr_i();
        do_opcode_dey();
    end
    8'h89: begin
        setup_addr_imm();
        active_op <= `Op_bit;
    end
    8'h8a: begin
        setup_addr_i();
        do_opcode_txa();
    end
    8'h8c: begin
        setup_addr_abs();
        active_op <= `Op_sty;
    end
    */
    8'h8d: begin
        active_op <= `Op_sta;
        setup_addr_abs();
    end
    /*
    8'h8e: begin
        setup_addr_abs();
        active_op <= `Op_stx;
    end
    8'h8f: begin
        setup_addr_r();
        active_op <= `Op_bbs0;
    end
    8'h90: begin
        setup_addr_r();
        active_op <= `Op_bcc;
    end
    8'h91: begin
        setup_addr_zpi_y();
        active_op <= `Op_sta;
    end
    8'h92: begin
        setup_addr_zpi();
        active_op <= `Op_sta;
    end
    8'h94: begin
        setup_addr_zpx();
        active_op <= `Op_sty;
    end
    8'h95: begin
        setup_addr_zpx();
        active_op <= `Op_sta;
    end
    8'h96: begin
        setup_addr_zpy();
        active_op <= `Op_stx;
    end
    8'h97: begin
        setup_addr_zp();
        active_op <= `Op_smb1;
    end
    8'h98: begin
        setup_addr_i();
        do_opcode_tya();
    end
    8'h99: begin
        setup_addr_abs_y();
        active_op <= `Op_sta;
    end
    8'h9a: begin
        setup_addr_i();
        do_opcode_txs();
    end
    8'h9c: begin
        setup_addr_abs();
        active_op <= `Op_stz;
    end
    8'h9d: begin
        setup_addr_abs_x();
        active_op <= `Op_sta;
    end
    8'h9e: begin
        setup_addr_abs_x();
        active_op <= `Op_stz;
    end
    8'h9f: begin
        setup_addr_r();
        active_op <= `Op_bbs1;
    end
    */
    8'ha0: begin
        active_op <= `Op_ldy;
        setup_addr_imm(`Op_ldy);
    end
    8'ha1: begin
        active_op <= `Op_lda;
        setup_addr_zp_x_ind();
    end
    8'ha2: begin
        active_op <= `Op_ldx;
        setup_addr_imm(`Op_ldx);
    end
    /*
    8'ha4: begin
        setup_addr_zp();
        active_op <= `Op_ldy;
    end
    */
    8'ha5: begin
        active_op <= `Op_lda;
        setup_addr_zp();
    end
    /*
    8'ha6: begin
        setup_addr_zp();
        active_op <= `Op_ldx;
    end
    8'ha7: begin
        setup_addr_zp();
        active_op <= `Op_smb2;
    end
    8'ha8: begin
        setup_addr_i();
        do_opcode_tay();
    end
    */
    8'ha9: begin
        active_op <= `Op_lda;
        setup_addr_imm(`Op_lda);
    end
    /*
    8'haa: begin
        setup_addr_i();
        do_opcode_tax();
    end
    8'hac: begin
        active_op <= `Op_ldy;
        setup_addr_abs();
    end
    */
    8'had: begin
        active_op <= `Op_lda;
        setup_addr_abs();
    end
    /*
    8'hae: begin
        setup_addr_abs();
        active_op <= `Op_ldx;
    end
    8'haf: begin
        setup_addr_r();
        active_op <= `Op_bbs2;
    end
    8'hb0: begin
        setup_addr_r();
        active_op <= `Op_bcs;
    end
    */
    8'hb1: begin
        active_op <= `Op_lda;
        setup_addr_zp_ind_y();
    end
    8'hb2: begin
        active_op <= `Op_lda;
        setup_addr_zp_ind();
    end
    /*
    8'hb4: begin
        setup_addr_zpx();
        active_op <= `Op_ldy;
    end
    */
    8'hb5: begin
        active_op <= `Op_lda;
        setup_addr_zp_x();
    end
    8'hb6: begin
        active_op <= `Op_ldx;
        setup_addr_zp_y();
    end
    /*
    8'hb7: begin
        setup_addr_zp();
        active_op <= `Op_smb3;
    end
    8'hb8: begin
        setup_addr_i();
        do_opcode_clv();
    end
    */
    8'hb9: begin
        active_op <= `Op_lda;
        setup_addr_abs_y();
    end
    /*
    8'hba: begin
        setup_addr_i();
        do_opcode_tsx();
    end
    8'hbc: begin
        setup_addr_abs_x();
        active_op <= `Op_ldy;
    end
    */
    8'hbd: begin
        active_op <= `Op_lda;
        setup_addr_abs_x();
    end
    /*
    8'hbe: begin
        setup_addr_abs_x();
        active_op <= `Op_ldx;
    end
    8'hbf: begin
        setup_addr_r();
        active_op <= `Op_bbs3;
    end
    8'hc0: begin
        setup_addr_imm();
        active_op <= `Op_cpy;
    end
    8'hc1: begin
        setup_addr_zpxi();
        active_op <= `Op_cmp;
    end
    8'hc4: begin
        setup_addr_zp();
        active_op <= `Op_cpy;
    end
    8'hc5: begin
        setup_addr_zp();
        active_op <= `Op_cmp;
    end
    8'hc6: begin
        setup_addr_zp();
        active_op <= `Op_dec;
    end
    8'hc7: begin
        setup_addr_zp();
        active_op <= `Op_smb4;
    end
    8'hc8: begin
        setup_addr_i();
        do_opcode_iny();
    end
    8'hc9: begin
        setup_addr_imm();
        active_op <= `Op_cmp;
    end
    8'hca: begin
        setup_addr_i();
        do_opcode_dex();
    end
    8'hcb: begin
        setup_addr_i();
        do_opcode_wai();
    end
    8'hcc: begin
        setup_addr_abs();
        active_op <= `Op_cpy;
    end
    8'hcd: begin
        setup_addr_abs();
        active_op <= `Op_cmp;
    end
    8'hce: begin
        setup_addr_abs();
        active_op <= `Op_dec;
    end
    8'hcf: begin
        setup_addr_r();
        active_op <= `Op_bbs4;
    end
    8'hd0: begin
        setup_addr_r();
        active_op <= `Op_bne;
    end
    8'hd1: begin
        setup_addr_zpi_y();
        active_op <= `Op_cmp;
    end
    8'hd2: begin
        setup_addr_zpi();
        active_op <= `Op_cmp;
    end
    8'hd5: begin
        setup_addr_zpx();
        active_op <= `Op_cmp;
    end
    8'hd6: begin
        setup_addr_zpx();
        active_op <= `Op_dec;
    end
    8'hd7: begin
        setup_addr_zp();
        active_op <= `Op_smb5;
    end
    8'hd8: begin
        setup_addr_i();
        do_opcode_cld();
    end
    8'hd9: begin
        setup_addr_abs_y();
        active_op <= `Op_cmp;
    end
    8'hda: begin
        setup_addr_s();
        active_op <= `Op_phx;
    end
    8'hdb: begin
        setup_addr_i();
        do_opcode_stp();
    end
    8'hdd: begin
        setup_addr_abs_x();
        active_op <= `Op_cmp;
    end
    8'hde: begin
        setup_addr_abs_x();
        active_op <= `Op_dec;
    end
    8'hdf: begin
        setup_addr_r();
        active_op <= `Op_bbs5;
    end
    8'he0: begin
        setup_addr_imm();
        active_op <= `Op_cpx;
    end
    8'he1: begin
        setup_addr_zpxi();
        active_op <= `Op_sbc;
    end
    8'he4: begin
        setup_addr_zp();
        active_op <= `Op_cpx;
    end
    8'he5: begin
        setup_addr_zp();
        active_op <= `Op_sbc;
    end
    8'he6: begin
        setup_addr_zp();
        active_op <= `Op_inc;
    end
    8'he7: begin
        setup_addr_zp();
        active_op <= `Op_smb6;
    end
    8'he8: begin
        setup_addr_i();
        do_opcode_inx();
    end
    8'he9: begin
        setup_addr_imm();
        active_op <= `Op_sbc;
    end
    */
    8'hea: begin
        active_op <= `Op_nop;
        setup_addr_i(`Op_nop);
    end
    /*
    8'hec: begin
        setup_addr_abs();
        active_op <= `Op_cpx;
    end
    8'hed: begin
        setup_addr_abs();
        active_op <= `Op_sbc;
    end
    8'hee: begin
        setup_addr_abs();
        active_op <= `Op_inc;
    end
    8'hef: begin
        setup_addr_r();
        active_op <= `Op_bbs6;
    end
    8'hf0: begin
        setup_addr_r();
        active_op <= `Op_beq;
    end
    8'hf1: begin
        setup_addr_zpi_y();
        active_op <= `Op_sbc;
    end
    8'hf2: begin
        setup_addr_zpi();
        active_op <= `Op_sbc;
    end
    8'hf5: begin
        setup_addr_zpx();
        active_op <= `Op_sbc;
    end
    8'hf6: begin
        setup_addr_zpx();
        active_op <= `Op_inc;
    end
    8'hf7: begin
        setup_addr_zp();
        active_op <= `Op_smb7;
    end
    8'hf8: begin
        setup_addr_i();
        do_opcode_sed();
    end
    8'hf9: begin
        setup_addr_abs_y();
        active_op <= `Op_sbc;
    end
    8'hfa: begin
        setup_addr_s();
        active_op <= `Op_plx;
    end
    8'hfd: begin
        setup_addr_abs_x();
        active_op <= `Op_sbc;
    end
    8'hfe: begin
        setup_addr_abs_x();
        active_op <= `Op_inc;
    end
    8'hff: begin
        setup_addr_r();
        active_op <= `Op_bbs7;
    end
    */
    default: begin
        setup_unknown_command();
    end
    endcase
end
endtask

task setup_unknown_command();
begin
    if( UnknownOpcodesNop ) begin
        active_op <= `Op_nop; // Unknown commands are NOP
        setup_addr_i(`Op_nop);
    end else
        set_invalid_state();
end
endtask

endmodule
