`timescale 1ns/1ps
`include "ImageProcessing.v"
module ImageProcessing_tb;
    reg clk;
    wire[7:0] R;
    wire[7:0] G;
    wire[7:0] B;
    integer C= 0;
    initial clk =1'b0;
    always begin 
        #10 clk = ~clk;
    end
    initial begin #7864320 $finish;
    end
    /*IMAGE_invert #(.HEIGHT1(768),.WIDTH1(512),.INFILE1("testimage.hex")) M1(
        .clk(clk),
        .R(R),
        .G(G),
        .B(B)
    );*/
    IMAGE_grayscale #(.HEIGHT1(768),.WIDTH1(512),.INFILE1("testimage.hex")) M1(
        .clk(clk),
        .R(R),
        .G(G),
        .B(B)
    );
    IMAGE_WRITE #(.OUTFILE("output.bmp"),.HEIGHT(768),.WIDTH(512),.BMP_HEADER_NUM(54)) M2(
        .clk(clk),
        .R(R),
        .G(G),
        .B(B)
    );
        
endmodule
