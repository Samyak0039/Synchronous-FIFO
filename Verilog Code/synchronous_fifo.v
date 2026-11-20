module synchronous_fifo(clk,reset,wr_en,rd_en,data_in,data_out,full,empty);

    input clk,reset,wr_en,rd_en;
    input [7:0] data_in;

    output reg [7:0] data_out;
    output full,empty;
    
    reg [7:0] memory [0:15];

    reg [4:0] wr_ptr;
    reg [4:0] rd_ptr;
    
    reg [4:0] count;
    
    wire write_accept;
    wire read_accept;
    
    assign empty = (count == 0);
    assign full  = (count == 16);
    
    assign write_accept = wr_en && !full;
    assign read_accept  = rd_en && !empty;
    always @(posedge clk)
    begin
        if (reset)
        begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            data_out <= 0;
        end
        else
        begin
            if (write_accept)
            begin
                memory[wr_ptr[3:0]] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end
    
            if (read_accept)
            begin
                data_out <= memory[rd_ptr[3:0]];
                rd_ptr <= rd_ptr + 1'b1;
            end
            
            case ({write_accept,read_accept})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase 
        end
    end
endmodule