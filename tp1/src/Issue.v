module Issue(
    input                   clock,
    input                   reset,
    //Decode
    input                   id_is_selalushift,
    input                   id_is_selimregb,
    input         [2:0]     id_is_aluop,
    input                   id_is_unsig,
    input         [1:0]     id_is_shiftop,
    input         [4:0]     id_is_shiftamt,
    input         [31:0]    id_is_rega,
    input                   id_is_readmem,
    input                   id_is_writemem,
    input         [31:0]    id_is_regb,
    input         [31:0]    id_is_imedext,
    input                   id_is_selwsource,
    input         [4:0]     id_is_regdest,
    input                   id_is_writereg,
    input                   id_is_writeov,
	 input         [4:0]     id_is_addra,
	 input         [4:0]     id_is_addrb,
	 //numero de operandos de cada instrucao
	 input         [1:0]     id_is_numop,
	
	 input 						 execute_stall,
    //Fetch
    output reg   	           is_if_stall,
	 output                   is_ex_selalushift,
    output                   is_ex_selimregb,
    output         [2:0]     is_ex_aluop,
    output                   is_ex_unsig,
    output         [1:0]     is_ex_shiftop,
    output         [4:0]     is_ex_shiftamt,
    output         [31:0]    is_ex_rega,
    output                   is_ex_readmem,
    output                   is_ex_writemem,
    output         [31:0]    is_ex_regb,
    output         [31:0]    is_ex_imedext,
    output                   is_ex_selwsource,
    output         [4:0]     is_ex_regdest,
    output                   is_ex_writereg,
    output                   is_ex_writeov,
	 output	 reg	 [1:0]	  is_ex_unidadefuncional
	 );
	 wire [31:0] pnd_sgn;
	 reg wre;
	 Scoreboard SCOREBOARD(.clock(clock),.reset(reset),.reg_addr(id_is_regdest),
		.func_uni(is_ex_unidadefuncional),.wre(wre),.pnd_sgn(pnd_sgn));
	 
	 //assign is_if_stall = 1'b0;
	 assign is_ex_selalushift = (is_if_stall) ? 1'b0 : id_is_selalushift;
	 assign is_ex_selimregb = (is_if_stall) ? 1'b0 : id_is_selimregb;
	 assign is_ex_aluop = (is_if_stall) ? 3'b000 : id_is_aluop;
	 assign is_ex_unsig = (is_if_stall) ? 1'b0 : id_is_unsig;
	 assign is_ex_shiftop = (is_if_stall) ? 2'b00 : id_is_shiftop;
	 assign is_ex_shiftamt = id_is_shiftamt; //nao estamos zerando
	 assign is_ex_rega = id_is_rega;
	 assign is_ex_writemem = (is_if_stall) ? 1'b0 : id_is_writemem;
	 assign is_ex_regb = id_is_regb;
	 assign is_ex_imedext = id_is_imedext;
	 assign is_ex_selwsource = (is_if_stall) ? 1'b0 : id_is_selwsource;
	 assign is_ex_regdest = (is_if_stall) ? 5'b00000 : id_is_regdest;
	 assign is_ex_writeov = (is_if_stall) ? 1'b0 : id_is_writeov;
	
	 always @(posedge clock or negedge reset) begin
		if(!reset) begin
			is_if_stall = 1'b0;
			wre =  1'b1;
		end
		else begin
			
			wre = (is_if_stall) || !(id_is_numop);
			
			if(((id_is_numop == 1) && pnd_sgn[id_is_addra]) ||
			   ((id_is_numop == 2) && (pnd_sgn[id_is_addra] || pnd_sgn[id_is_addrb]) ))begin
				is_if_stall = 1'b1;
				is_ex_unidadefuncional = 1'b0;
			end
			else begin
				if(id_is_readmem || id_is_writemem)
					is_ex_unidadefuncional = 2'b10;
				else if(id_is_aluop == 3'b111 )
					is_ex_unidadefuncional = 2'b11;
				else
					is_ex_unidadefuncional = 2'b01;
				is_if_stall = 1'b0;
			end
		end
	 end
	 
endmodule	 
