//   Copyright (C) 2021.
//   Copyright owners listed in AUTHORS file.
//
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation; either version 2 of the License, or
//   (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with this program; if not, write to the Free Software
//   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

// Enumerate the base operations
`define Op__invalid  0
`define Op_adc  1
`define Op_and  2
`define Op_asl  3
`define Op_bbr0 4
`define Op_bbr1 5
`define Op_bbr2 6
`define Op_bbr3 7
`define Op_bbr4 8
`define Op_bbr5 9
`define Op_bbr6 10
`define Op_bbr7 11
`define Op_bbs0 12
`define Op_bbs1 13
`define Op_bbs2 14
`define Op_bbs3 15
`define Op_bbs4 16
`define Op_bbs5 17
`define Op_bbs6 18
`define Op_bbs7 19
`define Op_bcc  20
`define Op_bcs  21
`define Op_beq  22
`define Op_bit  23
`define Op_bmi  24
`define Op_bne  25
`define Op_bpl  26
`define Op_bra  27
`define Op_bvc  29
`define Op_bvs  30
`define Op_clc  31
`define Op_cld  32
`define Op_cli  33
`define Op_clv  34
`define Op_cmp  35
`define Op_cpx  36
`define Op_cpy  37
`define Op_dec  38
`define Op_dex  39
`define Op_dey  40
`define Op_eor  41
`define Op_inc  42
`define Op_inx  43
`define Op_iny  44
`define Op_jmp  45
`define Op_jsr  46
`define Op_lda  47
`define Op_ldx  48
`define Op_ldy  49
`define Op_lsr  50
`define Op_nop  51
`define Op_ora  52
`define Op_pha  53
`define Op_php  54
`define Op_phx  55
`define Op_phy  56
`define Op_pla  57
`define Op_plp  58
`define Op_plx  59
`define Op_ply  60
`define Op_rmb0 61
`define Op_rmb1 62
`define Op_rmb2 63
`define Op_rmb3 64
`define Op_rmb4 65
`define Op_rmb5 66
`define Op_rmb6 67
`define Op_rmb7 68
`define Op_rol  69
`define Op_ror  70
`define Op_rti  71
`define Op_rts  72
`define Op_sbc  73
`define Op_sec  74
`define Op_sed  75
`define Op_sei  76
`define Op_smb0 77
`define Op_smb1 78
`define Op_smb2 79
`define Op_smb3 80
`define Op_smb4 81
`define Op_smb5 82
`define Op_smb6 83
`define Op_smb7 84
`define Op_sta  85
`define Op_stp  86
`define Op_stx  89
`define Op_sty  88
`define Op_stz  89
`define Op_tax  90
`define Op_tay  91
`define Op_trb  92
`define Op_tsb  93
`define Op_tsx  94
`define Op_txa  95
`define Op_txs  96
`define Op_tya  97
`define Op_wai  98

`define Op_interrupt 99

`define Op__Count 100
`define Op__NBits $clog2(`Op__Count)

task perform_instruction(input [`Op__NBits-1:0]op);
begin
    case(op)
        `Op_asl: do_opcode_asl();
        `Op_clc: do_opcode_clc();
        `Op_jmp: do_opcode_jmp();
        `Op_lda: do_opcode_lda();
        `Op_ldx: do_opcode_ldx();
        `Op_ldy: do_opcode_ldy();
        `Op_lsr: do_opcode_lsr();
        `Op_nop: do_opcode_nop();
        `Op_sec: do_opcode_sec();
        `Op_sta: do_opcode_sta();
        `Op_stx: do_opcode_stx();
        `Op_tsx: do_opcode_tsx();
        `Op_txs: do_opcode_txs();

        `Op_interrupt: do_opcode_interrupt();
        default: set_invalid_state();
    endcase
end
endtask

task next_instruction();
begin
    timing_counter <= 0;

    control_signals[`CtlSig_PcAdvance] <= 1;
    control_signals[`CtlSig_Jump] <= 0;

    ext_sync <= 1;
    ext_rW <= 1;

    addr_pc <= 0;
end
endtask

task perform_branch_opcode();
begin
    case(active_op)
        `Op_bcc: do_opcode_bcc();
        `Op_bcs: do_opcode_bcs();
        `Op_beq: do_opcode_beq();
        `Op_bmi: do_opcode_bmi();
        `Op_bne: do_opcode_bne();
        `Op_bpl: do_opcode_bpl();
        default: set_invalid_state();
    endcase
end
endtask

task do_opcode_bcc();
begin
    if( status_register[`Flags_Carry] )
        next_instruction();
end
endtask

task do_opcode_bcs();
begin
    if( ! status_register[`Flags_Carry] )
        next_instruction();
end
endtask

task do_opcode_beq();
    if( ! status_register[`Flags_Zero] )
        next_instruction();
