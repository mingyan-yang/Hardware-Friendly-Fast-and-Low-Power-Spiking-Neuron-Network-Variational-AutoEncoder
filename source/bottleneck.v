module bottleneck (
    input [`SUM_WIDTH-1 : 0] bottleneck,
    input clk,
    input reset,
	input en,

    output reg [2*10-1 : 0] spike
);

	reg [3:0] counter, counter_next;
    reg [2*10-1 : 0] next_spike;
	reg en_ff;
    reg signed [`SUM_WIDTH-1 : 0] bottle_neck_ff;
    integer i;

    always @(posedge clk) begin
        if (reset) begin
			bottle_neck_ff <= 0;
            spike <= 0;
			en_ff <= 0;
			counter <= 0;
        end else begin
			bottle_neck_ff <= bottleneck;
            spike <= next_spike;
			en_ff <= en;
			counter <= counter_next;
        end
    end

	always @* begin
		if (en_ff) counter_next = counter + 1;
		else       counter_next = counter;
	end

    always @(*) begin
		if (en_ff)
			if (bottle_neck_ff >= 16) begin
				next_spike[counter] = 1'b1;
				next_spike[counter + 10] = 1'b1;
			end else if (bottle_neck_ff >= 8) begin
				next_spike[counter] = 1'b1;
				next_spike[counter + 10] = 1'b0;
			end else begin
				next_spike[counter] = 1'b0;
				next_spike[counter + 10] = 1'b0;
			end
       	else
			next_spike = spike;
    end
endmodule
