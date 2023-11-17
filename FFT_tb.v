`timescale 1ns/1ps
module FFT_tb;
  parameter CLOCK_PERIOD = 10; // 10 MHz clock
  reg [15:0] In_real0,In_real1,In_real2,In_real3,In_real4,In_real5,In_real6,In_real7,In_imag0,In_imag1,In_imag2,In_imag3,In_imag4,In_imag5,In_imag6,In_imag7;
  reg clk,reset_n,write,start_fft;
  wire [15:0] Out_real0,Out_real1,Out_real2,Out_real3,Out_real4,Out_real5,Out_real6,Out_real7,Out_imag0,Out_imag1,Out_imag2,Out_imag3,Out_imag4,Out_imag5,Out_imag6,Out_imag7;
wire fft_ready;

  FFT ff(.In_real0(In_real0),.In_real1(In_real1),.In_real2(In_real2),.In_real3(In_real3),.In_real4(In_real4),.In_real5(In_real5),.In_real6(In_real6),.In_real7(In_real7),.In_imag0(In_imag0),.In_imag1(In_imag1),.In_imag2(In_imag2),.In_imag3(In_imag3),.In_imag4(In_imag4),.In_imag5(In_imag5),.In_imag6(In_imag6),.In_imag7(In_imag7),.reset_n(reset_n),.clk(clk),.write(write),.start_fft(start_fft),.Out_real0(Out_real0),.Out_real1(Out_real1),.Out_real2(Out_real2),.Out_real3(Out_real3),.Out_real4(Out_real4),.Out_real5(Out_real5),.Out_real6(Out_real6),.Out_real7(Out_real7),.Out_imag0(Out_imag0),.Out_imag1(Out_imag1),.Out_imag2(Out_imag2),.Out_imag3(Out_imag3),.Out_imag4(Out_imag4),.Out_imag5(Out_imag5),.Out_imag6(Out_imag6),.Out_imag7(Out_imag7),.fft_ready(fft_ready));
initial begin
$dumpfile("dump.vcd"); 
$dumpvars;
end

initial begin
  clk=0;
    start_fft=0;
  In_real0=50; 
  In_real1=50; 
  In_real2=50; 
  In_real3=50; 
  In_real4=00; 
  In_real5=00; 
  In_real6=00; 
  In_real7=00;
  
  In_imag0=0;
  In_imag1=0;
  In_imag2=0;
  In_imag3=0;
  In_imag4=0;
  In_imag5=0;
  In_imag6=0;
  In_imag7=0;
  
  write=0;
  start_fft=0;
  reset_n=0;
  #12 reset_n=1;
  write =1;
  #4 write=0;
  start_fft=1;

  
  #15 start_fft =0;
  
  #80 $finish(); 
  
 // #10 a=16'd0; b=16'd0; carry_in=1'd1;
// #10 a=-16'd15; b=16'd1; carry_in=1'd1;
 // #10 a=16'd5; b=16'd23; carry_in=1'd0;
 // #10 a=16'd999; b=16'd7; carry_in=1'd1;
end
  always begin
    #(CLOCK_PERIOD/2) clk = ~clk;
	end
    always@(*)
    begin
      $display("Out_real0 =%d,Out_imag0= %d ,Out_real1= %d,Out_imag1=%d,Out_real2 =%d,Out_imag2= %d ,Out_real3= %d,Out_imag3=%d, Out_real4 =%d,Out_imag4= %d ,Out_real5= %d,Out_imag5=%d,Out_real6 =%d,Out_imag6= %d ,Out_real7= %d,Out_imag7=%d,time =%0d", $signed(Out_real0),$signed(Out_imag0),$signed(Out_real1),$signed(Out_imag1),$signed(Out_real2),$signed(Out_imag2),$signed(Out_real3),$signed(Out_imag3),$signed(Out_real4),$signed(Out_imag4),$signed(Out_real5),$signed(Out_imag5),$signed(Out_real6),$signed(Out_imag6),$signed(Out_real7),$signed(Out_imag7),$time);
    end

endmodule
