module dec1_rom (
    input clk,
    input [7:0] raddr,
    output reg [`DATA_WIDTH*10-1:0] weight
);
    
reg [`DATA_WIDTH*10-1:0] weight_mem [0:99];

always @(negedge clk) begin
    weight <= weight_mem[raddr];
end

task load_param(
    input integer index,
    input [4*10-1:0] param_input
);
    weight_mem[index] = param_input;
endtask

endmodule