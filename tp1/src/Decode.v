module Decode (
    input                   clock,
    input                   reset,
	 // Issue
	 input 						 is_if_stall,
    //Fetch
    input         [31:0]    if_id_instruc,
    input         [31:0]    if_id_nextpc,
    output reg              id_if_selpcsource,
    output        [31:0]    id_if_rega,
    output        [31:0]    id_if_pcimd2ext,
    output        [31:0]    id_if_pcindex,
    output        [1:0]     id_if_selpctype,
    //Issue
    output reg              id_is_selalushift,
    output reg              id_is_selimregb,
    output reg    [2:0]     id_is_aluop,
    output reg              id_is_unsig,
    output reg    [1:0]     id_is_shiftop,
    output        [4:0]     id_is_shiftamt,
    output        [31:0]    id_is_rega,
    output reg              id_is_readmem,
    output reg              id_is_writemem,
    output        [31:0]    id_is_regb,
    output reg    [31:0]    id_is_imedext,
    output reg              id_is_selwsource,
    output reg    [4:0]     id_is_regdest,
    output reg              id_is_writereg,
    output reg              id_is_writeov,
	 output reg       [1:0]  id_is_numop,
	 output reg		   [31:0] id_is_addra,
	 output reg		   [31:0] id_is_addrb,
    //Registers
    output        [4:0]     id_reg_addra,
    output        [4:0]     id_reg_addrb,
    input         [31:0]    reg_id_dataa,
    input         [31:0]    reg_id_datab,
    input         [31:0]    reg_id_ass_dataa,
    input         [31:0]    reg_id_ass_datab
);

    wire    [1:0]    selbrjumpz;
    wire             compout;
    wire    [1:0]    selpctype;
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
    wire    [2:0]    compop;
	 wire    [1:0]    numop;

    assign id_if_selpctype = selpctype;
    assign id_if_pcindex = {if_id_nextpc[31:28],if_id_instruc[25:0]};
    assign id_if_pcimd2ext = if_id_nextpc + $signed({{16{if_id_instruc[15]}},if_id_instruc[15:0]});

    Comparator COMPARATOR(.a(reg_id_ass_dataa),.b(reg_id_ass_datab),.op(compop),.compout(compout));
    Control CONTROL(.op(if_id_instruc[31:26]),.fn(if_id_instruc[5:0]),
                    .selwsource(selwsource),.selregdest(selregdest),.writereg(writereg),
                    .writeov(writeov),.selimregb(selimregb),.selalushift(selalushift),
                    .aluop(aluop),.shiftop(shiftop),.readmem(readmem),.writemem(writemem),
                    .selbrjumpz(selbrjumpz),.selpctype(selpctype),.compop(compop),
                    .unsig(unsig),.numop(numop));

    always @(*) begin
        case (selbrjumpz)
            2'b00:   id_if_selpcsource <= 1'b0;
            2'b01:   id_if_selpcsource <= 1'b1;
            2'b10:   id_if_selpcsource <= compout;
            2'b11:   id_if_selpcsource <= 1'b0;
            default: id_if_selpcsource <= 1'b0;
        endcase
    end

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
            end else if( !is_if_stall ) begin
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
            end
	 end 

endmodule
