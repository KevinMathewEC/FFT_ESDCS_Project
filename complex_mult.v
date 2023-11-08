 ///////////////////////////////////////////////////////////
//Complex multiplier
//////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module complex_mult(multiplicant,product);
`include "32_bit_adder.v"
  input signed [31:0]multiplicant;
  output signed [31:0]product;
  wire [31:0]sum1,sum2,sum3,sum4,sum5;
  wire cout1,cout2,cout3,cout4,cout5;
  
  carry_look_ahead_32bit cla_32_1 (.a({multiplicant[31],multiplicant[31:1]}),.b({multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31:3]}), .carry_in(1'b0), .sum(sum1),.cout(cout1));
  
  carry_look_ahead_32bit cla_32_2 (.a({multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31:4]}),.b({multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31:6]}), .carry_in(1'b0), .sum(sum2),.cout(cout2));
  
    carry_look_ahead_32bit cla_32_3 (.a({multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31:8]}),.b({multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31],multiplicant[31:10]}), .carry_in(1'b0), .sum(sum3),.cout(cout3));
                                                                                      carry_look_ahead_32bit cla_32_4 (.a(sum1),.b(sum2), .carry_in(1'b0), .sum(sum4),.cout(cout4));
  carry_look_ahead_32bit cla_32_5 (.a(sum3),.b(sum4), .carry_in(1'b0), .sum(sum5),.cout(cout5));
  
  assign product=sum5;
  
endmodule
