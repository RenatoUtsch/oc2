module Issue(
    input                   clock,
    input                   reset,
	 //Fetch
    output        [31:0]    is_if_rega,
    //Decode
    input                   id_is_selalushift,
    input                   id_is_selimregb,
    input         [2:0]     id_is_aluop,
    input                   id_is_unsig,
    input         [1:0]     id_is_shiftop,
    input         [4:0]     id_is_shiftamt,
    input                   id_is_readmem,
    input                   id_is_writemem,
    input         [31:0]    id_is_imedext,
    input                   id_is_selwsource,
    input         [4:0]     id_is_regdest,
    input                   id_is_writereg,
    input                   id_is_writeov,
	 input         [4:0]     id_is_addra,
	 input         [4:0]     id_is_addrb,
	 input			[1:0]   	 id_is_fununit,
	 input         [1:0]     id_is_numop,
    //Fetch
    output   	   	       is_if_stall,
	 //Execute
	 output   reg            is_ex_selalushift,
    output   reg            is_ex_selimregb,
    output   reg   [2:0]    is_ex_aluop,
    output   reg            is_ex_unsig,
    output   reg   [1:0]    is_ex_shiftop,
    output   reg   [4:0]    is_ex_shiftamt,
    output   reg   [31:0]   is_ex_rega,
    output   reg            is_ex_readmem,
    output   reg            is_ex_writemem,
    output   reg   [31:0]   is_ex_regb,
    output   reg   [31:0]   is_ex_imedext,
    output   reg            is_ex_selwsource,
    output   reg   [4:0]    is_ex_regdest,
    output   reg            is_ex_writereg,
    output   reg            is_ex_writeov,
	 output	 reg   [1:0]	 is_ex_unidadefuncional,
	 //Registers
    output     	 [4:0]    is_reg_addra,
    output   	    [4:0]    is_reg_addrb,
    input          [31:0]   reg_is_dataa,
    input          [31:0]   reg_is_datab,
    input          [31:0]   reg_is_ass_dataa,
    input          [31:0]   reg_is_ass_datab
	);
	 
	 wire [31:0] pnd_sgn;
	 wire wre;
	 wire [31:0] rega;
	 wire [31:0] regb;
	 wire [31:0] shiftamt; 
	 
    assign is_if_rega = reg_is_ass_dataa;
    assign is_reg_addra = id_is_addra;
    assign is_reg_addrb = id_is_addrb;
    assign rega = reg_is_dataa;
    assign regb = reg_is_datab;
	 assign shiftamt = reg_is_dataa;
	 
	 Scoreboard SCOREBOARD(.clock(clock),.reset(reset),.reg_addr(id_is_regdest),
									.func_uni(is_ex_unidadefuncional),.wre(wre),.pnd_sgn(pnd_sgn));
	
	 assign wre = (is_if_stall || !id_is_numop);
	 assign is_if_stall = ((id_is_numop == 1) && pnd_sgn[id_is_addra]) ||((id_is_numop == 2) && (pnd_sgn[id_is_addra] || pnd_sgn[id_is_addrb])) ? 1'b1 : 1'b0;
	
	 always @(posedge clock or negedge reset) begin
		if(!reset) begin
			is_ex_unidadefuncional <= 2'b00;
			is_ex_selalushift <= 1'b0;
			is_ex_selimregb <= 1'b0;
			is_ex_aluop <= 3'b000;
			is_ex_unsig <= 1'b0;
			is_ex_shiftop <= 2'b00;
			is_ex_writemem <= 1'b0;
			is_ex_readmem <= 1'b0;
			is_ex_writereg <= 1'b0;
			is_ex_imedext <= 32'h0000_0000;
			is_ex_selwsource <= 1'b0;
			is_ex_regdest <= 5'b00000;
			is_ex_writeov <= 1'b0;
			is_ex_shiftamt <= 5'b00000;
			is_ex_rega <= 32'h0000_0000;
			is_ex_regb <= 32'h0000_0000;
		end
		else begin				
			is_ex_unidadefuncional <= (is_if_stall) ? 2'b00 : id_is_fununit;
			is_ex_selalushift <= (is_if_stall) ? 1'b0 : id_is_selalushift;
			is_ex_selimregb <= (is_if_stall) ? 1'b0 : id_is_selimregb;
			is_ex_aluop <= (is_if_stall) ? 3'b000 : id_is_aluop;
			is_ex_unsig <= (is_if_stall) ? 1'b0 : id_is_unsig;
			is_ex_shiftop <= (is_if_stall) ? 2'b00 : id_is_shiftop;
			is_ex_writemem <= (is_if_stall) ? 1'b0 : id_is_writemem;
			is_ex_readmem <= (is_if_stall) ? 1'b0 : id_is_readmem;
			is_ex_writereg <= (is_if_stall) ? 1'b0: id_is_writereg;
			is_ex_imedext <= (is_if_stall) ? 32'h0000_0000 : id_is_imedext;
			is_ex_selwsource <= (is_if_stall) ? 1'b0 : id_is_selwsource;
			is_ex_regdest <= (is_if_stall) ? 5'b00000 : id_is_regdest;
			is_ex_writeov <= (is_if_stall) ? 1'b0 : id_is_writeov;
			is_ex_shiftamt <= (is_if_stall) ? 5'b00000 : shiftamt;
			is_ex_rega <= (is_if_stall) ? 32'h0000_0000 : rega;
			is_ex_regb <= (is_if_stall) ? 32'h0000_0000 : regb;
		end
	 end
	 
	 /*always @(id_is_numop or is_if_stall) begin
		wre <= (is_if_stall) || !(id_is_numop);
	 end*/
	 
	 /*assign is_ex_selalushift = (is_if_stall) ? 1'b0 : id_is_selalushift;
	 assign is_ex_selimregb = (is_if_stall) ? 1'b0 : id_is_selimregb;
	 assign is_ex_aluop = (is_if_stall) ? 3'b000 : id_is_aluop;
	 assign is_ex_unsig = (is_if_stall) ? 1'b0 : id_is_unsig;
	 assign is_ex_shiftop = (is_if_stall) ? 2'b00 : id_is_shiftop;
	 assign is_ex_shiftamt = id_is_shiftamt; 
	 assign is_ex_writemem = (is_if_stall) ? 1'b0 : id_is_writemem;
	 assign is_ex_readmem = (is_if_stall) ? 1'b0 : id_is_readmem;
	 assign is_ex_writereg = (is_if_stall) ? 1'b0: id_is_writereg;
	 assign is_ex_imedext = id_is_imedext;
	 assign is_ex_selwsource = (is_if_stall) ? 1'b0 : id_is_selwsource;
	 assign is_ex_regdest = (is_if_stall) ? 5'b00000 : id_is_regdest;
	 assign is_ex_writeov = (is_if_stall) ? 1'b0 : id_is_writeov;*/
	 
endmodule	 
