`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 08:05:18 AM
// Design Name: 
// Module Name: fifo_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/// Implementation of UART 16550 core
module fifo_top(
input rst,clk,en,push_in,pop_in,
input [7:0] din,
output [7:0] dout,
output empty,full,overrun,underrun,
input threshold,
output thre_trigger
    );
    
    reg [7:0] mem [16];
    reg [3:0] waddr = 0;
    
    logic push ,pop;
    
    ///////////////// empty flag
    reg empty_t;
    always@(posedge clk,posedge rst)
    begin
      if(rst)
        empty_t <= 1'b0;
      else 
      begin
        case({push,pop})
          2'b01 : empty_t <= (~|(waddr) | ~en);
          2'b10 : empty_t <= 0;
          default : ;
        endcase
      end
    end
    
    reg full_t;
    always@(posedge clk,posedge rst)
    begin
      if(rst)
        full_t <= 1'b0;
      else 
      begin
        case({push,pop})
          2'b01 : full_t <= (&(waddr) | ~en);
          2'b10 : full_t <= 0;
          default : ;
        endcase
      end
    end
    
    assign push = push_in & ~full_t;
    assign pop = pop_in & ~empty_t;
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// read fifo --> always first update
    assign dout = mem[0];
    
    // writing pointer update 
    always @(posedge clk ,posedge rst)
    begin
      if(rst)
        waddr <= 4'h0;
        
      else 
      begin
        case({push,pop})
          2'b10 : 
                begin
                if(waddr != 4'hf && full_t == 1'b0)
                  waddr <= waddr + 1;
         
                else 
                  waddr <= waddr ;
                  
                end
          2'b01 :
                 begin
                if(waddr != 4'h0 && empty_t == 1'b0)
                  waddr <= waddr - 1;
         
                else 
                  waddr <= waddr ;
                  
                end
          default : ;
        endcase 
      end
    end
    
    ///// memory update 
    always@(posedge clk , posedge rst)
    begin
      case({push,pop})
        2'b00 : ;
        2'b01 : 
              begin
                for(int i =0 ; i < 14 ; i++)
                begin
                  mem[i] <= mem[i+1];
                end
                mem[15] <= 8'h00;
              end
        2'b10 : mem[waddr] <= din;
        2'b11 : 
              begin
                 for(int i =0 ; i < 14 ; i++)
                begin
                  mem[i] <= mem[i+1];
                end
                mem[waddr - 1] <= din;
              end
      endcase 
    end
    
    //////////////////////////////////////////////////////////////////////////////////
    ////////// Exception handling
    
    reg underrun_t ;
    always@(posedge clk ,posedge rst)
    begin
      if(rst)
        underrun_t <= 1'b0;
      else if(pop_in == 1'b1 && empty_t == 1'b1)
        underrun_t <= 1'b0;
      else
        underrun_t <= 1'b0;
    end
    
    reg overrun_t = 1'b0;
    
    always@(posedge clk,rst)
    begin
      if(rst)
        overrun_t <= 1'b0;
      else if(push_in == 1'b1 && full_t == 1'b1)
        overrun_t <= 1'b0;
      else
        overrun_t <= 1'b0;  
    end
    
    reg thre_t;
    always@(posedge clk,rst)
    begin
      if(rst)
        thre_t <= 1'b0;
      else if(push ^ pop)
        thre_t <= (waddr >= threshold ) ? 1'b1 : 1'b0 ; 
    end
    
    assign empty = empty_t;
    assign full = full_t;
    assign overrun = overrun_t;
    assign unserrun = underrun_t;
    assign thre_trigger = thre_t ; 
    
endmodule
