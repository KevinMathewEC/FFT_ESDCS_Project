`timescale 1ns/1ps
module FFT_tb;
  parameter CLOCK_PERIOD = 10; // 10 MHz clock
  reg [15:0] in0_real,in1_real,in2_real,in3_real,in4_real,in5_real,in6_real,in7_real,in0_imag,in1_imag,in2_imag,in3_imag,in4_imag,in5_imag,in6_imag,in7_imag;
  reg CLK,RST_N,write,start;
  wire [15:0] out0_real,out1_real,out2_real,out3_real,out4_real,out5_real,out6_real,out7_real,out0_imag,out1_imag,out2_imag,out3_imag,out4_imag,out5_imag,out6_imag,out7_imag;
wire ready;

  FFT_wrapper ff(.in0_real(in0_real),.in1_real(in1_real),.in2_real(in2_real),.in3_real(in3_real),.in4_real(in4_real),.in5_real(in5_real),.in6_real(in6_real),.in7_real(in7_real),.in0_imag(in0_imag),.in1_imag(in1_imag),.in2_imag(in2_imag),.in3_imag(in3_imag),.in4_imag(in4_imag),.in5_imag(in5_imag),.in6_imag(in6_imag),.in7_imag(in7_imag),.RST_N(RST_N),.CLK(CLK),.write(write),.start(start),.out0_real(out0_real),.out1_real(out1_real),.out2_real(out2_real),.out3_real(out3_real),.out4_real(out4_real),.out5_real(out5_real),.out6_real(out6_real),.out7_real(out7_real),.out0_imag(out0_imag),.out1_imag(out1_imag),.out2_imag(out2_imag),.out3_imag(out3_imag),.out4_imag(out4_imag),.out5_imag(out5_imag),.out6_imag(out6_imag),.out7_imag(out7_imag),.ready(ready));
initial begin
$dumpfile("dump.vcd"); 
$dumpvars;
end

initial begin
  CLK=0;
  
  write=0;
  start=0;
  RST_N=0;
  #12 RST_N=1;
    in0_real=50; 
  in1_real=50; 
  in2_real=50; 
  in3_real=50; 
  in4_real=00; 
  in5_real=00; 
  in6_real=00; 
  in7_real=00;
  
  in0_imag=0;
  in1_imag=0;
  in2_imag=0;
  in3_imag=0;
  in4_imag=0;
  in5_imag=0;
  in6_imag=0;
  in7_imag=0;
  write =1;
  #4 write=0;
  #6 start=1;
    in0_real=100; 
  in1_real=200; 
  in2_real=300; 
  in3_real=400; 
  in4_real=400; 
  in5_real=300; 
  in6_real=200; 
  in7_real=100;
  
  in0_imag=0;
  in1_imag=0;
  in2_imag=0;
  in3_imag=0;
  in4_imag=0;
  in5_imag=0;
  in6_imag=0;
  in7_imag=0;  
     write=1;  
  #5 start =0;
  write=0;
  
  #6 start=1;
  #5 start=0;
  
  #80 $finish(); 
  
 // #10 a=16'd0; b=16'd0; carry_in=1'd1;
// #10 a=-16'd15; b=16'd1; carry_in=1'd1;
 // #10 a=16'd5; b=16'd23; carry_in=1'd0;
 // #10 a=16'd999; b=16'd7; carry_in=1'd1;
end
  always begin
    #(CLOCK_PERIOD/2) CLK = ~CLK;
	end
  always@(*)
    begin
      if(ready)
        begin
      $display("out0_real =%d,out0_imag= %d ,out1_real= %d,out1_imag=%d,out2_real =%d,out2_imag= %d ,out3_real= %d,out3_imag=%d, out4_real =%d,out4_imag= %d ,out5_real= %d,out5_imag=%d,out6_real =%d,out6_imag= %d ,out7_real= %d,out7_imag=%d,time =%0d", $signed(out0_real),$signed(out0_imag),$signed(out1_real),$signed(out1_imag),$signed(out2_real),$signed(out2_imag),$signed(out3_real),$signed(out3_imag),$signed(out4_real),$signed(out4_imag),$signed(out5_real),$signed(out5_imag),$signed(out6_real),$signed(out6_imag),$signed(out7_real),$signed(out7_imag),$time);
    end
    end

endmodule
