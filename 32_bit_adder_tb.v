////Testbench
module carry_look_ahead_32bit_tb;
  reg [31:0] a,b;
reg carry_in;
  wire [31:0] sum;
wire cout;

  carry_look_ahead_32bit uut(.a(a), .b(b),.carry_in(carry_in),.sum(sum),.cout(cout));
initial begin
$dumpfile("dump.vcd"); 
$dumpvars;
end
initial begin
  a=0; b=0; carry_in=0;
  #10 a=32'd0; b=32'd0; carry_in=1'd1;
  #10 a=-32'd15; b=32'd1; carry_in=1'd1;
  #10 a=32'd5; b=32'd23; carry_in=1'd0;
  #10 a=32'd999; b=32'd7; carry_in=1'd1;
end

  initial begin
  $monitor( "A=%d, B=%d, carry_in= %d, Sum=%d, Cout=%d", a,b,carry_in,sum,cout);
  end
endmodule
