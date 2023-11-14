///////////////////////////////////////////////////////////
//16-bit Carry Look Ahead Adder 
///////////////////////////////////////////////////////////

//`timescale 1ns / 1ps
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
