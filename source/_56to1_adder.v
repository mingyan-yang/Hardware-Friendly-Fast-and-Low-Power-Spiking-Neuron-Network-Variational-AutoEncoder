module csa #(parameter W = 4)(
	input [W-1:0] a, b, c,
	output [W-1:0] sum,
	output [W-1:0] carry
);
	assign sum = a ^ b ^ c;
	assign carry = (a & b) | (a & c) | (b & c);
endmodule


module _7to1_adder(
	input clk,
	input rst,
	input [7*`DATA_WIDTH-1:0] weight_in,
	input [6:0] spike_in,
	output reg signed [7:0] sum_out
);
	reg signed [`DATA_WIDTH-1:0] w1, w2, w3, w4, w5, w6, w7;
	wire [`DATA_WIDTH+3:0] s1, s2, c1, c2; 

	always @* begin
		w1 = spike_in[0] ? weight_in[`DATA_WIDTH-1:0] : 4'd0;
		w2 = spike_in[1] ? weight_in[2 * `DATA_WIDTH-1:`DATA_WIDTH] : 4'd0;
		w3 = spike_in[2] ? weight_in[3 * `DATA_WIDTH-1:2 * `DATA_WIDTH] : 4'd0;
		w4 = spike_in[3] ? weight_in[4 * `DATA_WIDTH-1:3 * `DATA_WIDTH] : 4'd0;
		w5 = spike_in[4] ? weight_in[5 * `DATA_WIDTH-1:4 * `DATA_WIDTH] : 4'd0;
		w6 = spike_in[5] ? weight_in[6 * `DATA_WIDTH-1:5 * `DATA_WIDTH] : 4'd0;
		w7 = spike_in[6] ? weight_in[7 * `DATA_WIDTH-1:6 * `DATA_WIDTH] : 4'd0;
	end

	wire signed [7:0] e1 = {{4{w1[`DATA_WIDTH-1]}}, w1};
	wire signed [7:0] e2 = {{4{w2[`DATA_WIDTH-1]}}, w2};
	wire signed [7:0] e3 = {{4{w3[`DATA_WIDTH-1]}}, w3};
	wire signed [7:0] e4 = {{4{w4[`DATA_WIDTH-1]}}, w4};
	wire signed [7:0] e5 = {{4{w5[`DATA_WIDTH-1]}}, w5};
	wire signed [7:0] e6 = {{4{w6[`DATA_WIDTH-1]}}, w6};
	wire signed [7:0] e7 = {{4{w7[`DATA_WIDTH-1]}}, w7};

	csa #(`DATA_WIDTH+4) CSA1(.a(e1), .b(e2), .c(e3), .sum(s1), .carry(c1));
	csa #(`DATA_WIDTH+4) CSA2(.a(e4), .b(e5), .c(e6), .sum(s2), .carry(c2));
	
	wire [`DATA_WIDTH+4:0] s1e = {1'b0, s1};
	wire [`DATA_WIDTH+4:0] s2e = {1'b0, s2};
	wire [`DATA_WIDTH+4:0] c1s = {c1, 1'b0};

	wire [`DATA_WIDTH+4:0] s3, c3;
	csa #(`DATA_WIDTH+5) CSA3(.a(s1e), .b(s2e), .c(c1s), .sum(s3), .carry(c3));
	
	wire [`DATA_WIDTH+5:0] s3e  = {1'b0, s3};
	wire [`DATA_WIDTH+5:0] c3s  = {c3, 1'b0};
	wire [`DATA_WIDTH+5:0] e7e = {{2{e7[`DATA_WIDTH-1]}}, e7};

	wire [`DATA_WIDTH+5:0] s4, c4;
	csa #(`DATA_WIDTH+6) CSA4(.a(s3e), .b(c3s), .c(e7e), .sum(s4), .carry(c4));
	
	wire [`DATA_WIDTH+6:0] s4e = {1'b0, s4};
	wire [`DATA_WIDTH+6:0] c4s = {c4, 1'b0};
	wire [`DATA_WIDTH+6:0] c2s = {2'b0, c2, 1'b0};

	wire [`DATA_WIDTH+6:0] s5, c5;
	csa #(`DATA_WIDTH+7) CSA5(.a(s4e), .b(c4s), .c(c2s), .sum(s5), .carry(c5));
	
	wire signed [`DATA_WIDTH+8:0] sum_full = $signed({1'b0, s5}) + $signed({c5, 1'b0});

	always @(posedge clk or posedge rst) begin
		if(rst) sum_out <= 8'b0;
		else sum_out <= sum_full[7:0];
	end

//	always @(posedge clk or posedge rst) begin
//		if (rst) begin
//			sum_out <= 0;
//		end	else begin
//			sum_out <= w1 + w2 + w3 + w4 + w5 + w6 + w7;
//		end
//	end
endmodule

module _2to1_adder_1st(
	input clk,
	input rst,
	input signed [7:0] input1,
	input signed [7:0] input2,
	output reg signed [8:0] sum_out
);
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			sum_out <= 0;
		end else begin
			sum_out <= input1 + input2;
		end
	end
endmodule

module _2to1_adder_2nd(
	input clk,
	input rst,
	input signed [8:0] input1,
	input signed [8:0] input2,
	output reg signed [9:0] sum_out
);
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			sum_out <= 0;
		end else begin
			sum_out <= input1 + input2;
		end
	end
endmodule

module _2to1_adder_3rd(
	input clk,
	input rst,
	input signed [9:0] input1,
	input signed [9:0] input2,
	output reg signed [10:0] sum_out
);
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			sum_out <= 0;
		end else begin
			sum_out <= input1 + input2;
		end
	end
endmodule

module _56to1_adder (
	input clk,
	input rst,
	input in_valid,
	input [56*`DATA_WIDTH-1:0] weight_in,
	input [55:0] spike_in,
	output wire signed [10:0] sum_out,
	output out_valid
);
	wire signed [7:0] s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8;
	wire signed [8:0] s2_1, s2_2, s2_3, s2_4;
	wire signed [9:0] s3_1, s3_2;

	_7to1_adder A7_1(
		.clk(clk),
		.rst(rst),
		.weight_in(weight_in[7*`DATA_WIDTH-1:0]),
		.spike_in(spike_in[7-1:0]),
		.sum_out(s1_1)
	);
	_7to1_adder A7_2(
		.clk(clk),
		.rst(rst),
		.weight_in(weight_in[14*`DATA_WIDTH-1:7*`DATA_WIDTH]),
		.spike_in(spike_in[14-1:7]),
		.sum_out(s1_2)
	);
	_7to1_adder A7_3(
		.clk(clk),
		.rst(rst),
		.weight_in(weight_in[21*`DATA_WIDTH-1:14*`DATA_WIDTH]),
		.spike_in(spike_in[21-1:14]),
		.sum_out(s1_3)
	);
	_7to1_adder A7_4(
		.clk(clk),
		.rst(rst),
		.weight_in(weight_in[28*`DATA_WIDTH-1:21*`DATA_WIDTH]),
		.spike_in(spike_in[28-1:21]),
		.sum_out(s1_4)
	);
	_7to1_adder A7_5(
		.clk(clk),
		.rst(rst),
		.weight_in(weight_in[35*`DATA_WIDTH-1:28*`DATA_WIDTH]),
		.spike_in(spike_in[35-1:28]),
		.sum_out(s1_5)
	);
	_7to1_adder A7_6(
		.clk(clk),
		.rst(rst),
		.weight_in(weight_in[42*`DATA_WIDTH-1:35*`DATA_WIDTH]),
		.spike_in(spike_in[42-1:35]),
		.sum_out(s1_6)
	);
	_7to1_adder A7_7(
		.clk(clk),
		.rst(rst),
		.weight_in(weight_in[49*`DATA_WIDTH-1:42*`DATA_WIDTH]),
		.spike_in(spike_in[49-1:42]),
		.sum_out(s1_7)
	);
	_7to1_adder A7_8(
		.clk(clk),
		.rst(rst),
		.weight_in(weight_in[56*`DATA_WIDTH-1:49*`DATA_WIDTH]),
		.spike_in(spike_in[56-1:49]),
		.sum_out(s1_8)
	);
	

	_2to1_adder_1st A2_1_1(
		.clk(clk),
		.rst(rst),
		.input1(s1_1),
		.input2(s1_2),
		.sum_out(s2_1)
	);
	_2to1_adder_1st A2_1_2(
		.clk(clk),
		.rst(rst),
		.input1(s1_3),
		.input2(s1_4),
		.sum_out(s2_2)
	);
	_2to1_adder_1st A2_1_3(
		.clk(clk),
		.rst(rst),
		.input1(s1_5),
		.input2(s1_6),
		.sum_out(s2_3)
	);
	_2to1_adder_1st A2_1_4(
		.clk(clk),
		.rst(rst),
		.input1(s1_7),
		.input2(s1_8),
		.sum_out(s2_4)
	);


	_2to1_adder_2nd A2_2_1(
		.clk(clk),
		.rst(rst),
		.input1(s2_1),
		.input2(s2_2),
		.sum_out(s3_1)
	);
	_2to1_adder_2nd A2_2_2(
		.clk(clk),
		.rst(rst),
		.input1(s2_3),
		.input2(s2_4),
		.sum_out(s3_2)
	);


	_2to1_adder_3rd A2_3(
		.clk(clk),
		.rst(rst),
		.input1(s3_1),
		.input2(s3_2),
		.sum_out(sum_out)
	);

	reg [2:0] vpipe;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			vpipe <= 3'b0;
		end else begin
			vpipe <= {vpipe[1:0], in_valid};
		end
	end
	assign out_valid = vpipe[2];
endmodule
