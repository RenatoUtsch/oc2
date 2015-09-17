// Autores: Marcos Pantuza, Matheus Resende, Renato Utsch, Vítor Cézar
// Do TP do semestre passado. Para referência.

`include "../src/Alu.v"
`include "../src/Comparator.v"
`include "../src/Control.v"
`include "../src/Decode.v"
`include "../src/Execute.v"
`include "../src/Fetch.v"
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
    reg [4:0] addrout;

    Mips mips(
        .clock(clock),
        .reset(reset),
        .addrout(addrout)
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

        $display("\nAll tests passed with success!");
        $finish;
    end

    always begin
        #5 clock <= ~clock;
    end
endmodule
