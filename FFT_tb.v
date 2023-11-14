`timescale 1ns/1ps
module FFT_tb;
  parameter CLOCK_PERIOD = 100; // 10 MHz clock
  reg [15:0] In_real[7:0],In_imag[7:0];
  reg clk,reset;
  wire [15:0] Out_real[7:0],Out_imag[7:0];
wire fft_ready;

  FFT ff(.In_real(In_real),.In_imag(In_imag),.reset(reset),.clk(clk),.Out_real(Out_real),.Out_imag(Out_imag),.fft_ready(fft_ready));
initial begin
$dumpfile("dump.vcd"); 
$dumpvars;
end

initial begin
  clk=0;
  reset=0;
  In_real[0]=1; 
  In_real[1]=2; 
  In_real[2]=3; 
  In_real[3]=4; 
  In_real[4]=4; 
  In_real[5]=3; 
  In_real[6]=2; 
  In_real[7]=1;
  
  In_imag[0]=0;
  In_imag[1]=0;
  In_imag[2]=0;
  In_imag[3]=0;
  In_imag[4]=0;
  In_imag[5]=0;
  In_imag[6]=0;
  In_imag[7]=0;
  
 // #10 a=16'd0; b=16'd0; carry_in=1'd1;
// #10 a=-16'd15; b=16'd1; carry_in=1'd1;
 // #10 a=16'd5; b=16'd23; carry_in=1'd0;
 // #10 a=16'd999; b=16'd7; carry_in=1'd1;
end
  always begin
		#(CLOCK_PERIOD/2) clk = clk;
	end

  initial begin
    $monitor( "Out_real[0]=%d, Out_real[1]=%d, Out_real[2]= %d, Out_real[3]=%d, Out_real[4]=%d, Out_real[5]=%d, Out_real[6]=%d, Out_real[7]=%d, Out_imag[0]=%d, Out_imag[1]=%d, Out_imag[2]= %d, Out_imag[3]=%d, Out_imag[4]=%d, Out_imag[5]=%d, Out_imag[6]=%d, Out_imag[7]=%d", Out_real[0],Out_real[1],Out_real[2],Out_real[3],Out_real[4],Out_real[5],Out_real[6],Out_real[7],Out_imag[0],Out_imag[1],Out_imag[2],Out_imag[3],Out_imag[4],Out_imag[5],Out_imag[6],Out_imag[7]);
  end
endmodule
