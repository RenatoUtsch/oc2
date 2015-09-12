// Autores: Marcos Pantuza, Matheus Resende, Renato Utsch, Vítor Cézar
// Do TP do semestre passado. Para referência.

`include "../src/Alu.v"
`include "../src/Comparator.v"
`include "../src/Control.v"
`include "../src/Decode.v"
`include "../src/Execute.v"
`include "../src/Fetch.v"
`include "../src/MemController.v"
`include "../src/Memory.v"
`include "../src/Mips.v"
`include "../src/Ram.v"
`include "../src/Registers.v"
`include "../src/Shifter.v"
`include "../src/Writeback.v"
`include "testbench.vh"

module tb_Mips;
    reg clock;
    reg reset;
    wire [17:0] addr;
    wire [15:0] data;
    wire wre;
    wire oute;
    wire hb_mask;
    wire lb_mask;
    wire chip_en;

    Ram ram(
        .addr( addr ),
        .data( data ),
        .wre( wre ),
        .oute( oute ),
        .hb_mask( hb_mask ),
        .lb_mask( lb_mask ),
        .chip_en( chip_en )
    );

    Mips mips(
        .clock(clock),
        .reset(reset),
        .addr(addr),
        .data(data),
        .wre(wre),
        .oute(oute),
        .hb_mask(hb_mask),
        .lb_mask(lb_mask),
        .chip_en(chip_en)
    );


    initial begin
        $dumpvars(0);

        `ifdef MONITOR
            $monitor("%b %b %b %b %b %b", mips.REGISTERS.registers[8], mips.REGISTERS.registers[9],
                mips.REGISTERS.registers[10], mips.REGISTERS.registers[11],
                mips.EXECUTE.ALU.overflow_reg, mips.EXECUTE.ALU.overflow_indicator);
        `endif

        `runtest("add1.bin") #1000
        `test_if("add1", `t0 == 'd3) // The simple sum results in 3.

        `runtest("inc1.bin") #1000
        `test_if("inc1", `t0 == 'd4) // Result should be 4: incremented twice.

        `runtest("inc2.bin") #1000
        `test_if("inc2", `t0 == -'d4) // Result should be -4.

        `runtest("inc3.bin") #1000
        `test_if("inc3", `t0 == 'd0) // Should be 0.

        `runtest("mul1.bin") #1000
        `test_if("mul1", `t0 == 'd12) // The result of the multiplication is 12.

        `runtest("mul2.bin")
        #620
        `test_if("mul2/1", `t0 == 'hfff * 'hfff) // Test first multiplication.
        `test_if("mul2/2", `ov == 'd1) // Test for overflow.
        #480
        `test_if("mul2/3", `ov == 'd0) // Overflow should have been cleared.
        `test_if("mul2/4", `t3 == 'd3) // t3 should not have been modified.

        `runtest("mul3.bin") #1000
        `test_if("mul3", `t0 == -'d12) // Result should be -12.

        `runtest("mul4.bin") #1000
        `test_if("mul4", `t0 == -'d12) // Result should be -12.

        `runtest("mul5.bin") #1000
        `test_if("mul5", `t1 == 'd12) // Result should be 12.

        `runtest("mul6.bin")
        #620
        `test_if("mul6/1", `t0 == 'h1000 * 'h1000) // Test first multiplication.
        `test_if("mul6/2", `ov == 'd1) // Test for overflow.
        #480
        `test_if("mul6/3", `ov == 'd0) // Overflow should have been cleared.
        `test_if("mul6/4", `t3 == 'd3) // t3 should not have been modified.

        `runtest("mul7.bin")
        #620
        `test_if("mul7/1", `ov == 'd1) // Overflow should have happened.
        #480
        `test_if("mul7/2", `ov == 'd0) // Overflow should have been cleared.
        `test_if("mul7/3", `t3 == 'd3) // t3 should not have changed.

        `runtest("mul8.bin")
        #620
        `test_if("mul8/1", `ov == 'd1) // Overflow should have happened.
        #480
        `test_if("mul8/2", `ov == 'd0) // Overflow should have been cleared.
        `test_if("mul8/3", `t3 == 'd3) // t3 should not have changed.

        `runtest("inc4.bin")
        #1000
        `test_if("inc4/1", `t3 == 'h7FFFFFFF) // Should be biggest possible integer.
        `test_if("inc4/2", `ov == 'd0) // Overflow shouldn't have happened yet.
        `test_if("inc4/3", `t0 == 'h7FFF * 'd4) // Should be 0x7FFF * 4.
        #20
        `test_if("inc4/4", `t0 == 'h7FFF * 'd4) // Should still be 0x7FFF * 4.
        `test_if("inc4/5", `ov == 'd1) // Should have an overflow.
        #980
        `test_if("inc4/6", `t3 == 'h7FFFFFFF) // Should still be biggest possible integer.
        `test_if("inc4/7", `t0 == 'h7FFF * 'd4) // Should still be 0x7FFF * 4.
        `test_if("inc4/8", `ov == 'd0) // Overflow should have been cleared.

        $display("\nAll tests passed with success!");
        $finish;
    end

    always begin
        #5 clock <= ~clock;
    end
endmodule
