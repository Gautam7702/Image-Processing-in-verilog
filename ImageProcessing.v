//  ********** MODULE TO READ THE IMAGE STARTS *********
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
);
integer fd;
initial fd = $fopen(INFILE,"rb"); //INFILE contains the hex values of inputted image

integer i = 0;
reg var = 1;
always@(posedge clk,!$feof(fd))
begin
        i = $fscanf(fd,"%h",R); // save Red component
        i = $fscanf(fd,"%h",G); // save Green component
        i = $fscanf(fd,"%h",B); // save Blue component
end
endmodule

//  ********** MODULE TO READ THE IMAGE ENDS *********


// ********** MODULE FOR THRESHOLD OPERTION STARTS***********//
module THRESHOLD #(    
    parameter HEIGHT1 = 768,
    WIDTH1 = 512,
    THRESHOLD= 90,
    INFILE1 =  "IM.hex"
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
        if((a+b+c)/3>THRESHOLD) 
        begin
            R = 255;
            G = 255;
            B = 255;
        end
        else begin
            R = 0;
            G = 0;
            B = 0;
        end
end
endmodule
// ********** MODULE FOR THRESHOLD OPERTION ENDS***********//


//  ********** MODULE TO CONVERT A PIXEL TO GRAYSCALE STARTS *********

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
    // average of the the rgb is taken
        R =  (a+b+c)/3; // save Red component
        G =  (a+b+c)/3; // save Green component
        B =  (a+b+c)/3; // save Blue component
end
endmodule

//  ********** MODULE TO CONVERT A PIXEL TO GRAYSCALE ENDS *********


//  ********** MODULE TO INVERT A PIXEL TO  STARTS *********
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

        R =  255-(a+b+c)/3; // save Red component
        G =  255-(a+b+c)/3; // save Green component
        B =  255-(a+b+c)/3; // save Blue component
end

endmodule

//  ********** MODULE TO INVERT A PIXEL ENDS *********


//  ********** MODULE TO INCREASE BRIGHTNESS OF A PIXEL STARTS *********
module IMAGE_BRIGHTNESS_INCREASE #(    
    parameter HEIGHT1 = 768,
    WIDTH1 = 512,
    INFILE1 =  "testimage.hex"
    ) (
    input clk,
    input wire[7:0] v,
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
        if(a + v <= a) B = 255; // save Red component
        else B = a + v; 
        if(b + v <= b) G = 255; // save Green component
        else G = b + v; 
        if(c + v <= c) R = 255; // save Blue component
        else R = c + v; 
end
endmodule
//  ********** MODULE TO INCREASE BRIGHTNESS OF A PIXEL ENDS *********



//  ********** MODULE TO DECREASE BRIGHTNESS OF A PIXEL STARTS *********

module IMAGE_BRIGHTNESS_DECREASE #(    
    parameter HEIGHT1 = 768,
    WIDTH1 = 512,
    // v = 100,
    INFILE1 =  "testimage.hex"
    ) (
    input clk,
    input wire[7:0] v,
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
        if(a - v <= 0 || a - v >= a) B = 0; // save Red component
        else B = a - v; 
        if(b - v <= 0 || b - v >= b) G = 0; // save Green component
        else G = b - v; 
        if(c - v <= 0 || c - v >= c) R = 0; // save Blue component
        else R = c - v; 
end
endmodule
//  ********** MODULE TO DECREASE BRIGHTNESS OF A PIXEL ENDS *********



//  ********** MODULE TO WRITE THE PIXEL INTO A HEX FILE  STARTS *********

module IMAGE_WRITE
#(
    parameter OUTFILE =  "output.hex",
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

integer fd;
initial begin
    fd = $fopen(OUTFILE,"wb");
end

always@(posedge clk,!$feof(fd))
begin

        #20 $fwrite(fd, "%x\n", B[7:0]);
        $fwrite(fd, "%x\n", G[7:0]);
        $fwrite(fd, "%x\n", R[7:0]);

end
endmodule

//  ********** MODULE TO WRITE THE PIXEL INTO A HEX FILE  ENDS *********
