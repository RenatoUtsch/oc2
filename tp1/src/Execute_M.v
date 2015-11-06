module Execute_M (
	 input                   clock,
    input                   reset,
    //Issue
	 input         [1:0]     is_m0_functionalunit,
    input         [2:0]     is_m0_aluop,
    input                   is_m0_unsig,
    input         [31:0]    is_m0_rega,
    input                   is_m0_readmem,
    input                   is_m0_writemem,
    input         [31:0]    is_m0_regb,
    input         [31:0]    is_m0_imedext,
    input                   is_m0_selwsource,
    input         [4:0]     is_m0_regdest,
    input                   is_m0_writereg,
    // Writeback
    output     [4:0]     m_wb_regdest,
    output               m_wb_writereg,
    output     [31:0]    m_wb_wbvalue
);

	 wire					 m0_m1_stall;
    wire              m0_m1_readmem;
    wire              m0_m1_writemem;
    wire    [31:0]    m0_m1_regb;
    wire              m0_m1_selwsource;
    wire    [4:0]     m0_m1_regdest;
    wire              m0_m1_writereg;
    wire    [31:0]    m0_m1_wbvalue;
	 //EstÃ¡gios vazios: M2 e M3
	 wire				  m1_m2_stall;
    wire    [4:0]   m1_m2_regdest;
    wire            m1_m2_writereg;
    wire    [31:0]  m1_m2_wbvalue;
	 wire				  m2_m3_stall;
    wire    [4:0]   m2_m3_regdest;
    wire            m2_m3_writereg;
    wire    [31:0]  m2_m3_wbvalue;
	 
	 wire stall;
	 
	 assign stall = (is_m0_functionalunit == 2) ? 1'b0 : 1'b1;

Execute_M0 e_M0(.clock(clock),.reset(reset),.is_m0_stall(stall),.is_m0_aluop(is_m0_aluop),
					 .is_m0_unsig(is_m0_unsig),.is_m0_readmem(is_m0_readmem),.is_m0_writemem(is_m0_writemem),
					 .is_m0_regb(is_m0_regb),.is_m0_imedext(is_m0_imedext),.is_m0_selwsource(is_m0_selwsource),
					 .is_m0_regdest(is_m0_regdest),.is_m0_writereg(is_m0_writereg),.m0_m1_readmem(m0_m1_readmem),
					 .m0_m1_writemem(m0_m1_writemem),.m0_m1_regb(m0_m1_regb),.m0_m1_selwsource(m0_m1_selwsource),
					 .m0_m1_regdest(m0_m1_regdest),.m0_m1_writereg(m0_m1_writereg),.m0_m1_wbvalue(m0_m1_wbvalue));

Execute_M1 e_M1(.clock(clock),.reset(reset),.m0_m1_stall(m0_m1_stall),.m0_m1_mem_readmem(m0_m1_readmem),
					 .m0_m1_mem_writemem(m0_m1_writemem),.m0_m1_mem_regb(m0_m1_regb),
					 .m0_m1_mem_selwsource(m0_m1_selwsource),.m0_m1_mem_regdest(m0_m1_regdest),
					 .m0_m1_mem_writereg(m0_m1_writereg),.m0_m1_wbvalue(m0_m1_wbvalue),.m1_m2_regdest(m1_m2_regdest),
					 .m1_m2_writereg(m1_m2_writereg),.m1_m2_wbvalue(m1_m2_wbvalue));

Execute_S e_M2(.clock(clock),.reset(reset),.in_regdest(m1_m2_regdest),.in_stall(m1_m2_stall),
					.in_writereg(m1_m2_writereg),.in_wbvalue(m1_m2_wbvalue),.out_regdest(m2_m3_regdest),
					.out_writereg(m2_m3_writereg),.out_wbvalue(m2_m3_wbvalue));
		  
Execute_S e_M3(.clock(clock),.reset(reset),.in_regdest(m2_m3_regdest),.in_stall(m2_m3_stall),
					.in_writereg(m2_m3_writereg),.in_wbvalue(m2_m3_wbvalue),.out_regdest(m_wb_regdest),
					.out_writereg(m_wb_writereg),.out_wbvalue(m_wb_wbvalue));

