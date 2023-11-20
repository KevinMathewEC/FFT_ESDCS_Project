///////////////////////////////////////////////////////////

//16-bit Carry Look Ahead Adder 

///////////////////////////////////////////////////////////



`timescale 1ns / 1ps

module carry_look_ahead_16bit(a,b, carry_in, sum,cout);

  input signed[15:0] a,b;

input carry_in;

output signed[15:0] sum;

output cout;

wire c1,c2,c3,c4,c5,c6,c7;

  wire [15:0] b_int;

  wire [6:0]p;

  wire c1_p,c2_p,c3_p,c4_p,c5_p,c6_p,c7_p;



  assign b_int = (b ^ {16{carry_in}});// negate b for subtraction unless b=16'b0

  carry_look_ahead_4bit cla1 (.a(a[3:0]), .b(b_int[3:0]), .cin((carry_in)), .sum(sum[3:0]), .cout(c1),.p0p1p2p3(p[0]));

  

  assign c1_p = (p[0] & carry_in) || ((!p[0]) & c1);//mux for carry propogation

  carry_look_ahead_4bit cla2 (.a(a[7:4]), .b(b_int[7:4]), .cin(c1_p), .sum(sum[7:4]), .cout(c2),.p0p1p2p3(p[1]));

  

  assign c2_p = (p[1] & c1) || ((~p[1])&c2);

  carry_look_ahead_4bit cla3(.a(a[11:8]), .b(b_int[11:8]), .cin(c2_p), .sum(sum[11:8]), .cout(c3),.p0p1p2p3(p[2]));

  

  assign c3_p = (p[2] & c2) || ((~p[2])&c3);

  carry_look_ahead_4bit cla4(.a(a[15:12]), .b(b_int[15:12]), .cin(c3_p), .sum(sum[15:12]), .cout(c4),.p0p1p2p3(p[3]));



endmodule  

////////////////////////////////////////////////////////

//4-bit Carry Look Ahead Adder 

////////////////////////////////////////////////////////



module carry_look_ahead_4bit(a,b, cin, sum,cout,p0p1p2p3);

input [3:0] a,b;

input cin;

output [3:0] sum;

output cout;

  output p0p1p2p3;

  wire [3:0] p,g,c;



assign p=a^b;//propagate

assign g=a&b; //generate



//carry=gi + Pi.ci



assign c[0]=cin;

assign c[1]= g[0]|(p[0]&c[0]);

assign c[2]= g[1] | (p[1]&g[0]) | p[1]&p[0]&c[0];

assign c[3]= g[2] | (p[2]&g[1]) | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&c[0];

assign cout= g[3] | (p[3]&g[2]) | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0] | p[3]&p[2]&p[1]&p[0]&c[0];

assign sum=p^c;

  assign p0p1p2p3=p[0]&p[1]&p[2]&p[3];



endmodule



///////////////////////////////////////////////////////////

//Complex multiplier

//////////////////////////////////////////////////////////

//`timescale 1ns / 1ps

module complex_mult(multiplicant,product);

