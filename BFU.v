///////////////////////////////////////////////////////////
//Butterfly Unit 
///////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module BFU(A_real,A_imag,B_real,B_imag,sel_w,X0_real, X0_imag, X1_real, X1_imag);
  `include "complex_mult.v"
  `include "32_bit_adder.v"
  input signed[31:0] A_real,A_imag,B_real,B_imag;
  input [1:0]sel_w;
  output signed [31:0] X0_real, X0_imag, X1_real, X1_imag;
  wire [31:0] sum1,diff1,B_sum_prod,B_sum_prod_n,B_diff_prod;
  reg signed [31:0] B_real_0,B_imag_0,B_real_1,B_imag_1,Bxw_real,Bxw_imag,B_real_n;
  wire cout1,cout2,cout3,cout4;
 
  always@(B_real,B_imag,sel_w)
    begin //Decoder to direct B based on w (sel_w)
      case(sel_w)
        2'b00,2'b10 : 
          begin
          B_real_0 <= B_real;
          B_imag_0 <= B_imag;
          end
        2'b01,2'b11 : 
          begin
          B_real_1 <= B_real;
          B_imag_1 <= B_imag;
          end
         endcase
        end
  carry_look_ahead_32bit cla_bfu_1 (.a(B_real_1),.b(B_imag_1), .carry_in(1'b0), .sum(sum1),.cout(cout1));//b_real+b_imag
  
  carry_look_ahead_32bit cla_bfu_2 (.a(B_imag_1),.b(B_real_1), .carry_in(1'b1), .sum(diff1),.cout(cout2));//b_imag-b_real
  
  complex_mult cmult_1 (.multiplicant(sum1),.product(B_sum_prod));//0.707*(sum)
  
  complex_mult cmult_2 (.multiplicant(diff1),.product(B_diff_prod));//0.707*(diff)
  
  carry_look_ahead_32bit cla_bfu_3 (.a(32'b0),.b(B_sum_prod), .carry_in(1'b1), .sum(B_sum_prod_n),.cout(cout3));//-0.707*(sum)
  
  carry_look_ahead_32bit cla_bfu_4 (.a(32'b0),.b(B_real_0), .carry_in(1'b1), .sum(B_real_n),.cout(cout3));//-b_real
  
  always@(*)
    begin
     $display( "B_real_1 =%d, B_imag_1=%d ,B_real_0 =%d, B_imag_0=%d ", B_real_1,B_imag_1,B_real_0,B_imag_0);
      $display( "sum1 =%d, diff1=%d ,0.707*sum =%d, 0.707*diff=%d -b_real=%d", sum1,diff1,B_sum_prod,B_diff_prod,B_real_n);
   end
  
   always@(*)
     begin
       case(sel_w)
         2'b00:
           begin
             Bxw_real <= B_real_0;
             Bxw_imag <= B_imag_0;
           end
         2'b01:
           begin
             Bxw_real <= B_sum_prod;
             Bxw_imag <= B_diff_prod;
           end
         2'b10:
           begin
             Bxw_real <= B_imag_0;
             Bxw_imag  <= B_real_n;
           end
         2'b11:
           begin
             Bxw_real <= B_diff_prod;
             Bxw_imag <= B_sum_prod_n;
           end
       endcase
      end
  always@(*)
   begin
     $display( "Bxw_real =%d, Bxw_imag=%d ", Bxw_real,Bxw_imag);
   end
  
  carry_look_ahead_32bit cla_bfu_5 (.a(A_real),.b(Bxw_real), .carry_in(1'b0), .sum(X0_real),.cout());//A'_real
  carry_look_ahead_32bit cla_bfu_6 (.a(A_imag),.b(Bxw_imag), .carry_in(1'b0), .sum(X0_imag),.cout());//A'_imag
  carry_look_ahead_32bit cla_bfu_7 (.a(A_real),.b(Bxw_real), .carry_in(1'b1),.sum(X1_real),.cout());//B'_real
  carry_look_ahead_32bit cla_bfu_8 (.a(A_imag),.b(Bxw_imag), .carry_in(1'b1), .sum(X1_imag),.cout());//B'_imag
  
//  always@(*)
//   begin
//     $display( "A_real =%d, A_imag =%d ,A'_real =%d, A'_imag_0=%d ", A_real,A_imag,X0_real ,X0_imag);
//     $display( "B'_real =%d, B'_imag=%d ", X1_real, X1_imag);
//   end
  
endmodule