endtask

task do_opcode_bmi();
    if( ! status_register[`Flags_Neg] )
        next_instruction();
endtask

task do_opcode_bne();
    if( status_register[`Flags_Zero] )
        next_instruction();
endtask

task do_opcode_bpl();
    if( status_register[`Flags_Neg] )
        next_instruction();
endtask


task do_opcode_asl();
    if( timing_counter<OpCounterStart ) begin
        ext_ML <= 0;
    end else if( timing_counter==OpCounterStart ) begin
        address_bus_source <= `AddrBusSrc_Dl;
        data_bus_source <= `DataBusSrc_Mem;
        alu_b_src <= `AluBSrc_DataBus;
        alu_carry_src <= `AluCarryIn_Zero;
        alu_op <= `AluOp_shift_left;
        ext_ML <= 0;

        status_src <= `StatusSrc_ALU;
        control_signals[`CtlSig_StatUpdateC] <= 1;
    end else if( timing_counter==OpCounterStart+1 ) begin
        address_bus_source <= `AddrBusSrc_Dl;
        data_bus_source <= `DataBusSrc_ALU;
        ext_ML <= 0;
        ext_rW <= 0;

        status_src <= `StatusSrc_Data;
        status_zero_ctl <= `StatusZeroCtl_Calculate;
        control_signals[`CtlSig_StatUpdateN] <= 1;
    end else begin
        next_instruction();
    end
endtask

task do_opcode_clc();
begin
    if( timing_counter == OpCounterStart ) begin
        data_bus_source <= `DataBusSrc_Zero;
        control_signals[`CtlSig_StatUpdateC] <= 1;
        status_src <= `StatusSrc_Data;

        next_instruction();
    end
end
endtask

task do_opcode_jmp();
begin
    next_instruction();
end
endtask

task do_opcode_lda();
begin
    if( timing_counter < OpCounterStart ) begin
    end else begin
        data_bus_source <= `DataBusSrc_Mem;
        control_signals[`CtlSig_RegAccWrite] <= 1;

        status_src <= `StatusSrc_Data;
        control_signals[`CtlSig_StatUpdateN] <= 1;
        status_zero_ctl <= `StatusZeroCtl_Calculate;

        next_instruction();
    end
end
endtask

task do_opcode_ldx();
begin
    if( timing_counter < OpCounterStart ) begin
    end else begin
        data_bus_source <= `DataBusSrc_Mem;
        control_signals[`CtlSig_RegXWrite] <= 1;

        status_src <= `StatusSrc_Data;
        control_signals[`CtlSig_StatUpdateN] <= 1;
        status_zero_ctl <= `StatusZeroCtl_Calculate;

        next_instruction();
    end
end
endtask

task do_opcode_ldy();
begin
    if( timing_counter < OpCounterStart ) begin
    end else begin
        data_bus_source <= `DataBusSrc_Mem;
        control_signals[`CtlSig_RegYWrite] <= 1;

        status_src <= `StatusSrc_Data;
        control_signals[`CtlSig_StatUpdateN] <= 1;
        status_zero_ctl <= `StatusZeroCtl_Calculate;

        next_instruction();
    end
end
endtask

task do_opcode_lsr();
    if( timing_counter<OpCounterStart ) begin
        ext_ML <= 0;
    end else if( timing_counter==OpCounterStart ) begin
        address_bus_source <= `AddrBusSrc_Dl;
        data_bus_source <= `DataBusSrc_Mem;
        alu_b_src <= `AluBSrc_DataBus;
        alu_carry_src <= `AluCarryIn_Zero;
        alu_op <= `AluOp_shift_right;
        ext_ML <= 0;

        status_src <= `StatusSrc_ALU;
        control_signals[`CtlSig_StatUpdateC] <= 1;
    end else if( timing_counter==OpCounterStart+1 ) begin
        address_bus_source <= `AddrBusSrc_Dl;
        data_bus_source <= `DataBusSrc_ALU;
        ext_ML <= 0;
        ext_rW <= 0;

        status_src <= `StatusSrc_Data;
        status_zero_ctl <= `StatusZeroCtl_Calculate;
        control_signals[`CtlSig_StatUpdateN] <= 1;
    end else begin
        next_instruction();
    end
endtask

task do_opcode_nop();
    // Do... nothing
    if( timing_counter < OpCounterStart )
        ;
    else
        next_instruction();
endtask

task do_opcode_sec();
begin
    if( timing_counter == OpCounterStart ) begin
        data_bus_source <= `DataBusSrc_Ones;
        control_signals[`CtlSig_StatUpdateC] <= 1;
        status_src <= `StatusSrc_Data;

        next_instruction();
    end
end
endtask

task do_opcode_sta();
begin
    if( timing_counter < OpCounterStart ) begin
        ext_rW <= 0;
        data_bus_source <= `DataBusSrc_RegAcc;
    end else
        next_instruction();
end
endtask

task do_opcode_stx();
begin
    if( timing_counter < OpCounterStart ) begin
        ext_rW <= 0;
        data_bus_source <= `DataBusSrc_RegX;
    end else
        next_instruction();
end
endtask

task do_opcode_tsx();
begin
    if( timing_counter < OpCounterStart ) begin
        data_bus_source <= `DataBusSrc_RegS;
        control_signals[`CtlSig_RegXWrite] <= 1;
    end else
        next_instruction();
end
endtask

task do_opcode_txs();
begin
    if( timing_counter < OpCounterStart ) begin
        data_bus_source <= `DataBusSrc_RegX;
        stack_pointer_src_register <= `StackIn_DataBus;
    end else
        next_instruction();
end
endtask

task do_opcode_interrupt();
begin
    if( timing_counter < OpCounterStart ) begin
        timing_counter <= OpCounterStart;
        control_signals[`CtlSig_PcAdvance] <= 1;
        run_status <= Running;
    end else if( timing_counter == OpCounterStart ) begin
        // Push return address to stack
        data_bus_source <= `DataBusSrc_PCH;
        address_bus_source <= `AddrBusSrc_Sp;
        ext_rW <= (active_int == IntrReset);

        // Subtract one from stack pointer (push)
        alu_a_src <= `AluASrc_RegS;
        alu_b_src <= `AluBSrc_Zero;
        control_signals[`CtlSig_AluInverse] <= 1'b1;
        alu_carry_src <= `AluCarryIn_Zero;
        alu_op <= `AluOp_add;
        
        stack_pointer_src_register <= `StackIn_AluRes;
    end else if( timing_counter == OpCounterStart+1 ) begin
        // Push return address to stack
        data_bus_source <= `DataBusSrc_PCL;
        address_bus_source <= `AddrBusSrc_Sp;
        ext_rW <= (active_int == IntrReset);

        // Subtract one from stack pointer
        alu_a_src <= `AluASrc_RegS;
        alu_b_src <= `AluBSrc_Zero;
        control_signals[`CtlSig_AluInverse] <= 1'b1;
        alu_carry_src <= `AluCarryIn_Zero;
        alu_op <= `AluOp_add;

        stack_pointer_src_register <= `StackIn_AluRes;
    end else if( timing_counter == OpCounterStart+2 ) begin
        // Push status flags to stack
        data_bus_source <= `DataBusSrc_Status;
        address_bus_source <= `AddrBusSrc_Sp;
        ext_rW <= (active_int == IntrReset);
        control_signals[`CtlSig_StatOutputB] <= active_int==IntrBrk;

        // Subtract one from stack pointer
        alu_a_src <= `AluASrc_RegS;
        alu_b_src <= `AluBSrc_Zero;
        control_signals[`CtlSig_AluInverse] <= 1'b1;
        alu_carry_src <= `AluCarryIn_Zero;
        alu_op <= `AluOp_add;

        stack_pointer_src_register <= `StackIn_AluRes;

        // Preload the DL with the reset vector
        data_latch_ctl_high <= `DlhSrc_Ones;
        case( active_int )
            IntrBrk:
                data_latch_ctl_low <= `DllSrc_Irq;
            IntrIrq:
                data_latch_ctl_low <= `DllSrc_Irq;
            IntrNmi:
                data_latch_ctl_low <= `DllSrc_Nmi;
            IntrReset:
                data_latch_ctl_low <= `DllSrc_Reset;
        endcase
    end else if( timing_counter == OpCounterStart+3 ) begin
        // Load the vector
        address_bus_source <= `AddrBusSrc_Dl;
        ext_VP <= 1'b0;

        alu_a_src <= `AluASrc_DlLow;
        alu_b_src <= `AluBSrc_Zero;
        alu_carry_src <= `AluCarryIn_One;
        alu_op <= `AluOp_add;
        data_latch_ctl_low <= `DllSrc_AluRes;

        pc_low_src <= `PcLowIn_Mem;
        control_signals[`CtlSig_Jump] <= 1;
    end else if( timing_counter == OpCounterStart+4 ) begin
        address_bus_source <= `AddrBusSrc_Dl;
        ext_VP <= 1'b0;

        pc_low_src <= `PcLowIn_Preserve;
        pc_high_src <= `PcHighIn_Mem;
        control_signals[`CtlSig_Jump] <= 1;
    end else if( timing_counter == OpCounterStart+5 ) begin
        next_instruction();
    end
end
endtask
