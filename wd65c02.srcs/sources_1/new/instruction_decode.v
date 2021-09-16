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

module instruction_decode(
        input [7:0]data_in,
        input clock,
        input RESET,
        output reg [`CtlSig__NumSignals-1:0]control_signals,
        output reg [`DataBusSrc__NBits-1:0]data_bus_source,
        output reg [`AddrBusSrc__NBits-1:0]address_bus_source
    );

reg [3:0]timing_counter; // 4 bits ought to be enough for anybody

wire [7:0]instruction_register_value;
register instruction_register(
    .data_in(data_in),
    .data_out(instruction_register_value),
    .clock(clock),
    .write_enable( control_signals[`CtlSig_IrIn] ),
    .bReset(1'b1)
);

initial begin
    clear_signals();
    control_signals[`CtlSig_halted] <= 1;
end

always@(negedge clock) begin
    clear_signals();
    if( ! RESET )
        do_reset();
    else begin
        if( timing_counter==0 ) begin
            do_opcode_fetch();
        end else if( timing_counter==1 ) begin
            do_opcode_decode();
        end
    end
end

task do_reset();
begin
    timing_counter <= 0;
    clear_signals();
end
endtask

task clear_signals();
begin
    control_signals <= {`CtlSig__NumSignals{1'b0}};
    data_bus_source <= {`DataBusSrc__NumOptions{1'b0}};
    address_bus_source <= {`AddrBusSrc__NumOptions{1'b0}};
end
endtask

task do_opcode_fetch();
begin
    address_bus_source <= `AddrBusSrc_Pc;
    control_signals[`CtlSig_sync] <= 1;
end
endtask

task do_opcode_decode();
begin
    data_bus_source <= `DataBusSrc_Mem;
    control_signals[`CtlSig_IrIn] <= 1;
    
    control_signals[`CtlSig_PcAdvance] <= 1;
    
    case( data_in )
    8'h00: begin
        setup_addr_s();
        setup_opcode_brk();
    end
    8'h01: begin
        setup_addr_zpxi();
        setup_opcode_ora();
    end
    8'h04: begin
        setup_addr_zp();
        setup_opcode_tsb();
    end
    8'h05: begin
        setup_addr_zp();
        setup_opcode_ora();
    end
    8'h06: begin
        setup_addr_zp();
        setup_opcode_asl();
    end
    8'h07: begin
        setup_addr_zp();
        setup_opcode_rmb0();
    end
    8'h08: begin
        setup_addr_s();
        setup_opcode_php();
    end
    8'h09: begin
        setup_addr_imm();
        setup_opcode_ora();
    end
    8'h0a: begin
        setup_addr_acc();
        setup_opcode_asl();
    end
    8'h0c: begin
        setup_addr_abs();
        setup_opcode_tsb();
    end
    8'h0d: begin
        setup_addr_abs();
        setup_opcode_ora();
    end
    8'h0e: begin
        setup_addr_abs();
        setup_opcode_asl();
    end
    8'h0f: begin
        setup_addr_r();
        setup_opcode_bbr0();
    end
    8'h10: begin
        setup_addr_r();
        setup_opcode_bpl();
    end
    8'h11: begin
        setup_addr_zpi_y();
        setup_opcode_ora();
    end
    8'h12: begin
        setup_addr_zpi();
        setup_opcode_ora();
    end
    8'h14: begin
        setup_addr_zp();
        setup_opcode_trb();
    end
    8'h15: begin
        setup_addr_zpx();
        setup_opcode_ora();
    end
    8'h16: begin
        setup_addr_zpx();
        setup_opcode_asl();
    end
    8'h17: begin
        setup_addr_zp();
        setup_opcode_rmb1();
    end
    8'h18: begin
        setup_addr_i();
        setup_opcode_clc();
    end
    8'h19: begin
        setup_addr_abs_y();
        setup_opcode_ora();
    end
    8'h1a: begin
        setup_addr_acc();
        setup_opcode_inc();
    end
    8'h1c: begin
        setup_addr_abs();
        setup_opcode_trb();
    end
    8'h1d: begin
        setup_addr_abs_x();
        setup_opcode_ora();
    end
    8'h1e: begin
        setup_addr_abs_x();
        setup_opcode_asl();
    end
    8'h1f: begin
        setup_addr_r();
        setup_opcode_bbr1();
    end
    8'h20: begin
        setup_addr_a();
        setup_opcode_jsr();
    end
    8'h21: begin
        setup_addr_zpxi();
        setup_opcode_and();
    end
    8'h24: begin
        setup_addr_zp();
        setup_opcode_bit();
    end
    8'h25: begin
        setup_addr_zp();
        setup_opcode_and();
    end
    8'h26: begin
        setup_addr_zp();
        setup_opcode_rol();
    end
    8'h27: begin
        setup_addr_zp();
        setup_opcode_rmb2();
    end
    8'h28: begin
        setup_addr_s();
        setup_opcode_plp();
    end
    8'h29: begin
        setup_addr_imm();
        setup_opcode_and();
    end
    8'h2a: begin
        setup_addr_acc();
        setup_opcode_rol();
    end
    8'h2c: begin
        setup_addr_abs();
        setup_opcode_bit();
    end
    8'h2d: begin
        setup_addr_abs();
        setup_opcode_and();
    end
    8'h2e: begin
        setup_addr_abs();
        setup_opcode_rol();
    end
    8'h2f: begin
        setup_addr_r();
        setup_opcode_bbr2();
    end
    8'h30: begin
        setup_addr_r();
        setup_opcode_bmi();
    end
    8'h31: begin
        setup_addr_zpi_y();
        setup_opcode_and();
    end
    8'h32: begin
        setup_addr_zpi();
        setup_opcode_and();
    end
    8'h34: begin
        setup_addr_zpx();
        setup_opcode_bit();
    end
    8'h35: begin
        setup_addr_zpx();
        setup_opcode_ora();
    end
    8'h36: begin
        setup_addr_zpx();
        setup_opcode_rol();
    end
    8'h37: begin
        setup_addr_zp();
        setup_opcode_rmb3();
    end
    8'h38: begin
        setup_addr_i();
        setup_opcode_sec();
    end
    8'h39: begin
        setup_addr_abs_y();
        setup_opcode_and();
    end
    8'h3a: begin
        setup_addr_acc();
        setup_opcode_dec();
    end
    8'h3c: begin
        setup_addr_abs_x();
        setup_opcode_bit();
    end
    8'h3d: begin
        setup_addr_abs_x();
        setup_opcode_and();
    end
    8'h3e: begin
        setup_addr_abs_x();
        setup_opcode_rol();
    end
    8'h3f: begin
        setup_addr_r();
        setup_opcode_bbr3();
    end
    8'h40: begin
        setup_addr_s();
        setup_opcode_rti();
    end
    8'h41: begin
        setup_addr_zpxi();
        setup_opcode_eor();
    end
    8'h45: begin
        setup_addr_zp();
        setup_opcode_eor();
    end
    8'h46: begin
        setup_addr_zp();
        setup_opcode_lsr();
    end
    8'h47: begin
        setup_addr_zp();
        setup_opcode_rmb4();
    end
    8'h48: begin
        setup_addr_s();
        setup_opcode_pha();
    end
    8'h49: begin
        setup_addr_imm();
        setup_opcode_eor();
    end
    8'h4a: begin
        setup_addr_acc();
        setup_opcode_lsr();
    end
    8'h4c: begin
        setup_addr_abs();
        setup_opcode_jmp();
    end
    8'h4d: begin
        setup_addr_abs();
        setup_opcode_eor();
    end
    8'h4e: begin
        setup_addr_abs();
        setup_opcode_lsr();
    end
    8'h4f: begin
        setup_addr_r();
        setup_opcode_bbr4();
    end
    8'h50: begin
        setup_addr_r();
        setup_opcode_bvc();
    end
    8'h51: begin
        setup_addr_zpi_y();
        setup_opcode_eor();
    end
    8'h52: begin
        setup_addr_zpi();
        setup_opcode_eor();
    end
    8'h55: begin
        setup_addr_zpx();
        setup_opcode_eor();
    end
    8'h56: begin
        setup_addr_zpx();
        setup_opcode_lsr();
    end
    8'h57: begin
        setup_addr_zp();
        setup_opcode_rmb5();
    end
    8'h58: begin
        setup_addr_i();
        setup_opcode_cli();
    end
    8'h59: begin
        setup_addr_abs_y();
        setup_opcode_eor();
    end
    8'h5a: begin
        setup_addr_s();
        setup_opcode_phy();
    end
    8'h5d: begin
        setup_addr_abs_x();
        setup_opcode_eor();
    end
    8'h5e: begin
        setup_addr_abs_x();
        setup_opcode_lsr();
    end
    8'h5f: begin
        setup_addr_r();
        setup_opcode_bbr5();
    end
    8'h60: begin
        setup_addr_s();
        setup_opcode_rts();
    end
    8'h61: begin
        setup_addr_zpxi();
        setup_opcode_adc();
    end
    8'h64: begin
        setup_addr_zp();
        setup_opcode_stz();
    end
    8'h65: begin
        setup_addr_zp();
        setup_opcode_adc();
    end
    8'h66: begin
        setup_addr_zp();
        setup_opcode_ror();
    end
    8'h67: begin
        setup_addr_zp();
        setup_opcode_rmb6();
    end
    8'h68: begin
        setup_addr_s();
        setup_opcode_pla();
    end
    8'h69: begin
        setup_addr_imm();
        setup_opcode_adc();
    end
    8'h6a: begin
        setup_addr_acc();
        setup_opcode_ror();
    end
    8'h6c: begin
        setup_addr_ind16();
        setup_opcode_jmp();
    end
    8'h6d: begin
        setup_addr_abs();
        setup_opcode_adc();
    end
    8'h6e: begin
        setup_addr_abs();
        setup_opcode_ror();
    end
    8'h6f: begin
        setup_addr_r();
        setup_opcode_bbr6();
    end
    8'h70: begin
        setup_addr_r();
        setup_opcode_bvs();
    end
    8'h71: begin
        setup_addr_zpi_y();
        setup_opcode_adc();
    end
    8'h72: begin
        setup_addr_zpi();
        setup_opcode_adc();
    end
    8'h74: begin
        setup_addr_zpx();
        setup_opcode_stz();
    end
    8'h75: begin
        setup_addr_zpx();
        setup_opcode_adc();
    end
    8'h76: begin
        setup_addr_zpx();
        setup_opcode_ror();
    end
    8'h77: begin
        setup_addr_zp();
        setup_opcode_rmb7();
    end
    8'h78: begin
        setup_addr_i();
        setup_opcode_sei();
    end
    8'h79: begin
        setup_addr_abs_y();
        setup_opcode_adc();
    end
    8'h7a: begin
        setup_addr_s();
        setup_opcode_ply();
    end
    8'h7c: begin
        setup_addr_abs_x_i();
        setup_opcode_jmp();
    end
    8'h7d: begin
        setup_addr_abs_x();
        setup_opcode_adc();
    end
    8'h7e: begin
        setup_addr_abs_x();
        setup_opcode_ror();
    end
    8'h7f: begin
        setup_addr_r();
        setup_opcode_bbr7();
    end
    8'h80: begin
        setup_addr_r();
        setup_opcode_bra();
    end
    8'h81: begin
        setup_addr_zpxi();
        setup_opcode_sta();
    end
    8'h84: begin
        setup_addr_zp();
        setup_opcode_sty();
    end
    8'h85: begin
        setup_addr_zp();
        setup_opcode_sta();
    end
    8'h86: begin
        setup_addr_zp();
        setup_opcode_stx();
    end
    8'h87: begin
        setup_addr_zp();
        setup_opcode_smb0();
    end
    8'h88: begin
        setup_addr_i();
        setup_opcode_dey();
    end
    8'h89: begin
        setup_addr_imm();
        setup_opcode_bit();
    end
    8'h8a: begin
        setup_addr_i();
        setup_opcode_txa();
    end
    8'h8c: begin
        setup_addr_abs();
        setup_opcode_sty();
    end
    8'h8d: begin
        setup_addr_abs();
        setup_opcode_sta();
    end
    8'h8e: begin
        setup_addr_abs();
        setup_opcode_stx();
    end
    8'h8f: begin
        setup_addr_r();
        setup_opcode_bbs0();
    end
    8'h90: begin
        setup_addr_r();
        setup_opcode_bcc();
    end
    8'h91: begin
        setup_addr_zpi_y();
        setup_opcode_sta();
    end
    8'h92: begin
        setup_addr_zpi();
        setup_opcode_sta();
    end
    8'h94: begin
        setup_addr_zpx();
        setup_opcode_sty();
    end
    8'h95: begin
        setup_addr_zpx();
        setup_opcode_sta();
    end
    8'h96: begin
        setup_addr_zpy();
        setup_opcode_stx();
    end
    8'h97: begin
        setup_addr_zp();
        setup_opcode_smb1();
    end
    8'h98: begin
        setup_addr_i();
        setup_opcode_tya();
    end
    8'h99: begin
        setup_addr_abs_y();
        setup_opcode_sta();
    end
    8'h9a: begin
        setup_addr_i();
        setup_opcode_txs();
    end
    8'h9c: begin
        setup_addr_abs();
        setup_opcode_stz();
    end
    8'h9d: begin
        setup_addr_abs_x();
        setup_opcode_sta();
    end
    8'h9e: begin
        setup_addr_abs_x();
        setup_opcode_stz();
    end
    8'h9f: begin
        setup_addr_r();
        setup_opcode_bbs1();
    end
    8'ha0: begin
        setup_addr_imm();
        setup_opcode_ldy();
    end
    8'ha1: begin
        setup_addr_zpxi();
        setup_opcode_lda();
    end
    8'ha2: begin
        setup_addr_imm();
        setup_opcode_ldx();
    end
    8'ha4: begin
        setup_addr_zp();
        setup_opcode_ldy();
    end
    8'ha5: begin
        setup_addr_zp();
        setup_opcode_lda();
    end
    8'ha6: begin
        setup_addr_zp();
        setup_opcode_ldx();
    end
    8'ha7: begin
        setup_addr_zp();
        setup_opcode_smb2();
    end
    8'ha8: begin
        setup_addr_i();
        setup_opcode_tay();
    end
    8'ha9: begin
        setup_addr_imm();
        setup_opcode_lda();
    end
    8'haa: begin
        setup_addr_i();
        setup_opcode_tax();
    end
    8'hac: begin
        setup_addr_abs();
        setup_opcode_ldy();
    end
    8'had: begin
        setup_addr_abs();
        setup_opcode_lda();
    end
    8'hae: begin
        setup_addr_abs();
        setup_opcode_ldx();
    end
    8'haf: begin
        setup_addr_r();
        setup_opcode_bbs2();
    end
    8'hb0: begin
        setup_addr_r();
        setup_opcode_bcs();
    end
    8'hb1: begin
        setup_addr_zpi_y();
        setup_opcode_lda();
    end
    8'hb2: begin
        setup_addr_zpi();
        setup_opcode_lda();
    end
    8'hb4: begin
        setup_addr_zpx();
        setup_opcode_ldy();
    end
    8'hb5: begin
        setup_addr_zpx();
        setup_opcode_lda();
    end
    8'hb6: begin
        setup_addr_zpy();
        setup_opcode_ldx();
    end
    8'hb7: begin
        setup_addr_zp();
        setup_opcode_smb3();
    end
    8'hb8: begin
        setup_addr_i();
        setup_opcode_clv();
    end
    8'hb9: begin
        setup_addr_abs_y();
        setup_opcode_lda();
    end
    8'hba: begin
        setup_addr_i();
        setup_opcode_tsx();
    end
    8'hbc: begin
        setup_addr_abs_x();
        setup_opcode_ldy();
    end
    8'hbd: begin
        setup_addr_abs_x();
        setup_opcode_lda();
    end
    8'hbe: begin
        setup_addr_abs_x();
        setup_opcode_ldx();
    end
    8'hbf: begin
        setup_addr_r();
        setup_opcode_bbs3();
    end
    8'hc0: begin
        setup_addr_imm();
        setup_opcode_cpy();
    end
    8'hc1: begin
        setup_addr_zpxi();
        setup_opcode_cmp();
    end
    8'hc4: begin
        setup_addr_zp();
        setup_opcode_cpy();
    end
    8'hc5: begin
        setup_addr_zp();
        setup_opcode_cmp();
    end
    8'hc6: begin
        setup_addr_zp();
        setup_opcode_dec();
    end
    8'hc7: begin
        setup_addr_zp();
        setup_opcode_smb4();
    end
    8'hc8: begin
        setup_addr_i();
        setup_opcode_iny();
    end
    8'hc9: begin
        setup_addr_imm();
        setup_opcode_cmp();
    end
    8'hca: begin
        setup_addr_i();
        setup_opcode_dex();
    end
    8'hcb: begin
        setup_addr_i();
        setup_opcode_wai();
    end
    8'hcc: begin
        setup_addr_abs();
        setup_opcode_cpy();
    end
    8'hcd: begin
        setup_addr_abs();
        setup_opcode_cmp();
    end
    8'hce: begin
        setup_addr_abs();
        setup_opcode_dec();
    end
    8'hcf: begin
        setup_addr_r();
        setup_opcode_bbs4();
    end
    8'hd0: begin
        setup_addr_r();
        setup_opcode_bne();
    end
    8'hd1: begin
        setup_addr_zpi_y();
        setup_opcode_cmp();
    end
    8'hd2: begin
        setup_addr_zpi();
        setup_opcode_cmp();
    end
    8'hd5: begin
        setup_addr_zpx();
        setup_opcode_cmp();
    end
    8'hd6: begin
        setup_addr_zpx();
        setup_opcode_dec();
    end
    8'hd7: begin
        setup_addr_zp();
        setup_opcode_smb5();
    end
    8'hd8: begin
        setup_addr_i();
        setup_opcode_cld();
    end
    8'hd9: begin
        setup_addr_abs_y();
        setup_opcode_cmp();
    end
    8'hda: begin
        setup_addr_s();
        setup_opcode_phx();
    end
    8'hdb: begin
        setup_addr_i();
        setup_opcode_stp();
    end
    8'hdd: begin
        setup_addr_abs_x();
        setup_opcode_cmp();
    end
    8'hde: begin
        setup_addr_abs_x();
        setup_opcode_dec();
    end
    8'hdf: begin
        setup_addr_r();
        setup_opcode_bbs5();
    end
    8'he0: begin
        setup_addr_imm();
        setup_opcode_cpx();
    end
    8'he1: begin
        setup_addr_zpxi();
        setup_opcode_sbc();
    end
    8'he4: begin
        setup_addr_zp();
        setup_opcode_cpx();
    end
    8'he5: begin
        setup_addr_zp();
        setup_opcode_sbc();
    end
    8'he6: begin
        setup_addr_zp();
        setup_opcode_inc();
    end
    8'he7: begin
        setup_addr_zp();
        setup_opcode_smb6();
    end
    8'he8: begin
        setup_addr_i();
        setup_opcode_inx();
    end
    8'he9: begin
        setup_addr_imm();
        setup_opcode_sbc();
    end
    8'hea: begin
        setup_addr_i();
        setup_opcode_nop();
    end
    8'hec: begin
        setup_addr_abs();
        setup_opcode_cpx();
    end
    8'hed: begin
        setup_addr_abs();
        setup_opcode_sbc();
    end
    8'hee: begin
        setup_addr_abs();
        setup_opcode_inc();
    end
    8'hef: begin
        setup_addr_r();
        setup_opcode_bbs6();
    end
    8'hf0: begin
        setup_addr_r();
        setup_opcode_beq();
    end
    8'hf1: begin
        setup_addr_zpi_y();
        setup_opcode_sbc();
    end
    8'hf2: begin
        setup_addr_zpi();
        setup_opcode_sbc();
    end
    8'hf5: begin
        setup_addr_zpx();
        setup_opcode_sbc();
    end
    8'hf6: begin
        setup_addr_zpx();
        setup_opcode_inc();
    end
    8'hf7: begin
        setup_addr_zp();
        setup_opcode_smb7();
    end
    8'hf8: begin
        setup_addr_i();
        setup_opcode_sed();
    end
    8'hf9: begin
        setup_addr_abs_y();
        setup_opcode_sbc();
    end
    8'hfa: begin
        setup_addr_s();
        setup_opcode_plx();
    end
    8'hfd: begin
        setup_addr_abs_x();
        setup_opcode_sbc();
    end
    8'hfe: begin
        setup_addr_abs_x();
        setup_opcode_inc();
    end
    8'hff: begin
        setup_addr_r();
        setup_opcode_bbs7();
    end
    default: begin
        setup_addr_i();
        setup_opcode_nop(); // Unknown commands are NOP
    end
    endcase
end
endtask

endmodule
