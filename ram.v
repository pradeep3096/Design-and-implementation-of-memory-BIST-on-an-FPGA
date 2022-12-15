module ram #(
parameter AWIDTH = 4)
       (clk,reset,wr_addr, rd_addr,data_in, data_out, we, re,fault);
  input we,re,clk,reset;
  input [1:0]fault;
  input [AWIDTH-1:0]wr_addr;
  input [AWIDTH-1:0]rd_addr;
  input  data_in;
  output reg data_out;
  integer i;
  integer j;
  
  reg [3:0] memory[3:0];
  //reg [1:0] wr_addr[3:2];
  //reg [1:0] wr_addr[1:0];
  //reg [1:0] rd_addr[3:2];
  //reg [1:0] rd_addr[1:0];
  //{4'b0000,4'b0000,4'b0000,4'b0000};
 
  always @(posedge clk or re )
  
    begin
    if(reset)
    begin
    
   // rd_addr[3:2]<=0;
    //rd_addr[1:0]<=0;
    data_out<=0;
    for(i=0;i<4;i=i+1)
    begin
    for(j=0;j<4;j=j+1)
    begin
    memory[i][j]<=1;
    end
    end
    
    
    end
    else
    begin
      if(re)  
      begin
      //rd_addr[3:2]<=rd_addr[3:2];
      //rd_addr[1:0]<=rd_addr[1:0];
          data_out<= memory[rd_addr[1:0]][rd_addr[3:2]];
          
      end
    end
    end
	
	
	
  always@(posedge clk or we)
    begin
    if(reset)
    begin
    //wr_addr[3:2]<=0;
    //wr_addr[1:0]<=0;
    data_out<=0;
    
    end
    else
    begin
      if(we)
        begin
      //wr_addr[3:2]<=wr_addr[3:2];
      //wr_addr[1:0]<=wr_addr[1:0];
        case(fault)
          2'b00:  // struck at fault 
            begin 
              memory[1][1] <= 0; 
              memory[3][2] <= 1;
              if(~((wr_addr[1:0]==1 && wr_addr[3:2]==1)||(wr_addr[1:0]==3 && wr_addr[3:2]==2))) memory[wr_addr[1:0]][wr_addr[3:2]] <= data_in;
              
//             if(wr_addr[1:0]==1 && wr_addr[3:2]==1)memory[wr_addr[1:0]][wr_addr[3:2]] <= 0;//s-a-0
//              else if(wr_addr[1:0]==3 && wr_addr[3:2]==2)memory[wr_addr[1:0]][wr_addr[3:2]] <= 1;//s-a-1
//              else memory[wr_addr[1:0]][wr_addr[3:2]] <= data_in;
             
            end
          2'b01:
            begin
              if(wr_addr[1:0]==0 && wr_addr[3:2]==2)
                memory[wr_addr[1:0]][wr_addr[3:2]] <= memory[wr_addr[1:0]][wr_addr[3:2]] &data_in;// 0->1 transition fault
              else if(wr_addr[1:0]==2 && wr_addr[3:2]==0)
                memory[wr_addr[1:0]][wr_addr[3:2]] <= memory[2][0] | data_in;//1->0 transition fault
              else
                memory[wr_addr[1:0]][wr_addr[3:2]] <= data_in;     
            end
          
          2'b10:
            begin
              if(wr_addr[1:0]==3 && wr_addr[3:2]==1) //when (1,3) changes from 0->1 (0,3) toggles
                begin
                  memory[wr_addr[1:0]][wr_addr[3:2]-1] <= memory[wr_addr[1:0]][wr_addr[3:2]-1] ^ ~memory[wr_addr[1:0]][wr_addr[3:2]] & data_in;
                  memory[wr_addr[1:0]][wr_addr[3:2]] <= data_in;
                end
              
              else
                memory[wr_addr[1:0]][wr_addr[3:2]]<= data_in;
            end
      
          2'b11:
            memory[wr_addr[1:0]][wr_addr[3:2]] <= data_in;
           
        endcase
        
        end
    end   
    end
endmodule
  