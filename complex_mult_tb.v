////Testbench
module comp_mult_tb;
  reg [31:0] multiplicant;
  wire [31:0] product;


  complex_mult uut(.multiplicant(multiplicant),.product(product));
initial begin
$dumpfile("dump.vcd"); 
$dumpvars;
end
initial begin
  multiplicant=32'd1200;
  #10 multiplicant=32'd4500;
  #10 multiplicant=32'd100;
end

  initial begin
    $monitor( "multiplicant=%d, product=%d", multiplicant,product);
  end
endmodule
