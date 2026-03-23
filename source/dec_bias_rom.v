module dec_bias_rom (
    input clk,
    input [9:0] raddr,
    output reg [`DATA_WIDTH-1:0] bias
);
    
reg [`DATA_WIDTH-1:0] bias_mem [0:883];

always @(negedge clk) begin
    bias <= bias_mem[raddr];
end

task load_param(
    input integer index,
    input [3:0] param_input
);
    bias_mem[index] = param_input;
endtask

endmodule