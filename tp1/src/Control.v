module Control (
    input     [5:0]    op,
    input     [5:0]    fn,
    output             selwsource,
    output             selregdest,
    output             writereg,
    output             writeov,
    output             selimregb,
    output             selalushift,
    output    [2:0]    aluop,
    output    [1:0]    shiftop,
    output             readmem,
    output             writemem,
    output    [1:0]    selbrjumpz,
    output    [1:0]    selpctype,
    output    [2:0]    compop,
    output             unsig,
	 output	  [1:0]	  numop, //número de operandos
	 output    [1:0]    fununit
);

    wire    [12:0]    sel;
    reg     [24:0]    out;//out original + 2 bits mais significativos denotando o número de operandos 
								  //             + 2 bits para identificar a unidade funcional 

    assign sel = {op,fn};

	 assign fununit = out[24:23];
	 assign numop = out[22:21];
    assign selimregb = out[20];
    assign selbrjumpz = out[19:18];
    assign selregdest = out[17];
    assign selwsource = out[16];
    assign writereg = out[15];
    assign writeov = out[14];
    assign unsig = out[13];
    assign shiftop = out[12:11];
    assign aluop = out[10:8];
    assign selalushift = out[7];
    assign compop = out[6:4];
    assign selpctype = out[3:2];
    assign readmem = out[1];
    assign writemem = out[0];

    always @(*) begin
        casex (sel) 
            12'b000000000100: out <= 25'b01_10_0001011X10XXX1XXXXX00;// SLLV
            12'b000000000110: out <= 25'b01_10_0001011X00XXX1XXXXX00;// SRLV
            12'b000000000111: out <= 25'b01_10_0001011X01XXX1XXXXX00;// SRAV
            12'b000000001000: out <= 25'b01_01_X01XX0XXXXXXXXXXX0100;// JR
            12'b000000100000: out <= 25'b01_10_00010100XX0100XXXXX00;// ADD
            12'b000000100001: out <= 25'b01_10_00010111XX0100XXXXX00;// ADDU
            12'b000000100010: out <= 25'b01_10_00010100XX1100XXXXX00;// SUB
            12'b000000100011: out <= 25'b01_10_00010111XX1100XXXXX00;// SUBU
            12'b000000100100: out <= 25'b01_10_0001011XXX0000XXXXX00;// AND
            12'b000000100101: out <= 25'b01_10_0001011XXX0010XXXXX00;// OR
            12'b000000100110: out <= 25'b01_10_0001011XXX1010XXXXX00;// XOR
            12'b000000100111: out <= 25'b01_10_0001011XXX1000XXXXX00;// NOR
				12'b000000011000: out <= 25'b11_10_00010100XX1110XXXXX00;// MULT
            12'b000010XXXXXX: out <= 25'b01_00_X01XX0XXXXXXXXXXX1000;// J
            12'b000100XXXXXX: out <= 25'b01_10_X10XX0X0XXXXXX0000000;// BEQ
            12'b000101XXXXXX: out <= 25'b01_10_X10XX0X0XXXXXX1010000;// BNE
            12'b000110XXXXXX: out <= 25'b01_01_X10XX0X0XXXXXX0100000;// BLEZ
            12'b000111XXXXXX: out <= 25'b01_01_X10XX0X0XXXXXX0110000;// BGTZ
            12'b001000XXXXXX: out <= 25'b01_01_10000100XX0100XXXXX00;// ADDI
            12'b001001XXXXXX: out <= 25'b01_01_10000111XX0100XXXXX00;// ADDIU
            12'b001100XXXXXX: out <= 25'b01_01_1000011XXX0000XXXXX00;// ANDI
            12'b001101XXXXXX: out <= 25'b01_01_1000011XXX0010XXXXX00;// ORI
            12'b001110XXXXXX: out <= 25'b01_01_1000011XXX1010XXXXX00;// XORI
            12'b100011XXXXXX: out <= 25'b10_01_10001110XX0100XXXXX10;// LW
            12'b101011XXXXXX: out <= 25'b10_01_100XX0X0XX0100XXXXX01;// SW
            default:          out <= 25'b01_00_000000000000000000000;// NOP
        endcase
    end

endmodule
