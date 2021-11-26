module IMAGE_READ 
#(
    parameter HEIGHT = 768,
    WIDTH = 512,
    INFILE =  "testimage.hex"
)
(
    input clk,
    output reg[7:0] R,
    output reg[7:0] G,
    output reg[7:0] B
    // output wire C
);
integer fd;
initial fd = $fopen(INFILE,"rb");
integer i = 0;
reg var = 1;
always@(posedge clk,!$feof(fd))
begin
        i = $fscanf(fd,"%h",R); // save Red component
        i = $fscanf(fd,"%h",G); // save Green component
        i = $fscanf(fd,"%h",B); // save Blue component
end
endmodule

module IMAGE_WRITE
#(
    parameter OUTFILE =  "output.bmp",
    HEIGHT = 768,
    WIDTH = 512,
    BMP_HEADER_NUM = 54	
)
(
    input clk,
    input [7:0] R,
    input [7:0] G,
    input [7:0] B
);
reg [7:0] BMP_header[0:53];
initial begin
BMP_header[ 0] = 66;BMP_header[28] =24; 
BMP_header[ 1] = 77;BMP_header[29] = 0; 
BMP_header[ 2] = 54;BMP_header[30] = 0; 
BMP_header[ 3] = 0;BMP_header[31] = 0;
BMP_header[ 4] = 18;BMP_header[32] = 0;
BMP_header[ 5] = 0;BMP_header[33] = 0; 
BMP_header[ 6] = 0;BMP_header[34] = 0; 
BMP_header[ 7] = 0;BMP_header[35] = 0; 
BMP_header[ 8] = 0;BMP_header[36] = 0;
BMP_header[ 9] = 0;BMP_header[37] = 0; 
BMP_header[10] = 54;BMP_header[38] = 0; 
BMP_header[11] = 0;BMP_header[39] = 0; 
BMP_header[12] = 0;BMP_header[40] = 0; 
BMP_header[13] = 0;BMP_header[41] = 0; 
BMP_header[14] = 40;BMP_header[42] = 0; 
BMP_header[15] = 0;BMP_header[43] = 0; 
BMP_header[16] = 0;BMP_header[44] = 0; 
BMP_header[17] = 0;BMP_header[45] = 0; 
BMP_header[18] = 0;BMP_header[46] = 0; 
BMP_header[19] = 3;BMP_header[47] = 0;
BMP_header[20] = 0;BMP_header[48] = 0;
BMP_header[21] = 0;BMP_header[49] = 0; 
BMP_header[22] = 0;BMP_header[50] = 0; 
BMP_header[23] = 2;BMP_header[51] = 0; 
BMP_header[24] = 0;BMP_header[52] = 0; 
BMP_header[25] = 0;BMP_header[53] = 0; 
BMP_header[26] = 1; BMP_header[27] = 0;
end
integer fd;
initial begin
    fd = $fopen(OUTFILE,"wb");
end
       integer  i;
       initial begin
       for(i=0; i<54; i=i+1) begin
            $fwrite(fd, "%c", BMP_header[i][7:0]); // write the header
        end
        end

always@(posedge clk,!$feof(fd))
begin
        $fwrite(fd, "%c", B[7:0]);
        $fwrite(fd, "%c", G[7:0]);
        $fwrite(fd, "%c", R[7:0]);
end
endmodule
 
module IMAGE_grayscale #(    
    parameter HEIGHT1 = 768,
    WIDTH1 = 512,
    INFILE1 =  "testimage.hex"
    ) (
    input clk,
    output reg[7:0] R,
    output reg[7:0] G,
    output reg[7:0] B
);
wire [7:0]a;
wire [7:0]b;
wire [7:0]c;
IMAGE_READ #(.HEIGHT(HEIGHT1),.WIDTH(WIDTH1),.INFILE(INFILE1)) a2(clk,a,b,c);
always@(posedge clk)
begin
        R =  (a+b+c)/3; 
        G =  (a+b+c)/3; 
        B =  (a+b+c)/3; 
end
endmodule



module IMAGE_invert #(
    parameter HEIGHT1 = 768,
    WIDTH1 = 512,
    INFILE1 =  "testimage.hex"
)(
    input clk,
    output reg[7:0] R,
    output reg[7:0] G,
    output reg[7:0] B
);
wire [7:0]a;
wire [7:0]b;
wire [7:0]c;
IMAGE_READ #(.HEIGHT(HEIGHT1),.WIDTH(WIDTH1),.INFILE(INFILE1)) a2(clk,a,b,c);
always@(posedge clk)
begin
        R =  255-(a+b+c)/3; 
        G =  255-(a+b+c)/3; 
        B =  255-(a+b+c)/3; 
end
endmodule
