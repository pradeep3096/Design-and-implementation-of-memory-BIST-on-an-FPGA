`timescale 1ns / 1ps
`define clock_period 50


module MBistController_TB();
parameter AWIDTH = 4;

reg clk;
reg test_mode;
reg rst;
reg [1:0]fault;




wire bist_status;
initial
begin
clk = 1;
end

always #(`clock_period/2) clk = ~clk;
MBistController MBist_inst (.clk(clk),.rst(rst),.test_mode(test_mode),.bist_status(bist_status),.fault(fault));
initial
begin
 test_mode = 0;
 rst = 1;
 #(5*`clock_period);
 rst = 0;
 #(`clock_period/2);
 test_mode = 1;
 
 fault=2'b11;
 $display("Normal Operation");
 #(100*`clock_period);
 
 fault=2'b00;
 $display("Struck-at-faults detection");
 #(100*`clock_period);
 
 fault=2'b01;
 $display("transition faults detection");
 #(100*`clock_period);
 
 fault=2'b10;
 $display("Coupling detection");
 #(100*`clock_period);

 fault=2'b11;
 $display("Normal Operation");
 #(100*`clock_period);


 //force u.u_mem_model.mem[3] = 0;
 #(1000*`clock_period);
 $finish;
end
endmodule
