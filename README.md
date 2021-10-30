# Multi Variants 6502 Implementation

Thius project implements a cycle accurate version of several variants of the 6502 CPU core. Yes, this is _yet another_ 6502 verilog project.

# Main Module Parameters

The `cpu` module has several parameters modifying the implementation. Leaving all parameters as defualt will output an implementation as closely matching the w65c02 Western Design Center CPU as possible (minus the WDC bugs).

The parameters are:

## UnknownUndefined
0 (default) means unknown opcodes are treated as no operation (with some treated as different width no-op, as per w65c02 datasheet).

1 means unknown opcodes are left undefined. Actual result will depend on generation. This setting should save on final implementation size, but should _not_ be used
if the MOS6502 illegal commands are desired. For that, see `CompatibleIllegalOpcodes`.

## CompatibleBusQuirks
0 (default) means behave like the 65c02.

1 adds the quirks characteristic of the MOS 6502.

Current quirks defined:
* On read/modify/write, perform one read followed by two writes.
* Branch to different page dummy reads correct offset in current page.

## OldAbsIndirectBehavior
0 (default) means jump indirect through last byte of page uses first byte of next page as MSB. It also means this addressing mode takes 6 cycles.

1 means jump uses first byte of _same_ page as MSB. Opcode takes 5 cycles.

## CompatibleIllegalOpcodes
0 (default) means don't perform any special handling for the 6502 unofficial illegal commands (such as lax).

1 means make sure these commands do the same thing as on the 6502.

Setting this option to 1 is incompatibile with `New65c02Opcodes`, as some of those commands occupy the same opcode numbers.

## New65c02Opcodes
1 (default) adds opcodes available only on the 65c02 and on the WDC 65c02. These include opcodes added on the 65c02 (such as BRA) and by WDC (such as WAI).

0 means these opcodes are treated as undefined commands.

## DecimalMode
1 (default) means decimal mode is supported

0 means decimal mode can be set as usual, but it does not affect arithmetics.

