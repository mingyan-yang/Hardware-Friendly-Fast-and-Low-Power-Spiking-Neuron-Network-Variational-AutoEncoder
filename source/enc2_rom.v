module enc2_rom (
    input clk,
    input [4:0] raddr,
    output reg [`DATA_WIDTH*50-1:0] weight
);
    
reg [`DATA_WIDTH*50-1:0] weight_mem [0:19];

always @(negedge clk) begin
    weight <= weight_mem[raddr];
end

task load_param(
    input integer index,
    input [4*50-1:0] param_input
);
    weight_mem[index] = param_input;
endtask

endmodule