endmodule

module Execute_M0 (	//Execute.v  modificado
	 input                   clock,
    input                   reset,
    //Issue
	 input 						 is_m0_stall,
    input         [2:0]     is_m0_aluop,
    input                   is_m0_unsig,
    input         [31:0]    id_ex_rega,
    input                   is_m0_readmem,
    input                   is_m0_writemem,
    input         [31:0]    is_m0_regb,
    input         [31:0]    is_m0_imedext,	// immediate?
    input                   is_m0_selwsource,
    input         [4:0]     is_m0_regdest,
    input                   is_m0_writereg,
    //M1
    output reg              m0_m1_readmem,
    output reg              m0_m1_writemem,
    output reg    [31:0]    m0_m1_regb,
    output reg              m0_m1_selwsource,
    output reg    [4:0]     m0_m1_regdest,
    output reg              m0_m1_writereg,
    output reg    [31:0]    m0_m1_wbvalue	
);

    
    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            m0_m1_readmem <= 1'b0;
            m0_m1_writemem <= 1'b0;
            m0_m1_regb <= 32'h0000_0000;
            m0_m1_selwsource <= 1'b0;
            m0_m1_regdest <= 5'b00000;
            m0_m1_writereg <= 1'b0;
            m0_m1_addr <= 32'h0000_0000;
        end else if (is_m0_stall) begin
            m0_m1_readmem <= 1'b0;
            m0_m1_writemem <= 1'b0;
            m0_m1_regb <= 32'h0000_0000;
            m0_m1_selwsource <= 1'b0;
            m0_m1_regdest <= 5'b00000;
            m0_m1_writereg <= 1'b0;
            m0_m1_addr <= 32'h0000_0000;
        end else begin
            m0_m1_readmem <= is_m0_readmem;
            m0_m1_writemem <= is_m0_writemem;
            m0_m1_regb <= is_m0_regb;
            m0_m1_selwsource <= is_m0_selwsource;
            m0_m1_regdest <= is_m0_regdest;
            m0_m1_writereg <= is_m0_writereg;
				//Realizando o cálculo do endereço
				m0_m1_wbvalue <= id_ex_rega + is_m0_imedext;
        end
    end

endmodule

module Execute_M1(
	 input                   clock,
    input                   reset,
    //M0
	 input						 m0_m1_stall,
    input                   m0_m1_mem_readmem,
    input                   m0_m1_mem_writemem,
    input         [31:0]    m0_m1_mem_regb,
    input                   m0_m1_mem_selwsource,
    input         [4:0]     m0_m1_mem_regdest,
    input                   m0_m1_mem_writereg,
    input         [31:0]    m0_m1_wbvalue,
    //M2
    output reg    [4:0]     m1_m2_regdest,
    output reg              m1_m2_writereg,
    output reg    [31:0]    m1_m2_wbvalue
);

	 wire [6:0] addr;
    wire wre;
    wire [31:0] data;

    Ram RAM(.addr(addr),.wre(wre),.data(data),.flag(1'b0),.reset(reset));

    assign wre = !m0_m1_mem_writemem;
    assign addr = m0_m1_addr[6:0];
    assign data = wre ? 32'hZZZZ_ZZZZ : m0_m1_mem_regb;

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            m1_m2_regdest <= 5'b00000;
            m1_m2_writereg <= 1'b0;
            m1_m2_wbvalue <= 32'h0000_0000;
        end else if (m0_m1_stall) begin
            m1_m2_regdest <= 5'b00000;
            m1_m2_writereg <= 1'b0;
            m1_m2_wbvalue <= 32'h0000_0000;
        end else begin
            m1_m2_regdest <= m0_m1_mem_regdest;
            m1_m2_writereg <= m0_m1_mem_writereg;
            if (m0_m1_mem_selwsource==1'b1) begin
-                m1_m2_wbvalue <= data;
-            end else begin
-                m1_m2_wbvalue <= m0_m1_wbvalue;
-            end
        end
    end

endmodule
