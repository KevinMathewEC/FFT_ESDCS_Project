////Testbench
module BFU_tb;
  reg signed[31:0] A_real,A_imag,B_real,B_imag;
  reg [1:0]sel_w;
  wire [31:0] X0_real,
  X0_imag, X1_real, X1_imag;
  
  reg [31:0] test;

  BFU bf1 (.A_real(A_real),.A_imag(A_imag),.B_real(B_real),.B_imag(B_imag),.sel_w(sel_w),.X0_real(X0_real), .X0_imag(X0_imag), .X1_real(X1_real), .X1_imag(X1_imag));

initial begin
$dumpfile("dump.vcd"); 
$dumpvars;
end
initial begin

  A_real=-32'd300;
  A_imag=32'd0;
  B_real=32'd100;
  B_imag=32'd0;
  sel_w=2'b10;
  test=-32'd300;
  #10   A_real=32'd200;
  A_imag=32'd0;
  B_real=32'd300;
  B_imag=32'd0;
  sel_w=2'b00;
  test=-32'd100;
 // #10 multiplicant=32'd100;
end

  initial begin
    $monitor( "X0_real=%d, X0_imag=%d, X1_real=%d, X1_imag=%d ,test=%d",X0_real,X0_imag,X1_real,X1_imag,test);
  end
endmodule
