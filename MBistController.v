`timescale 1ns / 1ps


module MBistController(
input clk,rst,test_mode,wr_en,rd_en,data_in,[3:0]wraddr,[3:0] rdaddr,
[1:0] fault,

output reg bist_status
    );
    
    reg [2:0]state;
    reg wr_en_gen;
    reg rd_en_gen;
    reg data_in_gen;
    reg [3:0]wraddr_gen;
    reg [3:0]rdaddr_gen;
    reg wr_en_mux;
    reg rd_en_mux;
    reg data_in_mux;
    reg [3:0]wraddr_mux;
    reg [3:0]rdaddr_mux;
    reg addr_rst;
    wire data_out_mem;
    
    always@(posedge clk)
    begin
    if(rst)
    begin
    wr_en_gen<=0;
    rd_en_gen<=0;
    data_in_mux<=0;
    wraddr_mux<=4'b0000;
    rdaddr_mux<=4'b0000;
    end
    else
    begin
    wr_en_mux=test_mode?wr_en_gen:wr_en;
    rd_en_mux=test_mode?rd_en_gen:rd_en;
    data_in_mux=test_mode?data_in_gen:data_in;
    wraddr_mux=test_mode?wraddr_gen:wraddr;
    rdaddr_mux=test_mode?rdaddr_gen:rdaddr_gen;
    end
    end
    
    always@(posedge clk)
    begin
    if(rst)
    begin
    state<=0;
    wr_en_gen<=0;
    rd_en_gen<=0;
    wraddr_gen<=0;
    bist_status<=0;
    data_in_gen<=0;
    addr_rst<=0;
    end
    else
    begin
    case(state)
    0:
    begin
    if(test_mode)
    begin
    wr_en_gen<=1;
    rd_en_gen<=0;
    data_in_gen<=0;
    wraddr_gen<=0;
    rdaddr_gen<=0;
    state<=1;
    end
    else
    state<=0;
    end
    
    ///////////////////////////////////////////////////////////////
    
    1:     //write0
    begin
    wr_en_gen<=1;
    rd_en_gen<=0;
    data_in_gen<=1'b0;
    
    if(wraddr_gen==15)
    begin
    state<=2;
    addr_rst<=0;
    end
    wraddr_gen=wraddr_gen+1'b1;
    end
    
    2:      //read0
    if(addr_rst==0)
    begin
    rdaddr_gen<=0;
    wraddr_gen<=0;
    wr_en_gen<=0;
    rd_en_gen<=1;
    addr_rst<=1;
    end
    else
    begin
    wr_en_gen<=0;
    rd_en_gen<=1;
    //rdaddr_gen<=rdaddr_gen+1'b1;
    if(data_out_mem==0)
        begin
         $display("No error");
         state<=3;
         wr_en_gen<=1;
         rd_en_gen<=0;
         data_in_gen<=1;
         bist_status<=0;
        end
        else
        begin
        $display(" error");
        state<=3;
         wr_en_gen<=1;
         rd_en_gen<=0;
         data_in_gen<=1;
         bist_status<=1;
        end
       rdaddr_gen<=rdaddr_gen+1'b1;
    end
    /////////////////////////////////////////////////////
    
    3:     //write 1
    begin
     wr_en_gen<=1;
     rd_en_gen<=0;
     data_in_gen<=1'b1;
     
      if(wraddr_gen == 15)
       begin
        state <= 4;
        rd_en_gen<=1;
        wr_en_gen<=0;
	   addr_rst <= 0;
       end
	else
	begin
	state <= 2;
    rd_en_gen<=1;
    wr_en_gen<=0;
    end
    wraddr_gen<=wraddr_gen+1'b1;
    end
    
    4:      // read 1
    if(addr_rst==0)
    begin
    rdaddr_gen <= 4'b1111;
	wraddr_gen <= 4'b1111;
	wr_en_gen <= 0;
	rd_en_gen <= 1;
	addr_rst<=1;
    end
    else
    begin
    wr_en_gen<=0;
    rd_en_gen<=1;
    //rdaddr_gen<=rdaddr_gen+1'b1;
    if(data_out_mem==1)
        begin
         $display("No error");
         bist_status<=0;
         state<=5;
         wr_en_gen<=1;
         rd_en_gen<=0;
         data_in_gen<=0;
        end
        else
        begin
        $display(" error");
        state<=5;
        wr_en_gen<=1;
        rd_en_gen<=0;
        data_in_gen<=0;
        bist_status<=1;
        end
       rdaddr_gen<=rdaddr_gen-1'b1;
    end
    
    5:          //write 0
    begin
    wr_en_gen<=1;
     rd_en_gen<=0;
     data_in_gen<=1'b0;
     
      if(wraddr_gen == 0)
       begin
        state <= 6;
        rd_en_gen<=1;
        wr_en_gen<=0;
	   addr_rst <= 0;
       end
	else
	begin
	state <= 4;
    rd_en_gen<=1;
    wr_en_gen<=0;
    end
    wraddr_gen<=wraddr_gen-1'b1;
    end
    
    6:          // read 0
    if(addr_rst==0)
    begin
    rdaddr_gen<=4'b1111;
    wraddr_gen<=4'b1111;
    wr_en_gen<=0;
    rd_en_gen<=1;
    addr_rst<=1;
    end
    else
    begin
    wr_en_gen<=0;
    rd_en_gen<=1;
    //rdaddr_gen<=rdaddr_gen+1'b1;
    if(data_out_mem==0)
        begin
         $display("No error");
         bist_status<=0;
//         state<=0;
//         wr_en_gen<=1;
//         rd_en_gen<=0;
//         data_in_gen<=1;
        end
        else
        begin
        $display(" error");
        bist_status<=1;
//        state<=3;
//         wr_en_gen<=1;
//         rd_en_gen<=0;
//         data_in_gen<=1;
        end
       rdaddr_gen<=rdaddr_gen-1'b1;
       if(rdaddr_gen==0)
       begin
       state<=0;
       
       end
       
    end
    
    endcase
    end
    end
    
//    ram #(
//               .AWIDTH(4)
//              )
//     ram_model_inst (
//                 .clk(clk),
//                 .reset(rst),
//                 .we(wr_en_gen),
//                 .wr_addr(wraddr_gen),
//                 .data_in(data_in_gen),
//                 .re(rd_en_gen),
//                 .rd_addr(rdaddr_gen),
//                 .data_out(data_out_mem),
//                 .fault(2'b00)
//               );
    
    ram #(
               .AWIDTH(4)
              )
     ram_model_inst (
                 .clk(clk),
                 .reset(rst),
                 .we(wr_en_mux),
                 .wr_addr(wraddr_mux),
                 .data_in(data_in_mux),
                 .re(rd_en_mux),
                 .rd_addr(rdaddr_mux),
                 .data_out(data_out_mem),
                 .fault(fault)
                 
               );
    
endmodule
