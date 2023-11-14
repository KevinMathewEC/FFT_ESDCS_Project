///////////////////////////////////////////////////////////
//FFT UNIT
///////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module FFT(In_real,In_imag,reset,clk,Out_real,Out_imag,fft_ready);
 `include "complex_mult.v"
 `include "16_bit_adder.v"
 `include "BFU.v"
  input signed [15:0]In_real[7:0],In_imag[7:0];
  input clk,reset;
  output fft_ready;
  output signed [15:0]Out_real[7:0],Out_imag[7:0];
  reg signed  [15:0]  stage1_op_real[7:0],stage1_op_imag[7:0],stage2_ip_real[7:0],stage2_ip_imag[7:0],stage2_op_real[7:0],stage2_op_imag[7:0],stage3_ip_real[7:0],stage3_ip_imag[7:0];
  
  
  // initially compute stage 1. stage 1 consists only of basic addition and subtraction. For subtraction, carry input should be 1
	 
	 //stage 1 output 1
  
  carry_look_ahead_16bit cla_bfu_1 (.a(In_real[0]),.b(In_real[4]), .carry_in(1'b0), .sum(stage1_op_real[0]),.cout()); //Real (x0+x4)
  carry_look_ahead_16bit cla_bfu_2 (.a(In_imag[0]),.b(In_imag[4]), .carry_in(1'b0), .sum(stage1_op_imag[0]),.cout()); //Imaginary (x0+x4)
	 
	 //stage 1 output 2
  carry_look_ahead_16bit cla_bfu_3 (.a(In_real[0]),.b(In_real[4]), .carry_in(1'b1), .sum(stage1_op_real[1]),.cout());// real(x0-x4)
  carry_look_ahead_16bit cla_bfu_4 (.a(In_imag[0]),.b(In_imag[4]), .carry_in(1'b1), .sum(stage1_op_imag[1]),.cout());// Imaginary (x0-x4)
	 
	 
	 //stage 1 output 3
  carry_look_ahead_16bit cla_bfu_5 (.a(In_real[2]),.b(In_real[6]), .carry_in(1'b0), .sum(stage1_op_real[2]),.cout()); //Real (x2+x6)
  carry_look_ahead_16bit cla_bfu_6 (.a(In_imag[2]),.b(In_imag[6]), .carry_in(1'b0), .sum(stage1_op_imag[2]),.cout()); //Imaginary (x2+x6)
	 
	 //stage 1 output 4
  carry_look_ahead_16bit cla_bfu_7 (.a(In_real[2]),.b(In_real[6]), .carry_in(1'b1), .sum(stage1_op_real[3]),.cout());// real(x2-x6)
  carry_look_ahead_16bit cla_bfu_8 (.a(In_imag[2]),.b(In_imag[6]), .carry_in(1'b1), .sum(stage1_op_imag[3]),.cout());// Imaginary (x2-x6)
	 
	 //stage 1 output 5
  carry_look_ahead_16bit cla_bfu_9 (.a(In_real[1]),.b(In_real[5]), .carry_in(1'b0), .sum(stage1_op_real[4]),.cout()); //Real (x1+x5)
  carry_look_ahead_16bit cla_bfu_10 (.a(In_imag[1]),.b(In_imag[5]), .carry_in(1'b0), .sum(stage1_op_imag[4]),.cout()); //Imaginary (x1+x5)
	 
	 //stage 1 output 6
  carry_look_ahead_16bit cla_bfu_11 (.a(In_real[1]),.b(In_real[5]), .carry_in(1'b1), .sum(stage1_op_real[5]),.cout());// real(x1-x5)
  carry_look_ahead_16bit cla_bfu_12 (.a(In_imag[1]),.b(In_imag[5]), .carry_in(1'b1), .sum(stage1_op_imag[5]),.cout());// Imaginary (x1-x5)
	  
	 //stage 1 output 7
  carry_look_ahead_16bit cla_bfu_13 (.a(In_real[3]),.b(In_real[7]), .carry_in(1'b0), .sum(stage1_op_real[6]),.cout()); //Real (x3+x7)
  carry_look_ahead_16bit cla_bfu_14 (.a(In_imag[3]),.b(In_imag[7]), .carry_in(1'b0), .sum(stage1_op_imag[6]),.cout()); //Imaginary (x3+x7)
	 
	 //stage 1 output 8
  carry_look_ahead_16bit cla_bfu_15 (.a(In_real[3]),.b(In_real[7]), .carry_in(1'b1), .sum(stage1_op_real[7]),.cout());// real(x3-x7)
  carry_look_ahead_16bit cla_bfu_16 (.a(In_imag[3]),.b(In_imag[7]), .carry_in(1'b1), .sum(stage1_op_imag[7]),.cout());// Imaginary (x3-x7) 

	  always@(posedge clk or negedge reset)
    begin
      if(reset)
        begin
        stage2_ip_real[0]<=16'b0;
        stage2_ip_imag[0]<=16'b0;
        stage2_ip_real[1]<=16'b0;
        stage2_ip_imag[1]<=16'b0;
      	stage2_ip_real[2]<=16'b0;
      	stage2_ip_imag[2]<=16'b0;
      	stage2_ip_real[3]<=16'b0;
      	stage2_ip_imag[3]<=16'b0;
      	stage2_ip_real[4]<=16'b0;
      	stage2_ip_imag[4]<=16'b0;
      	stage2_ip_real[5]<=16'b0;
      	stage2_ip_imag[5]<=16'b0;
      	stage2_ip_real[6]<=16'b0;
      	stage2_ip_imag[6]<=16'b0;
      	stage2_ip_real[7]<=16'b0;
        stage2_ip_imag[8]<=16'b0;
        end
       else
         begin
           stage2_ip_real[0]<=stage1_op_real[0];
           stage2_ip_imag[0]<=stage1_op_imag[0];
           stage2_ip_real[1]<=stage1_op_real[4];
           stage2_ip_imag[1]<=stage1_op_imag[4];
           stage2_ip_real[2]<=stage1_op_real[2];
           stage2_ip_imag[2]<=stage1_op_imag[2];
           stage2_ip_real[3]<=stage1_op_real[6];
           stage2_ip_imag[3]<=stage1_op_imag[6];
           stage2_ip_real[4]<=stage1_op_real[1];
           stage2_ip_imag[4]<=stage1_op_imag[1];
           stage2_ip_real[5]<=stage1_op_real[5];
           stage2_ip_imag[5]<=stage1_op_imag[5];
           stage2_ip_real[6]<=stage1_op_real[3];
           stage2_ip_imag[6]<=stage1_op_imag[3];
           stage2_ip_real[7]<=stage1_op_real[7];
           stage2_ip_imag[7]<=stage1_op_imag[7];
           
         end
          
    end
	
	//stage 2 computation.
	
	
	//stage 2 output 1
  carry_look_ahead_16bit cla_bfu_17 (.a(stage2_ip_real[0]),.b(stage2_ip_real[2]), .carry_in(1'b0), .sum(stage2_op_real[0]),.cout()); // real (stage 1 op1 + stage 1 op3)
  carry_look_ahead_16bit cla_bfu_18 (.a(stage2_ip_imag[0]),.b(stage2_ip_imag[2]), .carry_in(1'b0), .sum(stage2_op_imag[0]),.cout()); // imag (stage 1 op1 + stage 1 op3)
	 
	 //stage 2 output 3
  carry_look_ahead_16bit cla_bfu_19 (.a(stage2_ip_real[0]),.b(stage2_ip_real[2]), .carry_in(1'b1), .sum(stage2_op_real[2]),.cout()); // real (stage 1 op1 - stage 1 op3)
  carry_look_ahead_16bit cla_bfu_20 (.a(stage2_ip_imag[0]),.b(stage2_ip_imag[2]), .carry_in(1'b1), .sum(stage2_op_imag[2]),.cout()); // imag (stage 1 op1 - stage 1 op3)

	//stage 2 output 2 and 4
	
  BFU bf1 (.A_real(stage2_ip_real[1]),.A_imag(stage2_ip_imag[1]),.B_real(stage2_ip_real[3]),.B_imag(stage2_ip_imag[3]),.sel_w(2'b10),.X0_real(stage2_op_real[1]), 
           .X0_imag(stage2_op_imag[1]), .X1_real(stage2_op_real[3]), .X1_imag(stage2_op_imag[3])); // 10 is selected for sel_w as w^2 is the twiddle factor
	 
	 // stage 2 output 5 and 7
	 
	//stage 2 output 5
  carry_look_ahead_16bit cla_bfu_21 (.a(stage2_ip_real[4]),.b(stage2_ip_real[6]), .carry_in(1'b0), .sum(stage2_op_real[4]),.cout()); // real (stage 1 op5 + stage 1 op7)
  carry_look_ahead_16bit cla_bfu_22 (.a(stage2_ip_imag[4]),.b(stage2_ip_imag[6]), .carry_in(1'b0), .sum(stage2_op_imag[4]),.cout()); // imag (stage 1 op5 + stage 1 op7)
	 
	 //stage 2 output 7
  carry_look_ahead_16bit cla_bfu_23 (.a(stage2_ip_real[4]),.b(stage2_ip_real[6]), .carry_in(1'b1), .sum(stage2_op_real[6]),.cout()); // real (stage 1 op5 - stage 1 op7)
  carry_look_ahead_16bit cla_bfu_24 (.a(stage2_ip_imag[4]),.b(stage2_ip_imag[6]), .carry_in(1'b1), .sum(stage2_op_imag[6]),.cout()); // imag (stage 1 op5 - stage 1 op7)
	
	//stage 2 output 6 and 8
	
  BFU bf2 (.A_real(stage2_ip_real[5]),.A_imag(stage2_ip_imag[5]),.B_real(stage2_ip_real[7]),.B_imag(stage2_ip_imag[7]),.sel_w(2'b10),.X0_real(stage2_op_real[5])
           , .X0_imag(stage2_op_imag[5]), .X1_real(stage2_op_real[7]), .X1_imag(stage2_op_imag[7])); // 10 is selected for sel_w as w^2 is the twiddle factor
  
  //
  always@(posedge clk or negedge reset)
    begin
      if(reset)
        begin
        stage3_ip_real[0]<=16'b0;
        stage3_ip_imag[0]<=16'b0;
        stage3_ip_real[1]<=16'b0;
        stage3_ip_imag[1]<=16'b0;
      	stage3_ip_real[2]<=16'b0;
      	stage2_ip_imag[2]<=16'b0;
      	stage2_ip_real[3]<=16'b0;
      	stage3_ip_imag[3]<=16'b0;
      	stage3_ip_real[4]<=16'b0;
      	stage3_ip_imag[4]<=16'b0;
      	stage3_ip_real[5]<=16'b0;
      	stage3_ip_imag[5]<=16'b0;
      	stage3_ip_real[6]<=16'b0;
      	stage3_ip_imag[6]<=16'b0;
      	stage3_ip_real[7]<=16'b0;
        stage3_ip_imag[8]<=16'b0;
        end
       else
         begin
           stage3_ip_real[0]<=stage2_op_real[0];
           stage3_ip_imag[0]<=stage2_op_imag[0];
           stage3_ip_real[1]<=stage2_op_real[4];
           stage3_ip_imag[1]<=stage2_op_imag[4];
           stage3_ip_real[2]<=stage2_op_real[2];
           stage3_ip_imag[2]<=stage2_op_imag[2];
           stage3_ip_real[3]<=stage2_op_real[6];
           stage3_ip_imag[3]<=stage2_op_imag[6];
           stage3_ip_real[4]<=stage2_op_real[1];
           stage3_ip_imag[4]<=stage2_op_imag[1];
           stage3_ip_real[5]<=stage2_op_real[5];
           stage3_ip_imag[5]<=stage2_op_imag[5];
           stage3_ip_real[6]<=stage2_op_real[3];
           stage3_ip_imag[6]<=stage2_op_imag[3];
           stage3_ip_real[7]<=stage2_op_real[7];
           stage3_ip_imag[7]<=stage2_op_imag[7];
           
         end
    end
  
  	//stage 3 computation.
	
		//stage 3 output 1 X0
  carry_look_ahead_16bit cla_bfu_25 (.a(stage3_ip_real[0]),.b(stage3_ip_real[4]), .carry_in(1'b0), .sum(Out_real[0]),.cout()); // real (stage 2 op1 + stage 2 op5)
  carry_look_ahead_16bit cla_bfu_26 (.a(stage3_ip_imag[0]),.b(stage3_ip_imag[4]), .carry_in(1'b0), .sum(Out_imag[0]),.cout()); // imag (stage 2 op1 + stage 2 op5)
	 
	 	//stage 3 output 5 X4
  carry_look_ahead_16bit cla_bfu_27 (.a(stage3_ip_real[3]),.b(stage3_ip_real[4]), .carry_in(1'b1), .sum(Out_real[4]),.cout()); // real (stage 2 op1 + stage 2 op5)
  carry_look_ahead_16bit cla_bfu_28 (.a(stage3_ip_imag[3]),.b(stage3_ip_imag[4]), .carry_in(1'b1), .sum(Out_imag[4]),.cout()); // imag (stage 2 op1 + stage 2 op5)
	 
	  // stage 3 output 2 == X1 and output 6== X5
  BFU bf3 (.A_real(stage3_ip_real[1]),.A_imag(stage3_ip_imag[1]),.B_real(stage3_ip_real[5]),.B_imag(stage3_ip_real[5]),.sel_w(2'b01),.X0_real(Out_real[1])
           , .X0_imag(Out_imag[1]), .X1_real(Out_real[5]), .X1_imag(Out_imag[5])); // 01 is selected for sel_w as w is the twiddle factor
	 
	 //stage 3 output 3==X2 and OUTPUT 7 ==X6
	
  BFU bf4 (.A_real(stage3_ip_real[2]),.A_imag(stage3_ip_imag[2]),.B_real(stage3_ip_real[6]),.B_imag(stage3_ip_imag[6]),.sel_w(2'b10),.X0_real(Out_real[2])
           , .X0_imag(Out_imag[2]), .X1_real(Out_real[6]), .X1_imag(Out_imag[6])); // 10 is selected for sel_w as w^2 is the twiddle factor
	
	//stage 3 output 4==X3 and OUTPUT 8 ==X7
	
  BFU bf5 (.A_real(stage3_ip_real[3]),.A_imag(stage3_ip_imag[3]),.B_real(stage3_ip_real[7]),.B_imag(stage3_ip_imag[7]),.sel_w(2'b11),.X0_real(Out_real[3])
           , .X0_imag(Out_imag[3]), .X1_real(Out_real[7]), .X1_imag(Out_imag[7])); // 11 is selected for sel_w as w^3 is the twiddle factor
  
  
endmodule
