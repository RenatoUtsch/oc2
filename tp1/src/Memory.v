module Memory (
    input                   clock,
    input                   reset,
    //Execute
    input                   ex_mem_readmem,
    input                   ex_mem_writemem,
    input         [31:0]    ex_mem_regb,
    input                   ex_mem_selwsource,
    input         [4:0]     ex_mem_regdest,
    input                   ex_mem_writereg,
    input         [31:0]    ex_mem_wbvalue,
    //Writeback
    output reg    [4:0]     mem_wb_regdest,
    output reg              mem_wb_writereg,
    output reg    [31:0]    mem_wb_wbvalue
);

    wire [8:0] addr;
    wire wre;
    wire [31:0] data;

    Ram RAM(.addr(addr),.wre(wre),.data(data));

    assign wre = ex_mem_readmem & !ex_mem_writemem;
    assign addr = ex_mem_wbvalue[8:0];
    assign data = wre ? 32'hZZZZ_ZZZZ : ex_mem_regb;

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            mem_wb_regdest <= 5'b00000;
            mem_wb_writereg <= 1'b0;
            mem_wb_wbvalue <= 32'h0000_0000;
        end else begin
            mem_wb_regdest <= ex_mem_regdest;
            mem_wb_writereg <= ex_mem_writereg;
            if (ex_mem_selwsource==1'b1) begin
                mem_wb_wbvalue <= data;
            end else begin
                mem_wb_wbvalue <= ex_mem_wbvalue;
            end
        end
    end

endmodule