//`include "16_bit_adder.v"

  input signed [15:0]multiplicant;

  output signed [15:0]product;

  wire [15:0]sum1,sum2,sum3,sum4,sum5;

  wire cout1,cout2,cout3,cout4,cout5;

  

  carry_look_ahead_16bit cla_16_1 (.a({multiplicant[15],multiplicant[15:1]}),.b({multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15:3]}), .carry_in(1'b0), .sum(sum1),.cout(cout1));

  

  carry_look_ahead_16bit cla_16_2 (.a({multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15:4]}),.b({multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15:6]}), .carry_in(1'b0), .sum(sum2),.cout(cout2));

  

    carry_look_ahead_16bit cla_16_3 (.a({multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15:8]}),.b({multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15],multiplicant[15:10]}), .carry_in(1'b0), .sum(sum3),.cout(cout3));

                                                                                      carry_look_ahead_16bit cla_16_4 (.a(sum1),.b(sum2), .carry_in(1'b0), .sum(sum4),.cout(cout4));

  carry_look_ahead_16bit cla_16_5 (.a(sum3),.b(sum4), .carry_in(1'b0), .sum(sum5),.cout(cout5));

  

  assign product=sum5;

  

endmodule



///////////////////////////////////////////////////////////

//Butterfly Unit 

///////////////////////////////////////////////////////////

//`timescale 1ns / 1ps

module BFU(A_real,A_imag,B_real,B_imag,sel_w,X0_real, X0_imag, X1_real, X1_imag);

//  `include "complex_mult.v"

//  `include "16_bit_adder.v"

  input signed[15:0] A_real,A_imag,B_real,B_imag;

  input [1:0]sel_w;

  output signed [15:0] X0_real, X0_imag, X1_real, X1_imag;

  wire [15:0] sum1,diff1,B_sum_prod,B_sum_prod_n,B_diff_prod,B_real_n;

  reg signed [15:0] B_real_0,B_imag_0,B_real_1,B_imag_1,Bxw_real,Bxw_imag;

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

  carry_look_ahead_16bit cla_bfu_1 (.a(B_real_1),.b(B_imag_1), .carry_in(1'b0), .sum(sum1),.cout(cout1));//b_real+b_imag

  

  carry_look_ahead_16bit cla_bfu_2 (.a(B_imag_1),.b(B_real_1), .carry_in(1'b1), .sum(diff1),.cout(cout2));//b_imag-b_real

  

  complex_mult cmult_1 (.multiplicant(sum1),.product(B_sum_prod));//0.707*(sum)

  

  complex_mult cmult_2 (.multiplicant(diff1),.product(B_diff_prod));//0.707*(diff)

  

  carry_look_ahead_16bit cla_bfu_3 (.a(16'b0),.b(B_sum_prod), .carry_in(1'b1), .sum(B_sum_prod_n),.cout(cout3));//-0.707*(sum)

  

  carry_look_ahead_16bit cla_bfu_4 (.a(16'b0),.b(B_real_0), .carry_in(1'b1), .sum(B_real_n),.cout(cout3));//-b_real



//  always@(*)

//    begin

//     $display( "B_real_1 =%d, B_imag_1=%d ,B_real_0 =%d, B_imag_0=%d ", B_real_1,B_imag_1,B_real_0,B_imag_0);

//      $display( "sum1 =%d, diff1=%d ,0.707*sum =%d, 0.707*diff=%d -b_real=%d", sum1,diff1,B_sum_prod,B_diff_prod,B_real_n);

//   end

  

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

//  always@(*)

//   begin

//     $display( "Bxw_real =%d, Bxw_imag=%d ", Bxw_real,Bxw_imag);

// end

  

  carry_look_ahead_16bit cla_bfu_5 (.a(A_real),.b(Bxw_real), .carry_in(1'b0), .sum(X0_real),.cout());//A'_real

  carry_look_ahead_16bit cla_bfu_6 (.a(A_imag),.b(Bxw_imag), .carry_in(1'b0), .sum(X0_imag),.cout());//A'_imag

  carry_look_ahead_16bit cla_bfu_7 (.a(A_real),.b(Bxw_real), .carry_in(1'b1),.sum(X1_real),.cout());//B'_real

  carry_look_ahead_16bit cla_bfu_8 (.a(A_imag),.b(Bxw_imag), .carry_in(1'b1), .sum(X1_imag),.cout());//B'_imag

  

//  always@(*)

//   begin

//     $display( "A_real =%d, A_imag =%d ,A'_real =%d, A'_imag_0=%d ", A_real,A_imag,X0_real ,X0_imag);

//     $display( "B'_real =%d, B'_imag=%d ", X1_real, X1_imag);

//   end

  

endmodule



///////////////////////////////////////////////////////////

//FFT UNIT

///////////////////////////////////////////////////////////

//`timescale 1ns / 1ps

module FFT(In_real0,In_real1,In_real2,In_real3,In_real4,In_real5,In_real6,In_real7,In_imag0,In_imag1,In_imag2,In_imag3,In_imag4,In_imag5,In_imag6,In_imag7,reset_n,clk,write,start_fft,Out_real0,Out_real1,Out_real2,Out_real3,Out_real4,Out_real5,Out_real6,Out_real7,Out_imag0,Out_imag1,Out_imag2,Out_imag3,Out_imag4,Out_imag5,Out_imag6,Out_imag7,fft_ready);

// `include "complex_mult.v"

// `include "16_bit_adder.v"

// `include "BFU.v"

  input signed [15:0]In_real0,In_real1,In_real2,In_real3,In_real4,In_real5,In_real6,In_real7,In_imag0,In_imag1,In_imag2,In_imag3,In_imag4,In_imag5,In_imag6,In_imag7;

  input clk,reset_n,write,start_fft;

  output reg fft_ready;

  output wire signed [15:0]Out_real0,Out_real1,Out_real2,Out_real3,Out_real4,Out_real5,Out_real6,Out_real7,Out_imag0,Out_imag1,Out_imag2,Out_imag3,Out_imag4,Out_imag5,Out_imag6,Out_imag7;

  //reg signed  [15:0]  stage1_op_real[7:0],stage1_op_imag[7:0],stage2_ip_real[7:0],stage2_ip_imag[7:0],stage2_op_real[7:0],stage2_op_imag[7:0],stage3_ip_real[7:0],stage3_ip_imag[7:0];

  wire [15:0] stage1_op_real[7:0],stage1_op_imag[7:0],stage2_op_real[7:0],stage2_op_imag[7:0];

  reg signed [15:0]stage1_ip_real[7:0],stage1_ip_imag[7:0],stage2_ip_real[7:0],stage2_ip_imag[7:0],stage3_ip_real[7:0],stage3_ip_imag[7:0],Input_real_reg[7:0],Input_imag_reg[7:0];

  reg [1:0]i;//To be used to generate ready signal when output ready
  reg strt_cnt;
  
  always@(posedge clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
        Input_real_reg[0]<=15'd0;
      Input_real_reg[1]<=15'd0;
      Input_real_reg[2]<=15'd0;
      Input_real_reg[3]<=15'd0;
      Input_real_reg[4]<=15'd0;
      Input_real_reg[5]<=15'd0;
      Input_real_reg[6]<=15'd0;
      Input_real_reg[7]<=15'd0;
      Input_imag_reg[0]<=15'd0;
      Input_imag_reg[1]<=15'd0;
      Input_imag_reg[2]<=15'd0;
      Input_imag_reg[3]<=15'd0;
      Input_imag_reg[4]<=15'd0;
      Input_imag_reg[5]<=15'd0;
      Input_imag_reg[6]<=15'd0;
      Input_imag_reg[7]<=15'b0;
      
        end
        else if (write)
          begin             
            Input_real_reg[0]<=In_real0;
            Input_real_reg[1]<=In_real1;
            Input_real_reg[2]<=In_real2;
            Input_real_reg[3]<=In_real3;
            Input_real_reg[4]<=In_real4;
            Input_real_reg[5]<=In_real5;
            Input_real_reg[6]<=In_real6;
            Input_real_reg[7]<=In_real7;
            Input_imag_reg[0]<=In_imag0;
            Input_imag_reg[1]<=In_imag1;
            Input_imag_reg[2]<=In_imag2;
            Input_imag_reg[3]<=In_imag3;
            Input_imag_reg[4]<=In_imag4;
            Input_imag_reg[5]<=In_imag5;
            Input_imag_reg[6]<=In_imag6;
            Input_imag_reg[7]<=In_imag7;
          end
                  
    end
      always@(*)
    begin
      $display("In_real0 =%d,In_imag0= %d ,In_real1= %d,In_imag1=%d,In_real2 =%d,In_imag2= %d ,IN_real3= %d,In_imag3=%d, In_real4 =%d,In_imag4= %d ,In_real5= %d,In_imag5=%d,In_real6 =%d,In_imag6= %d ,In_real7= %d,In_imag7=%d,time =%0d", $signed(Input_real_reg[0]),$signed(Input_imag_reg[0]),$signed(Input_real_reg[1]),$signed(Input_imag_reg[1]),$signed(Out_real2),$signed(Out_imag2),$signed(Out_real3),$signed(Out_imag3),$signed(Out_real4),$signed(Out_imag4),$signed(Out_real5),$signed(Out_imag5),$signed(Out_real6),$signed(Out_imag6),$signed(Out_real7),$signed(Out_imag7),$time);
    end
  
    always@(posedge clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
        stage1_ip_real[0]<=15'd0;
      stage1_ip_real[1]<=15'd0;
      stage1_ip_real[2]<=15'd0;
      stage1_ip_real[3]<=15'd0;
      stage1_ip_real[4]<=15'd0;
      stage1_ip_real[5]<=15'd0;
      stage1_ip_real[6]<=15'd0;
      stage1_ip_real[7]<=15'd0;
      stage1_ip_imag[0]<=15'd0;
      stage1_ip_imag[1]<=15'd0;
      stage1_ip_imag[2]<=15'd0;
      stage1_ip_imag[3]<=15'd0;
      stage1_ip_imag[4]<=15'd0;
      stage1_ip_imag[5]<=15'd0;
      stage1_ip_imag[6]<=15'd0;
      stage1_ip_imag[7]<=15'b0;  
      strt_cnt<=1'b0;
        end
      else if (start_fft)
          begin             
            stage1_ip_real[0]<=Input_real_reg[0];
            stage1_ip_real[1]<=Input_real_reg[1];
            stage1_ip_real[2]<=Input_real_reg[2];
            stage1_ip_real[3]<=Input_real_reg[3];
            stage1_ip_real[4]<=Input_real_reg[4];
            stage1_ip_real[5]<=Input_real_reg[5];
            stage1_ip_real[6]<=Input_real_reg[6];
            stage1_ip_real[7]<=Input_real_reg[7];
            stage1_ip_imag[0]<=Input_imag_reg[0];
            stage1_ip_imag[1]<=Input_imag_reg[1];
            stage1_ip_imag[2]<=Input_imag_reg[2];
            stage1_ip_imag[3]<=Input_imag_reg[3];
            stage1_ip_imag[4]<=Input_imag_reg[4];
            stage1_ip_imag[5]<=Input_imag_reg[5];
            stage1_ip_imag[6]<=Input_imag_reg[6];
            stage1_ip_imag[7]<=Input_imag_reg[7];
            strt_cnt<=1'b1;
          end
                  
    end

  // initially compute stage 1. stage 1 consists only of basic addition and subtraction. For subtraction, carry input should be 1



	 //stage 1 output 1

  

  carry_look_ahead_16bit cla_fft_1 (.a(stage1_ip_real[0]),.b(stage1_ip_real[4]), .carry_in(1'b0), .sum(stage1_op_real[0]),.cout()); //Real (x0+x4)

  carry_look_ahead_16bit cla_fft_2 (.a(stage1_ip_imag[0]),.b(stage1_ip_imag[4]), .carry_in(1'b0), .sum(stage1_op_imag[0]),.cout()); //Imaginary (x0+x4)

	 

	 //stage 1 output 2

  carry_look_ahead_16bit cla_fft_3 (.a(stage1_ip_real[0]),.b(stage1_ip_real[4]), .carry_in(1'b1), .sum(stage1_op_real[1]),.cout());// real(x0-x4)

  carry_look_ahead_16bit cla_fft_4 (.a(stage1_ip_imag[0]),.b(stage1_ip_imag[4]), .carry_in(1'b1), .sum(stage1_op_imag[1]),.cout());// Imaginary (x0-x4)

	 

	 

	 //stage 1 output 3

  carry_look_ahead_16bit cla_fft_5 (.a(stage1_ip_real[2]),.b(stage1_ip_real[6]), .carry_in(1'b0), .sum(stage1_op_real[2]),.cout()); //Real (x2+x6)

  carry_look_ahead_16bit cla_fft_6 (.a(stage1_ip_imag[2]),.b(stage1_ip_imag[6]), .carry_in(1'b0), .sum(stage1_op_imag[2]),.cout()); //Imaginary (x2+x6)

	 

	 //stage 1 output 4

  carry_look_ahead_16bit cla_fft_7 (.a(stage1_ip_real[2]),.b(stage1_ip_real[6]), .carry_in(1'b1), .sum(stage1_op_real[3]),.cout());// real(x2-x6)

  carry_look_ahead_16bit cla_fft_8 (.a(stage1_ip_imag[2]),.b(stage1_ip_imag[6]), .carry_in(1'b1), .sum(stage1_op_imag[3]),.cout());// Imaginary (x2-x6)

	 

	 //stage 1 output 5

  carry_look_ahead_16bit cla_fft_9 (.a(stage1_ip_real[1]),.b(stage1_ip_real[5]), .carry_in(1'b0), .sum(stage1_op_real[4]),.cout()); //Real (x1+x5)

  carry_look_ahead_16bit cla_fft_10 (.a(stage1_ip_imag[1]),.b(stage1_ip_imag[5]), .carry_in(1'b0), .sum(stage1_op_imag[4]),.cout()); //Imaginary (x1+x5)

	 

	 //stage 1 output 6

  carry_look_ahead_16bit cla_fft_11 (.a(stage1_ip_real[1]),.b(stage1_ip_real[5]), .carry_in(1'b1), .sum(stage1_op_real[5]),.cout());// real(x1-x5)

  carry_look_ahead_16bit cla_fft_12 (.a(stage1_ip_imag[1]),.b(stage1_ip_imag[5]), .carry_in(1'b1), .sum(stage1_op_imag[5]),.cout());// Imaginary (x1-x5)

	  

	 //stage 1 output 7

  carry_look_ahead_16bit cla_fft_13 (.a(stage1_ip_real[3]),.b(stage1_ip_real[7]), .carry_in(1'b0), .sum(stage1_op_real[6]),.cout()); //Real (x3+x7)

  carry_look_ahead_16bit cla_fft_14 (.a(stage1_ip_imag[3]),.b(stage1_ip_imag[7]), .carry_in(1'b0), .sum(stage1_op_imag[6]),.cout()); //Imaginary (x3+x7)

	 

	 //stage 1 output 8

  carry_look_ahead_16bit cla_fft_15 (.a(stage1_ip_real[3]),.b(stage1_ip_real[7]), .carry_in(1'b1), .sum(stage1_op_real[7]),.cout());// real(x3-x7)

  carry_look_ahead_16bit cla_fft_16 (.a(stage1_ip_imag[3]),.b(stage1_ip_imag[7]), .carry_in(1'b1), .sum(stage1_op_imag[7]),.cout());// Imaginary (x3-x7) 

//  always@(*)
//    begin


  always@(posedge clk or negedge reset_n)

    begin

      if(!reset_n)

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

      	stage2_ip_imag[7]<=16'b0;
          
        i <= 2'b0;
        fft_ready <= 1'b0;
        end

       else

         begin

           stage2_ip_real[0]<=stage1_op_real[0];

           stage2_ip_imag[0]<=stage1_op_imag[0];

           stage2_ip_real[1]<=stage1_op_real[1];

           stage2_ip_imag[1]<=stage1_op_imag[1];

           stage2_ip_real[2]<=stage1_op_real[2];

           stage2_ip_imag[2]<=stage1_op_imag[2];

           stage2_ip_real[3]<=stage1_op_real[3];

           stage2_ip_imag[3]<=stage1_op_imag[3];

           stage2_ip_real[4]<=stage1_op_real[4];

           stage2_ip_imag[4]<=stage1_op_imag[4];

           stage2_ip_real[5]<=stage1_op_real[5];

           stage2_ip_imag[5]<=stage1_op_imag[5];

           stage2_ip_real[6]<=stage1_op_real[6];

           stage2_ip_imag[6]<=stage1_op_imag[6];

           stage2_ip_real[7]<=stage1_op_real[7];

           stage2_ip_imag[7]<=stage1_op_imag[7];
           
           if((i != 2'b11) & strt_cnt)
             begin
              i<=i+1'b1;
			  fft_ready<=1'b0;	
             end
           
           if(i == 2'b11)
               fft_ready<=1'b1;
         end
     
    end


	//stage 2 computation.

	

	

	//stage 2 output 1

  carry_look_ahead_16bit cla_fft_17 (.a(stage2_ip_real[0]),.b(stage2_ip_real[2]), .carry_in(1'b0), .sum(stage2_op_real[0]),.cout()); // real (stage 1 op1 + stage 1 op3)

  carry_look_ahead_16bit cla_fft_18 (.a(stage2_ip_imag[0]),.b(stage2_ip_imag[2]), .carry_in(1'b0), .sum(stage2_op_imag[0]),.cout()); // imag (stage 1 op1 + stage 1 op3)

	 

	 //stage 2 output 3

  carry_look_ahead_16bit cla_fft_19 (.a(stage2_ip_real[0]),.b(stage2_ip_real[2]), .carry_in(1'b1), .sum(stage2_op_real[2]),.cout()); // real (stage 1 op1 - stage 1 op3)

  carry_look_ahead_16bit cla_fft_20 (.a(stage2_ip_imag[0]),.b(stage2_ip_imag[2]), .carry_in(1'b1), .sum(stage2_op_imag[2]),.cout()); // imag (stage 1 op1 - stage 1 op3)



	//stage 2 output 2 and 4

	

  BFU bf1 (.A_real(stage2_ip_real[1]),.A_imag(stage2_ip_imag[1]),.B_real(stage2_ip_real[3]),.B_imag(stage2_ip_imag[3]),.sel_w(2'b10),.X0_real(stage2_op_real[1]), 

           .X0_imag(stage2_op_imag[1]), .X1_real(stage2_op_real[3]), .X1_imag(stage2_op_imag[3])); // 10 is selected for sel_w as w^2 is the twiddle factor

	 

	 // stage 2 output 5 and 7

	 

	//stage 2 output 5

  carry_look_ahead_16bit cla_fft_21 (.a(stage2_ip_real[4]),.b(stage2_ip_real[6]), .carry_in(1'b0), .sum(stage2_op_real[4]),.cout()); // real (stage 1 op5 + stage 1 op7)

  carry_look_ahead_16bit cla_fft_22 (.a(stage2_ip_imag[4]),.b(stage2_ip_imag[6]), .carry_in(1'b0), .sum(stage2_op_imag[4]),.cout()); // imag (stage 1 op5 + stage 1 op7)

	 

	 //stage 2 output 7

  carry_look_ahead_16bit cla_fft_23 (.a(stage2_ip_real[4]),.b(stage2_ip_real[6]), .carry_in(1'b1), .sum(stage2_op_real[6]),.cout()); // real (stage 1 op5 - stage 1 op7)

  carry_look_ahead_16bit cla_fft_24 (.a(stage2_ip_imag[4]),.b(stage2_ip_imag[6]), .carry_in(1'b1), .sum(stage2_op_imag[6]),.cout()); // imag (stage 1 op5 - stage 1 op7)

	

	//stage 2 output 6 and 8

	

  BFU bf2 (.A_real(stage2_ip_real[5]),.A_imag(stage2_ip_imag[5]),.B_real(stage2_ip_real[7]),.B_imag(stage2_ip_imag[7]),.sel_w(2'b10),.X0_real(stage2_op_real[5])

           , .X0_imag(stage2_op_imag[5]), .X1_real(stage2_op_real[7]), .X1_imag(stage2_op_imag[7])); // 10 is selected for sel_w as w^2 is the twiddle factor

  
   
  always@(posedge clk or negedge reset_n)

    begin

      if(!reset_n)

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

        stage3_ip_imag[7]<=16'b0;

        end

       else

         begin

           stage3_ip_real[0]<=stage2_op_real[0];

           stage3_ip_imag[0]<=stage2_op_imag[0];

           stage3_ip_real[1]<=stage2_op_real[1];

           stage3_ip_imag[1]<=stage2_op_imag[1];

           stage3_ip_real[2]<=stage2_op_real[2];

           stage3_ip_imag[2]<=stage2_op_imag[2];

           stage3_ip_real[3]<=stage2_op_real[3];

           stage3_ip_imag[3]<=stage2_op_imag[3];

           stage3_ip_real[4]<=stage2_op_real[4];

           stage3_ip_imag[4]<=stage2_op_imag[4];

           stage3_ip_real[5]<=stage2_op_real[5];

           stage3_ip_imag[5]<=stage2_op_imag[5];

           stage3_ip_real[6]<=stage2_op_real[6];

           stage3_ip_imag[6]<=stage2_op_imag[6];

           stage3_ip_real[7]<=stage2_op_real[7];

           stage3_ip_imag[7]<=stage2_op_imag[7];

           

         end

    end

  

  	//stage 3 computation.


		//stage 3 output 1 X0

  carry_look_ahead_16bit cla_fft_25 (.a(stage3_ip_real[0]),.b(stage3_ip_real[4]), .carry_in(1'b0), .sum(Out_real0),.cout()); // real (stage 2 op1 + stage 2 op5)

  carry_look_ahead_16bit cla_fft_26 (.a(stage3_ip_imag[0]),.b(stage3_ip_imag[4]), .carry_in(1'b0), .sum(Out_imag0),.cout()); // imag (stage 2 op1 + stage 2 op5)

	 

	 	//stage 3 output 5 X4

  carry_look_ahead_16bit cla_fft_27 (.a(stage3_ip_real[0]),.b(stage3_ip_real[4]), .carry_in(1'b1), .sum(Out_real4),.cout()); // real (stage 2 op1 + stage 2 op5)

  carry_look_ahead_16bit cla_fft_28 (.a(stage3_ip_imag[0]),.b(stage3_ip_imag[4]), .carry_in(1'b1), .sum(Out_imag4),.cout()); // imag (stage 2 op1 + stage 2 op5)

	 

	  // stage 3 output 2 == X1 and output 6== X5

  BFU bf3 (.A_real(stage3_ip_real[1]),.A_imag(stage3_ip_imag[1]),.B_real(stage3_ip_real[5]),.B_imag(stage3_ip_imag[5]),.sel_w(2'b01),.X0_real(Out_real1)

           , .X0_imag(Out_imag1), .X1_real(Out_real5), .X1_imag(Out_imag5)); // 01 is selected for sel_w as w is the twiddle factor

	 

	 //stage 3 output 3==X2 and OUTPUT 7 ==X6

	

  BFU bf4 (.A_real(stage3_ip_real[2]),.A_imag(stage3_ip_imag[2]),.B_real(stage3_ip_real[6]),.B_imag(stage3_ip_imag[6]),.sel_w(2'b10),.X0_real(Out_real2)

           , .X0_imag(Out_imag2), .X1_real(Out_real6), .X1_imag(Out_imag6)); // 10 is selected for sel_w as w^2 is the twiddle factor

	

	//stage 3 output 4==X3 and OUTPUT 8 ==X7

	  BFU bf5 (.A_real(stage3_ip_real[3]),.A_imag(stage3_ip_imag[3]),.B_real(stage3_ip_real[7]),.B_imag(stage3_ip_imag[7]),.sel_w(2'b11),.X0_real(Out_real3)

          , .X0_imag(Out_imag3), .X1_real(Out_real7), .X1_imag(Out_imag7)); // 11 is selected for sel_w as w^3 is the twiddle factor

endmodule


module FFT_wrapper(in0_real,in0_imag,in1_real,in1_imag,in2_real,in2_imag,in3_real,in3_imag,in4_real,in4_imag,in5_real,in5_imag,in6_real,in6_imag,in7_real,in7_imag,CLK,RST_N,write,start,out0_real,out0_imag,out1_real,out1_imag,out2_real,out2_imag,out3_real,out3_imag,out4_real,out4_imag,out5_real,out5_imag,out6_real,out6_imag,out7_real,out7_imag,ready);
  
  input signed [15:0]in0_real,in1_real,in2_real,in3_real,in4_real,in5_real,in6_real,in7_real,in0_imag,in1_imag,in2_imag,in3_imag,in4_imag,in5_imag,in6_imag,in7_imag;

  input CLK,RST_N,write,start;

  output ready;

  output wire signed [15:0]out0_real,out1_real,out2_real,out3_real,out4_real,out5_real,out6_real,out7_real,out0_imag,out1_imag,out2_imag,out3_imag,out4_imag,out5_imag,out6_imag,out7_imag;

  
FFT fft(.In_real0(in0_real),.In_real1(in1_real),.In_real2(in2_real),.In_real3(in3_real),.In_real4(in4_real),.In_real5(in5_real),.In_real6(in6_real),.In_real7(in7_real),.In_imag0(in0_imag),.In_imag1(in1_imag),.In_imag2(in2_imag),.In_imag3(in3_imag),.In_imag4(in4_imag),.In_imag5(in5_imag),.In_imag6(in6_imag),.In_imag7(in7_imag),.reset_n(RST_N),.clk(CLK),.write(write),.start_fft(start),.Out_real0(out0_real),.Out_real1(out1_real),.Out_real2(out2_real),.Out_real3(out3_real),.Out_real4(out4_real),.Out_real5(out5_real),.Out_real6(out6_real),.Out_real7(out7_real),.Out_imag0(out0_imag),.Out_imag1(out1_imag),.Out_imag2(out2_imag),.Out_imag3(out3_imag),.Out_imag4(out4_imag),.Out_imag5(out5_imag),.Out_imag6(out6_imag),.Out_imag7(out7_imag),.fft_ready(ready));


endmodule
