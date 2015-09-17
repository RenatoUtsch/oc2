`ifndef testbench_vh
`define testbench_vh

// Stops if condition is false. Prints test name and if it passed or not.
`define test_if(name, cond) if((cond)) begin \
        $display("-- Test %s: passed", name); \
    end else begin \
        $display("-- Test %s: failed\n\nA test has failed!", name); \
        $finish(1); \
    end

// Resets the processor, loads the test. You must set the correct wait time
// afterwards.
`define runtest(name) #1 \
    clock = 0; \
    reset = 0; \
    #1 reset = 1; \
    $readmemb(name, mips.FETCH.RAM.memory);

// Represents the registers.
`define t0 mips.REGISTERS.registers[8]
`define t1 mips.REGISTERS.registers[9]
`define t2 mips.REGISTERS.registers[10]
`define t3 mips.REGISTERS.registers[11]
`define ov mips.EXECUTE.ALU.overflow_reg


`endif
