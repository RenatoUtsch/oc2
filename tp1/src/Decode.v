module Decode (
    input                   clock,
    input                   reset,
	 // Issue
	 input 						 is_if_stall,
    //Fetch
    input         [31:0]    if_id_instruc,
	 input			[31:0]	 if_id_nextpc,
    //Issue
	 output reg		[31:0]	 id_is_instruc,
	 output reg		[31:0]	 id_is_nextpc,
    output reg              id_is_selalushift,
    output reg              id_is_selimregb,
    output reg    [2:0]     id_is_aluop,
    output reg              id_is_unsig,
    output reg    [1:0]     id_is_shiftop,
    output reg              id_is_readmem,
    output reg              id_is_writemem,
    output reg    [31:0]    id_is_imedext,
    output reg              id_is_selwsource,
    output reg    [4:0]     id_is_regdest,
    output reg              id_is_writereg,
    output reg              id_is_writeov,
	 output reg    [1:0]		 id_is_numop,
	 output reg		[1:0]  	 id_is_fununit,
	 output reg		[31:0] 	 id_is_addra,
	 output reg		[31:0] 	 id_is_addrb,
	 output reg    [1:0]  	 id_is_selpctype,
	 output reg 	[1:0]  	 id_is_selbrjumpz,
	 output reg		[2:0]		 id_is_compop
);

    
    wire             selalushift;
    wire             selimregb;
    wire    [2:0]    aluop;
    wire             unsig;
    wire    [1:0]    shiftop;
    wire             readmem;
    wire             writemem;
    wire             selwsource;
    wire             selregdest;
    wire             writereg;
    wire             writeov;
	 wire    [1:0]    numop;
	 wire 	[1:0] 	fununit;
	 wire 	[2:0]		compop;

	 wire 	[1:0]    selpctype;
	 wire 	[1:0]		selbrjumpz;
	 
    Control CONTROL(.op(if_id_instruc[31:26]),.fn(if_id_instruc[5:0]),
                    .selwsource(selwsource),.selregdest(selregdest),.writereg(writereg),
                    .writeov(writeov),.selimregb(selimregb),.selalushift(selalushift),
                    .aluop(aluop),.shiftop(shiftop),.readmem(readmem),.writemem(writemem),
                    .selbrjumpz(selbrjumpz),.selpctype(selpctype),.compop(compop),
                    .unsig(unsig),.numop(numop),.fununit(fununit));

    always @(posedge clock or negedge reset) begin
			   if (~reset) begin
               id_is_selalushift <= 1'b0;
               id_is_selimregb <= 1'b0;
               id_is_aluop <= 3'b000;
               id_is_unsig <= 1'b0;
               id_is_shiftop <= 2'b00;
               id_is_readmem <= 1'b0;
               id_is_writemem <= 1'b0;
               id_is_selwsource <= 1'b0;
               id_is_regdest <= 5'b00000;
               id_is_writereg <= 1'b0;
               id_is_writeov <= 1'b0;
               id_is_imedext <= 32'h0000_0000;
					id_is_numop <= 2'b00;
					id_is_fununit <= 2'b00;
					id_is_addra <= 32'h0000_0000;
					id_is_addrb <= 32'h0000_0000;
					id_is_instruc <= 32'h0000_0000;
					id_is_nextpc <= 32'h0000_0000;
					id_is_compop <= 3'b000;
				   id_is_selpctype <= 2'b00;
				   id_is_selbrjumpz <= 2'b00;
            end else if(!is_if_stall) begin
               id_is_selalushift <= selalushift;
               id_is_selimregb <= selimregb;
               id_is_aluop <= aluop;
               id_is_unsig <= unsig;
               id_is_shiftop <= shiftop;
               id_is_readmem <= readmem;
               id_is_writemem <= writemem;
               id_is_selwsource <= selwsource;
               id_is_regdest <= (selregdest) ? if_id_instruc[15:11] : if_id_instruc[20:16];
               id_is_writereg <= writereg;
               id_is_writeov <= writeov;
               id_is_imedext <= $signed(if_id_instruc[15:0]);
					id_is_addra <= if_id_instruc[25:21];
					id_is_addrb <= if_id_instruc[20:16];
					id_is_numop <= numop;
					id_is_fununit <= fununit;
					id_is_instruc <= if_id_instruc;
					id_is_nextpc <= if_id_nextpc;
					id_is_compop <= compop;
					id_is_selpctype <= selpctype;
					id_is_selbrjumpz <= selbrjumpz;
            end		
	 end 

endmodule
