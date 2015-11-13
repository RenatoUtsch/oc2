module Mips (
    input clock,
    input reset,
    output [31:0] regout$0,
	 output [31:0] regout$1,
	 output [31:0] regout$2,
	 output [31:0] regout$3,
	 output [31:0]	regout$4
);

	 wire    [31:0]    if_id_nextpc;
    wire    [31:0]    if_id_instruc;
    wire              is_if_stall;
	 wire              is_if_selpcsource;
    wire    [31:0]    is_if_rega;
    wire    [31:0]    is_if_pcimd2ext;
    wire    [31:0]    is_if_pcindex;
    wire    [1:0]     is_if_selpctype;
    wire              ex_mem_readmem;
    wire              ex_mem_writemem;
    wire    [31:0]    ex_mem_regb;
    wire              ex_mem_selwsource;
    wire    [4:0]     ex_mem_regdest;
    wire              ex_mem_writereg;
    wire    [31:0]    ex_mem_wbvalue;
    wire    [4:0]     ex_wb_regdest;
    wire              ex_wb_writereg;
    wire    [31:0]    ex_wb_wbvalue;
	 wire    [31:0]    id_is_addra;
	 wire    [31:0]    id_is_addrb;
	 // Wires do Decode para o Issue
	 wire		[1:0]		 id_is_selpctype;
	 wire 	[31:0]	 id_is_nextpc;	 
    wire              id_is_selalushift;
    wire              id_is_selimregb;
    wire    [2:0]     id_is_aluop;
    wire              id_is_unsig;
    wire    [1:0]     id_is_shiftop;
    wire    [4:0]     id_is_shiftamt;
    wire    [31:0]    id_is_rega;
    wire              id_is_readmem;
    wire              id_is_writemem;
    wire    [31:0]    id_is_regb;
    wire    [31:0]    id_is_imedext;
    wire              id_is_selwsource;
    wire    [4:0]     id_is_regdest;
    wire              id_is_writereg;
    wire              id_is_writeov;
	 wire    [1:0]     id_is_numop;
	 wire 	[1:0]		 id_is_fununit;
	 wire		[2:0]		 id_is_compop;
    wire              wb_reg_en;
    wire    [4:0]     wb_reg_addr;
    wire    [31:0]    wb_reg_data;
	 // Wires do Issue para o Execute
	 wire    [4:0]     is_reg_addra;
    wire    [4:0]     is_reg_addrb;
    wire    [31:0]    reg_is_dataa;
    wire    [31:0]    reg_is_datab;
    wire    [31:0]    reg_is_ass_dataa;
    wire    [31:0]    reg_is_ass_datab;
	 wire 				 is_ex_selalushift;
    wire 				 is_ex_selimregb;
    wire		[2:0]     is_ex_aluop;
    wire 				 is_ex_unsig;
    wire    [1:0]     is_ex_shiftop;
    wire    [4:0]     is_ex_shiftamt;
    wire    [31:0]    is_ex_rega;
    wire					 is_ex_readmem;
    wire 				 is_ex_writemem;
    wire 	[31:0]    is_ex_regb;
    wire 	[31:0]    is_ex_imedext;
    wire 				 is_ex_selwsource;
    wire 	[4:0]     is_ex_regdest;
    wire 				 is_ex_writereg;
    wire 				 is_ex_writeov;
	 wire 	[1:0]	  	 is_ex_unidadefuncional;
	 wire		[4:0]     is_ex_regdestmemory;		// Wire adicionado. Vítor Cézar
	 // Wires do Demux
	 wire 	[4:0]		 x_wb_regdest; 
	 wire					 x_wb_writereg;
	 wire		[31:0]	 x_wb_wbvalue;
	 wire 	[4:0]		 y_wb_regdest; 
	 wire					 y_wb_writereg;
	 wire		[31:0]	 y_wb_wbvalue;
	 wire 	[4:0]		 m_wb_regdest; 
	 wire					 m_wb_writereg;
	 wire		[31:0]	 m_wb_wbvalue;
	 wire    [31:0]	 id_is_instruc;
	 wire    [1:0]     id_is_selbrjumpz;
	 
	 /*wire 	[1:0]		 is_if_selpctype;
	 wire 	[1:0]		 is_if_selpcsource;
	 wire 	[31:0]	 is_if_pcindex;
	 wire		[31:0]	 is_if_pcimd2ext;*/

    Fetch FETCH(.clock(clock),.reset(reset),.is_if_stall(is_if_stall),.if_id_nextpc(if_id_nextpc),
                .if_id_instruc(if_id_instruc),.id_if_selpcsource(is_if_selpcsource),.id_if_rega(is_if_rega),
                .id_if_pcimd2ext(is_if_pcimd2ext),.id_if_pcindex(is_if_pcindex),.id_if_selpctype(is_if_selpctype));	
 		
	 Decode DECODE(.clock(clock),.reset(reset),.if_id_instruc(if_id_instruc),.if_id_nextpc(if_id_nextpc),.id_is_selpctype(id_is_selpctype),
                  .id_is_selalushift(id_is_selalushift),.id_is_selbrjumpz(id_is_selbrjumpz),.id_is_nextpc(id_is_nextpc),
                  .id_is_selimregb(id_is_selimregb),.id_is_aluop(id_is_aluop),.id_is_unsig(id_is_unsig),
                  .id_is_shiftop(id_is_shiftop),.id_is_addra(id_is_addra),.id_is_compop(id_is_compop),
                  .id_is_readmem(id_is_readmem),.id_is_writemem(id_is_writemem),.id_is_addrb(id_is_addrb),
                  .id_is_imedext(id_is_imedext),.id_is_selwsource(id_is_selwsource),.id_is_regdest(id_is_regdest),
                  .id_is_writereg(id_is_writereg),.id_is_writeov(id_is_writeov),.is_if_stall(is_if_stall),
						.id_is_numop(id_is_numop),.id_is_fununit(id_is_fununit),.id_is_instruc(id_is_instruc));

	 Issue ISSUE(.id_is_nextpc(id_is_nextpc),.is_if_selpctype(is_if_selpctype),.is_if_pcindex(is_if_pcindex),
					 .is_if_pcimd2ext(is_if_pcimd2ext),.is_if_selpcsource(is_if_selpcsource),.id_is_instruc(id_is_instruc),
					 .id_is_selbrjumpz(id_is_selbrjumpz),.id_is_selalushift(id_is_selalushift),.id_is_selimregb(id_is_selimregb),.clock(clock),
                .reset(reset),.id_is_aluop(id_is_aluop),.id_is_unsig(id_is_unsig),.id_is_shiftop(id_is_shiftop),.is_if_rega(is_if_rega),
                .id_is_shiftamt(id_is_shiftamt),.id_is_readmem(id_is_readmem),.id_is_writemem(id_is_writemem),.id_is_imedext(id_is_imedext),
                .id_is_selwsource(id_is_selwsource),.id_is_regdest(id_is_regdest),.id_is_writereg(id_is_writereg),
                .id_is_writeov(id_is_writeov),.is_if_stall(is_if_stall),.is_ex_selalushift(is_ex_selalushift),
					 .is_ex_selimregb(is_ex_selimregb),.is_ex_aluop(is_ex_aluop),.is_ex_regdestmemory(is_ex_regdestmemory),
					 .is_ex_shiftamt(is_ex_shiftamt),.is_ex_rega(is_ex_rega),.is_ex_readmem(is_ex_readmem),.id_is_compop(id_is_compop),
					 .is_ex_writemem(is_ex_writemem),.is_ex_regb(is_ex_regb),.is_ex_imedext(is_ex_imedext),.id_is_selpctype(id_is_selpctype),
					 .is_ex_selwsource(is_ex_selwsource),.is_ex_regdest(is_ex_regdest),.is_ex_writereg(is_ex_writereg),
					 .is_ex_writeov(is_ex_writeov),.is_ex_unidadefuncional(is_ex_unidadefuncional),.is_ex_unsig(is_ex_unsig),
					 .is_ex_shiftop(is_ex_shiftop),.id_is_numop(id_is_numop),.id_is_addra(id_is_addra),.id_is_addrb(id_is_addrb),
					 .is_reg_addra(is_reg_addra),.is_reg_addrb(is_reg_addrb),.reg_is_dataa(reg_is_dataa),.id_is_fununit(id_is_fununit),
					 .reg_is_datab(reg_is_datab),.reg_is_ass_dataa(reg_is_ass_dataa),.reg_is_ass_datab(reg_is_ass_datab));
						  
						  
	 Execute_X EXECUTE_X(.clock(clock),.reset(reset),.is_x_functionalunit(is_ex_unidadefuncional),
								.is_x_selalushift(is_ex_selalushift),.is_x_selimregb(is_ex_selimregb),.is_x_aluop(is_ex_aluop),
								.is_x_unsig(is_ex_unsig),.is_x_shiftop(is_ex_shiftop),.is_x_shiftamt(is_ex_shiftamt),
								.is_x_rega(is_ex_rega),.is_x_regb(is_ex_regb),.is_x_imedext(is_ex_imedext),.is_x_regdest(is_ex_regdest),
								.is_x_writereg(is_ex_writereg),.is_x_writeov(is_ex_writeov),.x_wb_regdest(x_wb_regdest),
								.x_wb_writereg(x_wb_writereg),.x_wb_wbvalue(x_wb_wbvalue));

	 Execute_Y EXECUTE_Y(.clock(clock),.reset(reset),.is_y_functionalunit(is_ex_unidadefuncional),.is_y_rega(is_ex_rega),
								.is_y_regb(is_ex_regb),.is_y_regdest(is_ex_regdest),.y_wb_regdest(y_wb_regdest),
								.y_wb_writereg(y_wb_writereg),.y_wb_wbvalue(y_wb_wbvalue));
	 
	 Execute_M EXECUTE_M(.clock(clock),.reset(reset),.is_m0_functionalunit(is_ex_unidadefuncional),
								.is_m0_readmem(is_ex_readmem),.is_m0_writemem(is_ex_writemem),
								.is_m0_rega(is_ex_rega),.is_m0_regdestv(is_ex_regb),.is_m0_imedext(is_ex_imedext),
								.is_m0_regdest(is_ex_regdest/*memory*/),.is_m0_writereg(is_ex_writereg),.m_wb_regdest(m_wb_regdest),
								.m_wb_writereg(m_wb_writereg),.m_wb_wbvalue(m_wb_wbvalue));
								
	 Demux DEMUX(.x_wb_regdest(x_wb_regdest),.x_wb_writereg(x_wb_writereg),.x_wb_wbvalue(x_wb_wbvalue),
					 .y_wb_regdest(y_wb_regdest),.y_wb_writereg(y_wb_writereg),.y_wb_wbvalue(y_wb_wbvalue),
					 .m_wb_regdest(m_wb_regdest),.m_wb_writereg(m_wb_writereg),.m_wb_wbvalue(m_wb_wbvalue),
					 .ex_wb_regdest(ex_wb_regdest),.ex_wb_writereg(ex_wb_writereg),.ex_wb_wbvalue(ex_wb_wbvalue));
						
    Writeback WRITEBACK(.mem_wb_regdest(ex_wb_regdest),.mem_wb_writereg(ex_wb_writereg),.mem_wb_wbvalue(ex_wb_wbvalue),
                        .wb_reg_en(wb_reg_en),.wb_reg_addr(wb_reg_addr),.wb_reg_data(wb_reg_data));

    Registers ARCHITECTURE_REGISTER_FILE(.clock(clock),.reset(reset),.addra(is_reg_addra),.dataa(reg_is_dataa),
													  .ass_dataa(reg_is_ass_dataa),.addrb(is_reg_addrb),.datab(reg_is_datab),
													  .ass_datab(reg_is_ass_datab),.enc(wb_reg_en),.addrc(wb_reg_addr),.datac(wb_reg_data),
													  .regout$0(regout$0),.regout$1(regout$1),.regout$2(regout$2),
													  .regout$3(regout$3),.regout$4(regout$4));
												
endmodule
