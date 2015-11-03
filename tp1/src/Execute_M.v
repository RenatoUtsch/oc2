module Execute_M (
    input               clock,
    input               reset,
    // Issue
    input                   id_ex_readmem,
    input                   id_ex_writemem,
    input         [31:0]    id_ex_regb,
    input                   id_ex_selwsource,
    input         [4:0]     id_ex_regdest,
    input                   id_ex_writereg,
    input         [31:0]    ex_mem_wbvalue,
    // Writeback
    output reg    [4:0]     mem_wb_regdest,
    output reg              mem_wb_writereg,
    output reg    [31:0]    mem_wb_wbvalue
);

Execute_M0 e_M0();
Execute_M1 e_M1();
Execute_S e_M2();
Exceute_S e_M3();

endmodule

module Execute_M0 (

);



endmodule

module Execute_M1 (

);



endmodule
