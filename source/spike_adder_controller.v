module spike_adder_controller (
	input clk,
	input rst,
	input [56-1:0] spike,
	input [1:0] state,
	input [56*`DATA_WIDTH-1:0] weight,
	input [2:0] FSM_state,
	input last_neuron,
	output reg done,
	output reg next_neuron,
	output reg signed [`SUM_WIDTH-1:0] adder_out
);

	localparam MEM_LOAD = 3'd0;
	localparam ENC_DATA = 3'd1;
	localparam ENC_COMP = 3'd2;
	localparam MEM_WRITE = 3'd3;
	localparam DEC_DATA = 3'd4;
	localparam DEC_COMP = 3'd5;
	localparam DONE = 3'd6;

	reg [3:0] cycle_cnt;
	reg [3:0] cycle_end;
	reg [1:0] in_valid_buf;

	wire out_valid;

	reg signed [`SUM_WIDTH-1:0] partial_sum;
	wire signed [10:0] partial_sum_next;
	
	wire in_valid = (FSM_state == ENC_DATA || FSM_state == DEC_DATA);

	always @* begin
		case (state)
			2'd0: cycle_end = 13;
			2'd1: cycle_end = 1;
			2'd2: cycle_end = 0;
			2'd3: cycle_end = 1;
			default: cycle_end = 0;
		endcase
	end

	_56to1_adder ADDER (
		.clk(clk),
		.rst(rst),
		.in_valid(in_valid_buf[1]),
		.weight_in(weight),
		.spike_in(spike),
		.sum_out(partial_sum_next),
		.out_valid(out_valid)
	);

	reg [3:0] vpipe;
	
	always @(posedge clk) begin
		if (rst) vpipe <= 4'b0;
		else vpipe <= {vpipe[2:0], next_neuron};
	end

	always @(posedge clk) begin
		if (rst) done <= 0;
		else done <= vpipe[3];
	end

	always @(posedge clk) begin
		if (rst) in_valid_buf <= 2'd0;
		else in_valid_buf <= {in_valid_buf[0], in_valid};
	end

	always @(posedge clk) begin
		if (rst) begin
			cycle_cnt <= 0;
			next_neuron <= 0;
		end else begin
			if (FSM_state == ENC_DATA || FSM_state == DEC_DATA) begin
				if (cycle_cnt == cycle_end) begin
					if (last_neuron && next_neuron) next_neuron <= 0;
					else 							next_neuron <= 1;
					cycle_cnt <= 0;
				end else begin
					cycle_cnt <= cycle_cnt + 1;
					next_neuron <= 0;
				end	
			end else begin
				cycle_cnt <= 0;
				next_neuron <= 0;
			end
		end
	end 

	always @(posedge clk) begin
		if (rst) begin
			partial_sum <= 0;
		end else if (out_valid) begin
			if (vpipe[3]) partial_sum <= 0;
			else partial_sum <= partial_sum + partial_sum_next;
		end else begin
			partial_sum <= 0;
		end
	end

	always @(posedge clk) begin
		if (rst) adder_out <= 0;
		else adder_out <= vpipe[3] ? (partial_sum + partial_sum_next) : 0;
	end
endmodule
