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
    output	  [1:0]	  numop//número de operandos
);

    wire    [12:0]    sel;
    reg     [22:0]    out;//out original+2 bits mais significativos denotando o número de operandos

    assign sel = {op,fn};

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
            12'b000000000100: out <= 23'b100001011X10XXX1XXXXX00;
            12'b000000000110: out <= 23'b100001011X00XXX1XXXXX00;
            12'b000000000111: out <= 23'b100001011X01XXX1XXXXX00;
            12'b000000001000: out <= 23'b10X01XX0XXXXXXXXXXX0100;
            12'b000000100000: out <= 23'b1000010100XX0100XXXXX00;
            12'b000000100001: out <= 23'b1000010111XX0100XXXXX00;
            12'b000000100010: out <= 23'b1000010100XX1100XXXXX00;
            12'b000000100011: out <= 23'b1000010111XX1100XXXXX00;
            12'b000000100100: out <= 23'b100001011XXX0000XXXXX00;
            12'b000000100101: out <= 23'b100001011XXX0010XXXXX00;
            12'b000000100110: out <= 23'b100001011XXX1010XXXXX00;
            12'b000000100111: out <= 23'b100001011XXX1000XXXXX00;
            12'b000010XXXXXX: out <= 23'b00X01XX0XXXXXXXXXXX1000;
            12'b000100XXXXXX: out <= 23'b10X10XX0X0XXXXXX0000000;
            12'b000101XXXXXX: out <= 23'b10X10XX0X0XXXXXX1010000;
            12'b000110XXXXXX: out <= 23'b01X10XX0X0XXXXXX0100000;
            12'b000111XXXXXX: out <= 23'b01X10XX0X0XXXXXX0110000;
            12'b001000XXXXXX: out <= 23'b0110000100XX0100XXXXX00;
            12'b001001XXXXXX: out <= 23'b0110000111XX0100XXXXX00;
            12'b001100XXXXXX: out <= 23'b011000011XXX0000XXXXX00;
            12'b001101XXXXXX: out <= 23'b011000011XXX0010XXXXX00;
            12'b001110XXXXXX: out <= 23'b011000011XXX1010XXXXX00;
            12'b000000011000: out <= 23'b1000010100XX1110XXXXX00;		// nova instrução
            12'b100011XXXXXX: out <= 23'b0110001110XX0100XXXXX10;
            12'b101011XXXXXX: out <= 23'b01100XX0X0XX0100XXXXX01;
            default:          out <= 23'b00000000000000000000000;
        endcase
    end

endmodule
