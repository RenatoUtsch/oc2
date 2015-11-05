module Mips (
    input clock,
    input reset,
    output [31:0] regout,
	 output [31:0] regout2,
	 output [31:0] regout3,
	 output [31:0] regout4,
    input [4:0] addrout
);
	 // fio inútil
	 wire ex_if_stall;
	
    wire              is_if_stall;
    wire    [31:0]    if_id_nextpc;
    wire    [31:0]    if_id_instruc;
    wire              id_if_selpcsource;
    wire    [31:0]    id_if_rega;
    wire    [31:0]    id_if_pcimd2ext;
    wire    [31:0]    id_if_pcindex;
    wire    [1:0]     id_if_selpctype;
    wire              ex_mem_readmem;
    wire              ex_mem_writemem;
    wire    [31:0]    ex_mem_regb;
    wire              ex_mem_selwsource;
    wire    [4:0]     ex_mem_regdest;
    wire              ex_mem_writereg;
    wire    [31:0]    ex_mem_wbvalue;
    wire    [4:0]     mem_wb_regdest;
    wire              mem_wb_writereg;
    wire    [31:0]    mem_wb_wbvalue;
	 //wires do Decode para o Issue
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
	 
    wire    [4:0]     id_reg_addra;
    wire    [4:0]     id_reg_addrb;
    wire    [31:0]    reg_id_dataa;
    wire    [31:0]    reg_id_datab;
    wire    [31:0]    reg_id_ass_dataa;
    wire    [31:0]    reg_id_ass_datab;
    wire              wb_reg_en;
    wire    [4:0]     wb_reg_addr;
    wire    [31:0]    wb_reg_data;
	 // wires do Issue para o Execute
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
	 wire    [1:0]     numop;
	 

    Fetch FETCH(.clock(clock),.reset(reset),.is_if_stall(is_if_stall),.if_id_nextpc(if_id_nextpc),
                .if_id_instruc(if_id_instruc),.id_if_selpcsource(id_if_selpcsource),.id_if_rega(id_if_rega),
                .id_if_pcimd2ext(id_if_pcimd2ext),.id_if_pcindex(id_if_pcindex),.id_if_selpctype(id_if_selpctype));

    Memory MEMORY(.clock(clock),.reset(reset),.ex_mem_readmem(ex_mem_readmem),.ex_mem_writemem(ex_mem_writemem),
                  .ex_mem_regb(ex_mem_regb),.ex_mem_selwsource(ex_mem_selwsource),.ex_mem_regdest(ex_mem_regdest),
                  .ex_mem_writereg(ex_mem_writereg),.ex_mem_wbvalue(ex_mem_wbvalue),.mem_wb_regdest(mem_wb_regdest),
						.mem_wb_writereg(mem_wb_writereg),.mem_wb_wbvalue(mem_wb_wbvalue));

    Execute EXECUTE(.clock(clock),.reset(reset),.is_ex_selalushift(is_ex_selalushift),.is_ex_selimregb(is_ex_selimregb),
                    .is_ex_aluop(is_ex_aluop),.is_ex_unsig(is_ex_unsig),.is_ex_shiftop(is_ex_shiftop),
                    .is_ex_shiftamt(is_ex_shiftamt),.is_ex_rega(is_ex_rega),.is_ex_readmem(is_ex_readmem),
                    .is_ex_writemem(is_ex_writemem),.is_ex_regb(is_ex_regb),.is_ex_imedext(is_ex_imedext),
                    .is_ex_selwsource(is_ex_selwsource),.is_ex_regdest(is_ex_regdest),.is_ex_writereg(is_ex_writereg),
                    .is_ex_writeov(is_ex_writeov),.ex_if_stall(ex_if_stall),.ex_mem_readmem(ex_mem_readmem),
                    .ex_mem_writemem(ex_mem_writemem),.ex_mem_regb(ex_mem_regb),.ex_mem_selwsource(ex_mem_selwsource),
                    .ex_mem_regdest(ex_mem_regdest),.ex_mem_writereg(ex_mem_writereg),.ex_mem_wbvalue(ex_mem_wbvalue),
						  .is_ex_unidadefuncional(is_ex_unidadefuncional));
						  
	 Issue ISSUE(.clock(clock),.reset(reset),.id_is_selalushift(id_is_selalushift),.id_is_selimregb(id_is_selimregb),
                    .id_is_aluop(id_is_aluop),.id_is_unsig(id_is_unsig),.id_is_shiftop(id_is_shiftop),
                    .id_is_shiftamt(id_is_shiftamt),.id_is_rega(id_is_rega),.id_is_readmem(id_is_readmem),
                    .id_is_writemem(id_is_writemem),.id_is_regb(id_is_regb),.id_is_imedext(id_is_imedext),
                    .id_is_selwsource(id_is_selwsource),.id_is_regdest(id_is_regdest),.id_is_writereg(id_is_writereg),
                    .id_is_writeov(id_is_writeov),.execute_stall(is_if_stall),.is_if_stall(is_if_stall),
						  .is_ex_selalushift(is_ex_selalushift),.is_ex_selimregb(is_ex_selimregb),.is_ex_aluop(is_ex_aluop),
						  .is_ex_shiftamt(is_ex_shiftamt),.is_ex_rega(is_ex_rega),.is_ex_readmem(is_ex_readmem),
						  .is_ex_writemem(is_ex_writemem),.is_ex_regb(is_ex_regb),.is_ex_imedext(is_ex_imedext),
						  .is_ex_selwsource(is_ex_selwsource),.is_ex_regdest(is_ex_regdest),.is_ex_writereg(is_ex_writereg),
						  .is_ex_writeov(is_ex_writeov),.is_ex_unidadefuncional(is_ex_unidadefuncional),.is_ex_unsig(is_ex_unsig),
						  .is_ex_shiftop(is_ex_shiftop),.id_is_numop(numop),.id_is_addra(id_reg_addra),.id_is_addrb(id_reg_addrb));

    Decode DECODE(.clock(clock),.reset(reset),.if_id_instruc(if_id_instruc),.if_id_nextpc(if_id_nextpc),
                  .id_if_selpcsource(id_if_selpcsource),.id_if_rega(id_if_rega),.id_if_pcimd2ext(id_if_pcimd2ext),
                  .id_if_pcindex(id_if_pcindex),.id_if_selpctype(id_if_selpctype),.id_is_selalushift(id_is_selalushift),
                  .id_is_selimregb(id_is_selimregb),.id_is_aluop(id_is_aluop),.id_is_unsig(id_is_unsig),
                  .id_is_shiftop(id_is_shiftop),.id_is_shiftamt(id_is_shiftamt),.id_is_rega(id_is_rega),
                  .id_is_readmem(id_is_readmem),.id_is_writemem(id_is_writemem),.id_is_regb(id_is_regb),
                  .id_is_imedext(id_is_imedext),.id_is_selwsource(id_is_selwsource),.id_is_regdest(id_is_regdest),
                  .id_is_writereg(id_is_writereg),.id_is_writeov(id_is_writeov),.id_reg_addra(id_reg_addra),
                  .id_reg_addrb(id_reg_addrb),.reg_id_dataa(reg_id_dataa),.reg_id_datab(reg_id_datab),
                  .reg_id_ass_dataa(reg_id_ass_dataa),.reg_id_ass_datab(reg_id_ass_datab),.is_if_stall(is_if_stall),.id_is_numop(numop));

    Writeback WRITEBACK(.mem_wb_regdest(mem_wb_regdest),.mem_wb_writereg(mem_wb_writereg),.mem_wb_wbvalue(mem_wb_wbvalue),
                        .wb_reg_en(wb_reg_en),.wb_reg_addr(wb_reg_addr),.wb_reg_data(wb_reg_data));

    Registers REGISTERS(.clock(clock),.reset(reset),.addra(id_reg_addra),.dataa(reg_id_dataa),
                        .ass_dataa(reg_id_ass_dataa),.addrb(id_reg_addrb),.datab(reg_id_datab),
                        .ass_datab(reg_id_ass_datab),.enc(wb_reg_en),.addrc(wb_reg_addr),.datac(wb_reg_data),
						.regout(regout),.addrout(addrout));

endmodule
