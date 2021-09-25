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
`define Op_brk  28
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

`define Op__Count 99
`define Op__NBits $clog2(`Op__Count)

task perform_instruction();
begin
    case(active_op)
    `Op_lda: do_opcode_lda();
    `Op_ldx: do_opcode_ldx();
    `Op_nop: do_opcode_nop();
    endcase
end
endtask

task next_instruction();
begin
    timing_counter_next = 0;
    address_bus_low_source = `AddrBusLowSrc_Pc;
    address_bus_high_source = `AddrBusHighSrc_Pc;
    active_op_next = `Op__invalid;

    control_signals[`CtlSig_PcAdvance] = 1;
    control_signals[`CtlSig_sync] = 1;
    control_signals[`CtlSig_write] = 0;
end
endtask

task do_opcode_nop();
    // Do... nothing
    next_instruction();
endtask

task do_opcode_lda();
begin
    control_signals[`CtlSig_RegAccWrite] = 1;
    data_bus_source = `DataBusSrc_Mem;
    next_instruction();
end
endtask

task do_opcode_ldx();
begin
    control_signals[`CtlSig_RegXWrite] = 1;
    data_bus_source = `DataBusSrc_Mem;
    next_instruction();
end
endtask
