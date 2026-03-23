module TOP(
	input clk,
	input rst,
	//input wsb1,
	//input wsb2,
	input start,
	input [56-1:0] spike_input,

	output wire [2:0] FSM_state,
	output reg step,
	output reg done_enc,
	output reg done_dec,
	output reg [`SUM_WIDTH-1:0] membrane_out
);

	localparam MEM_LOAD = 3'd0;
	localparam ENC_DATA = 3'd1;
	localparam ENC_COMP = 3'd2;
	localparam MEM_WRITE = 3'd3;
	localparam DEC_DATA = 3'd4;
	localparam DEC_COMP = 3'd5;
	localparam DONE = 3'd6;
	localparam IDLE = 3'd7;
	
	reg [1:0] state;
	reg	[9:0] neuron_idx, neuron_idx_next;
	wire next_neuron;
	reg [784-1:0] spike_input_store, spike_input_store_next;
	reg read_spike, read_spike_next;
	
	wire [56*4-1:0] weight1;
	wire [50*4-1:0] weight2;
	wire [10*4-1:0] weight3;
	wire [50*4-1:0] weight4;
	wire [`DATA_WIDTH-1:0] bias1;
	wire [`DATA_WIDTH-1:0] bias2;
	reg [56*4-1:0] weight;
	reg [56*4-1:0] weight_next;
	reg [10:0] addr;
	reg [10:0] addr_next;
	reg [56-1:0] spike_adder;
	reg [56-1:0] spike_adder_next;
	reg [9:0] addr_spike, addr_spike_next;
	wire signed [`SUM_WIDTH-1:0] adder_out;
	wire done_adder;
	
	reg [9:0] max_neuron;

	reg mode_AE;
	reg mode_AE_next;

	reg signed [`DATA_WIDTH:0] potential_mem_enc1 [0:99];
	reg signed [`SUM_WIDTH-1:0] potential_mem_enc2 [0:9];
	reg signed [`DATA_WIDTH:0] potential_mem_dec1 [0:99];
	reg signed [`SUM_WIDTH-1:0] potential_mem_dec2 [0:783];
	reg [99:0] spike_mem;
	wire [2*10-1:0] spike_dec;

	reg [9:0] addr_LIF, addr_LIF_next;
	reg [10*2-1:0] addr_LIF_delay_list;
	wire [9:0] addr_LIF_delay = addr_LIF_delay_list[19:10];

	wire [9:0] addr_LIF_r = (addr_LIF < 100) ? addr_LIF : (addr_LIF - 100);
	reg [10*2-1:0] addr_LIF_r_delay_list;
	wire [9:0] addr_LIF_r_delay = addr_LIF_r_delay_list[19:10];

	reg signed [`SUM_WIDTH-1:0] potential;
	wire signed [`SUM_WIDTH-1:0] potential_out;
	reg signed [`SUM_WIDTH-1:0] potential_next;
	reg signed [`DATA_WIDTH-1:0] bias_next;
	reg signed [`DATA_WIDTH-1:0] bias;
	wire done_LIF;

	reg [`SUM_WIDTH-1:0] membrane_out_next;
	reg done_enc_next;
	reg done_dec_next;

	reg open, close;
	wire last_neuron = (neuron_idx + 1) == max_neuron;
	wire last_done_adder = (addr_LIF_r + 1) == max_neuron && done_adder;
	reg [1:0] open_delay;
	reg step_next;
	reg [1:0] state_next;

	reg [3:0] mem_done_count;

	wire act = (FSM_state == ENC_DATA || FSM_state == DEC_DATA);

	reg accum;
	wire accum_next = (state == 1 || state == 3);

	wire spike_fire;

	integer i, j;

//	sorter784_top S0(
//		.clk(clk),
//		.reset(rst),
//		.delta(delta),
//		.spike(spike_input),
//		.en(start || step)
//	);

	spike_adder_controller C0(
		.clk(clk),
		.rst(rst),
		.spike(spike_adder),
		.state(state),
		.weight(weight),
		.FSM_state(FSM_state),
		.last_neuron(last_neuron),
		.next_neuron(next_neuron),
		.done(done_adder),
		.adder_out(adder_out)
	);

	enc1_rom enc1_rom(
		.clk(clk),
		.raddr(addr),
		.weight(weight1)
	);

	enc2_rom enc2_rom(
		.clk(clk),
		.raddr(addr[4:0]),
		.weight(weight2)
	);

	enc_bias_rom enc_bias_rom(
		.clk(clk),
		.raddr(addr_LIF[7:0]),
		.bias(bias1)
	);
	
	dec1_rom dec1_rom(
		.clk(clk),
		.raddr(addr[7:0]),
		.weight(weight3)
	);

	dec2_rom dec2_rom(
		.clk(clk),
		.raddr(addr),
		.weight(weight4)
	);

	dec_bias_rom dec_bias_rom(
		.clk(clk),
		.raddr(addr_LIF[9:0]),
		.bias(bias2)
	);
	
	LIF L1(
		.clk(clk),
		.en(done_adder),
		.reset(rst),
		.v(adder_out),
		.bias(bias),
		.potential(potential),
		.accum(accum),
		.potential_out(potential_out),
		.done(done_LIF),
		.spike(spike_fire)
	);

	FSM F1(
		.clk(clk),
		.rst(rst),
		.start(start),
		.open(open),
		.close(close),
		.state(state),
		.step(step),
		.mem_done(mem_done_count[3]),
		.FSM_state(FSM_state)
	);

	bottleneck B1(
		.clk(clk),
		.reset(rst),
		.en(done_enc),
		.bottleneck(membrane_out),
		.spike(spike_dec)
	);

	always @* begin
		case (state)
			2'd0: potential_next = potential_mem_enc1[addr_LIF_r];
			2'd1: potential_next = potential_mem_enc2[addr_LIF_r];
			2'd2: potential_next = potential_mem_dec1[addr_LIF_r];
			2'd3: potential_next = potential_mem_dec2[addr_LIF_r];
			default: potential_next = `SUM_WIDTH'd0;
		endcase
	end

	always @* begin
		if (FSM_state == DEC_DATA) mode_AE_next = 1'b1;
		else					   mode_AE_next = mode_AE;
	end

	always @ (posedge clk) begin
		if (rst) open_delay <= 0;
		else     open_delay <= {open_delay[0], last_done_adder};
	end

	always @* begin
		close = (neuron_idx == max_neuron - 1) && next_neuron;
		open = open_delay[1];
	end

	always @* begin
		case (state)
			2'd0: addr_spike_next = act ? (addr_spike == 728 ? 0 : addr_spike + 56) : 0;
			2'd1: addr_spike_next = act ? (addr_spike == 50 ? 0 : 50) : 0;
			2'd2: addr_spike_next = step ? 10 : 0;
			2'd3: addr_spike_next = act ? (addr_spike == 50 ? 0 : 50) : 0;
		endcase
	end

	always @* begin
		if (read_spike && state == 0)
			spike_input_store_next[addr_spike +: 56] = spike_input;
		else
			spike_input_store_next = spike_input_store;
	end

	always @* begin
		if (FSM_state != ENC_DATA) read_spike_next = 1;
		else
			if (addr_spike == 728)
				read_spike_next = 0;
			else
				read_spike_next = read_spike;
	end

	always @* begin
		case (state)
			2'd0:
				if (read_spike)
					spike_adder_next = spike_input;
				else
					spike_adder_next = spike_input_store[addr_spike +: 56];
			2'd1: begin
				spike_adder_next[49:0] = spike_mem[addr_spike +: 50];
				spike_adder_next[55:50] = 6'd0;
			end
			2'd2: begin
				spike_adder_next[9:0] = spike_dec[addr_spike +: 10];
				spike_adder_next[55:10] = 46'd0;
			end
			2'd3: begin
				spike_adder_next[49:0] = spike_mem[addr_spike +: 50];
				spike_adder_next[55:50] = 6'd0;
			end
			default: spike_adder_next = 56'd0;
		endcase
	end

	always @* begin
		if (FSM_state == ENC_DATA || FSM_state == DEC_DATA) begin
			case (state)
				2'd0: begin
					if (addr == 1399) addr_next = 0;
					else addr_next = addr + 1;
				end
				2'd1: begin
					if (addr == 19) addr_next = 0;
					else addr_next = addr + 1;
				end
				2'd2: begin
					if (addr == 99) addr_next = 0;
					else addr_next = addr + 1;
				end
				2'd3: begin
					if (addr == 1567) addr_next = 0;
					else addr_next = addr + 1;
				end
			endcase
		end else begin
			addr_next = 0;
		end
	end

	always @* begin
		case (state)
			2'd0: begin
				max_neuron = 100;
				if (addr_LIF_r + 1 == max_neuron && done_adder) begin
					weight_next[4*50-1:0] = weight2;
					weight_next[4*56-1:4*50] = 24'b0;
				end else begin
					weight_next = weight1;
				end
			end
			2'd1: begin
				max_neuron = 10;
				if (addr_LIF_r + 1 == max_neuron && done_adder) begin
					weight_next = weight1;
				end else begin
					weight_next[4*50-1:0] = weight2;
					weight_next[4*56-1:4*50] = 24'b0;
				end
			end
			2'd2: begin
				max_neuron = 100;
				if (addr_LIF_r + 1 == max_neuron && done_adder) begin
					weight_next[4*50-1:0] = weight4;
					weight_next[4*56-1:4*50] = 24'b0;
				end else begin
					weight_next[4*10-1:0] = weight3;
					weight_next[4*56-1:4*10] = 184'b0;
				end
			end
			2'd3: begin
				max_neuron = 784;
				if (addr_LIF_r + 1 == max_neuron && done_adder) begin
					weight_next[4*10-1:0] = weight3;
					weight_next[4*56-1:4*10] = 184'b0;
				end else
					weight_next[4*50-1:0] = weight4;
					weight_next[4*56-1:4*50] = 24'b0;
			end
			default: begin
				max_neuron = 0;
				weight_next = 0;
			end
		endcase
	end

	always @* begin
		if (state == 0 || state == 1) bias_next = bias1;
		else 						  bias_next = bias2;
	end

	always @* begin
		if (FSM_state == MEM_WRITE) step_next = 0;
		else if (done_adder && (addr_LIF_r + 1 == max_neuron) && (state == 1 || state == 3)) step_next = 1;
		else step_next = step;
	end

	always @* begin
		if (done_LIF)
			if (FSM_state == MEM_WRITE || (FSM_state == ENC_DATA && step && state == 1)) begin
				membrane_out_next = potential_out;
				done_dec_next = 0;
				done_enc_next = 1;
			end else if (FSM_state == DONE || (FSM_state == DEC_DATA && step && state == 3)) begin
				membrane_out_next = potential_out;
				done_dec_next = 1;
				done_enc_next = 0;
			end else begin
				membrane_out_next = `SUM_WIDTH'd0;
				done_dec_next = 0;
				done_enc_next = 0;
			end
		else begin
			membrane_out_next = `SUM_WIDTH'd0;
			done_dec_next = 0;
			done_enc_next = 0;
		end
	end
	
	always @* begin
		if (done_adder) begin
			if (mode_AE == 0)
				if (addr_LIF == 10'd109) addr_LIF_next = 0;
				else addr_LIF_next = addr_LIF + 1;
			else
				if (addr_LIF == 10'd883) addr_LIF_next = 0;
				else addr_LIF_next = addr_LIF + 1;
		end
		else addr_LIF_next = addr_LIF;
	end

	always @* begin
		if (next_neuron) begin
			if (neuron_idx + 1 == max_neuron) begin
				neuron_idx_next = 0;
			end else begin
				neuron_idx_next = neuron_idx + 1;
			end
		end else begin
			neuron_idx_next = neuron_idx;
		end
	end

	always @* begin
		if (addr_LIF_r + 1 == max_neuron && done_adder) begin
			if ((state == 1 || state == 3) && ~(FSM_state == MEM_WRITE)) state_next = state - 1;
			else state_next = state + 1;
		end else begin
			state_next = state;
		end
	end

	always @(posedge clk) begin
		if (rst) begin
			weight <= 0;
			addr <= 0;
			bias <= 0;
			read_spike <= 1;
			addr_spike <= 0;
			spike_adder <= 0;
			accum <= 0;
			potential <= 0;
			done_enc <= 0;
			done_dec <= 0;
			addr_LIF <= 10'd0;
			neuron_idx <= 10'd0;
			state <= 0;
			step <= 0;
			membrane_out <= `SUM_WIDTH'd0;
			mode_AE <= 0;
			spike_input_store <= 784'd0;
			addr_LIF_delay_list <= 0;
			addr_LIF_r_delay_list <= 0;
			mem_done_count <= 0;
		end else begin
			weight <= weight_next;
			addr <= addr_next;
			bias <= bias_next;
			read_spike <= read_spike_next;
			addr_spike <= addr_spike_next;
			spike_adder <= spike_adder_next;
			accum <= accum_next;
			potential <= potential_next;
			done_enc <= done_enc_next;
			done_dec <= done_dec_next;
			addr_LIF <= addr_LIF_next;
			neuron_idx <= neuron_idx_next;
			state <= state_next;
			step <= step_next;
			membrane_out <= membrane_out_next;
			mode_AE <= mode_AE_next;
			spike_input_store <= spike_input_store_next;
			addr_LIF_delay_list <= {addr_LIF_delay_list[9:0], addr_LIF};
			addr_LIF_r_delay_list <= {addr_LIF_r_delay_list[9:0], addr_LIF_r};
			mem_done_count <= {mem_done_count[2:0], (state == 2 && FSM_state == MEM_WRITE)};
		end
	end

	always @(posedge clk) begin
		if (rst) begin
			for (j = 0; j < 100; j = j + 1) begin
				potential_mem_enc1[j] <= 0;
				potential_mem_dec1[j] <= 0;
			end
			for (j = 0; j < 10; j = j + 1) begin
				potential_mem_enc2[j] <= 0;
			end
			for (j = 0; j < 784; j = j + 1) begin
				potential_mem_dec2[j] <= 0;
			end
		end else if (done_LIF) begin
			if (mode_AE == 0)
				if (addr_LIF_delay < 100)
					potential_mem_enc1[addr_LIF_r_delay] <= potential_out[4:0];
				else
					potential_mem_enc2[addr_LIF_r_delay] <= potential_out;
			else
				if (addr_LIF_delay < 100)
					potential_mem_dec1[addr_LIF_r_delay] <= potential_out[4:0];
				else
					potential_mem_dec2[addr_LIF_r_delay] <= potential_out;
		end else begin
			for (j = 0; j < 100; j = j + 1) begin
				potential_mem_enc1[j] <= potential_mem_enc1[j];
				potential_mem_dec1[j] <= potential_mem_dec1[j];
			end
			for (j = 0; j < 10; j = j + 1) begin
				potential_mem_enc2[j] <= potential_mem_enc2[j];
			end
			for (j = 0; j < 784; j = j + 1) begin
				potential_mem_dec2[j] <= potential_mem_dec2[j];
			end
		end
	end

	always @(posedge clk) begin
		if (rst)
			for (j = 0; j < 100; j = j + 1)
				spike_mem[j] <= 0;
		else
			if (done_LIF)
				if (mode_AE == 0 && addr_LIF_delay < 100)
					spike_mem[addr_LIF_r_delay] <= spike_fire;
				else if (mode_AE == 1 && addr_LIF_delay < 100)
					spike_mem[addr_LIF_r_delay] <= spike_fire;
				else
					for (j = 0; j < 100; j = j + 1)
						spike_mem[j] <= spike_mem[j];
			else
				for (j = 0; j < 100; j = j + 1)
					spike_mem[j] <= spike_mem[j];
	end



task load_param(
    input [4*78400-1:0] reg_enc1,
    input [4*1000-1:0] reg_enc2,
    input [4*110-1:0] reg_enc_bias,
	input [4*1000-1:0] reg_dec1,
    input [4*78400-1:0] reg_dec2,
    input [4*884-1:0] reg_dec_bias
);
    begin
        for(j=0; j<1400; j=j+1) begin
            enc1_rom.load_param(j, reg_enc1[4*56*j +: 4*56]);
        end
        for(j=0; j<20; j=j+1) begin
            enc2_rom.load_param(j, reg_enc2[4*50*j +: 4*50]);
        end
        for(j=0; j<110; j=j+1) begin
            enc_bias_rom.load_param(j, reg_enc_bias[4*j +: 4]);
        end
		for(j=0; j<100; j=j+1) begin
			dec1_rom.load_param(j, reg_dec1[4*10*j +: 4*10]);
		end
		for(j=0; j<1568; j=j+1) begin
			dec2_rom.load_param(j, reg_dec2[4*50*j +: 4*50]);
		end
		for(j=0; j<884; j=j+1) begin
			dec_bias_rom.load_param(j, reg_dec_bias[4*j +: 4]);
		end
    end
endtask
endmodule
