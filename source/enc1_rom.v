module enc1_rom (
    input clk,
    input [10:0] raddr,
    output reg [`DATA_WIDTH*56-1:0] weight
);
    
reg [`DATA_WIDTH*56-1:0] weight_mem [0:1399];

always @(negedge clk) begin
    weight <= weight_mem[raddr];
end

task load_param(
    input integer index,
    input [4*56-1:0] param_input
);
    weight_mem[index] = param_input;
endtask

endmodule