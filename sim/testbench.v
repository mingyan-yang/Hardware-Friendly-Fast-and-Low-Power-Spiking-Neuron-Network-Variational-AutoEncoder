//`timescale 1ns / 100ps

module testbench;

	parameter period = 2;
	parameter delay = 1;

	integer i, j, k, l, m, idx = 0, pat = 0, t1, t2, t3, _, s;
	
	reg [3:0] enc1_w [0:78400-1];
	reg [4*78400-1:0] enc1_w_flat;
	reg [3:0] enc2_w [0:1000-1];
	reg [4*1000-1:0] enc2_w_flat;
	reg [3:0] dec1_w [0:1000-1];
	reg [4*1000-1:0] dec1_w_flat;
	reg [3:0] dec2_w [0:78400-1];
	reg [4*78400-1:0] dec2_w_flat;
	reg [3:0] enc1_b [0:99];
	reg [3:0] enc2_b [0:9];
	reg [3:0] dec1_b [0:99];
	reg [3:0] dec2_b [0:783];
	reg [4*110-1:0] enc_bias_flat;
	reg [4*884-1:0] dec_bias_flat;

	reg clk, reset, start;
	reg [783:0] pattern [0:2*10000-1];
	reg [56-1:0] spike_input;
	wire [2:0] FSM_state;
	wire done_adder;
	wire step;
	wire done_enc;
	wire done_dec;
	wire signed [`SUM_WIDTH-1:0] membrane_out;

	reg signed [`SUM_WIDTH-1:0] enc_out_golden [0:10*10000-1];
	reg signed [`SUM_WIDTH-1:0] dec_out_golden [0:784*10000-1];

	reg signed [`SUM_WIDTH-1:0] golden_mem [0:219];
	reg signed [`SUM_WIDTH-1:0] golden_mem2 [0:1767];
	reg mismatch;
	reg mismatch_enc;
	reg mismatch_dec;

	integer cycles;

	reg weight_valid, bias_valid;

	localparam MEM_LOAD = 3'd0;
	localparam MEM_WRITE = 3'd3;

	TOP top (
		.clk(clk),
		.rst(reset),
		.start(start),
		.spike_input(spike_input),
		.step(step),
		.FSM_state(FSM_state),
		.done_enc(done_enc),
		.done_dec(done_dec),
		.membrane_out(membrane_out)
	);


	initial begin
    	$fsdbDumpfile("./Simulation_Result/test.fsdb");
    	$fsdbDumpvars;
	end
/*
	initial begin
	    $readmemh("./golden/golden.mem", golden_mem);
		$readmemh("./golden/golden2.mem", golden_mem2);

		idx = 0;
		mismatch = 0;
		
		for (i = 0; i < 220; i = i + 1) begin
			@(posedge done_adder) begin
				if (golden_mem[idx] !== adder_out) begin
					$display("Mismatch occur!, neuron = %d, adder_out = %d, golden = %d", idx, adder_out, golden_mem[idx]);
					mismatch = 1;
				end
				idx = idx + 1;
			end
		end
		
		if (~mismatch) $display("All results are correct!");
	
		idx = 0;
		mismatch = 0;
	
		wait (done_enc);

		for (l = 0; l < 1768; l = l + 1) begin
			@(negedge clk) begin
				if (done_adder) begin
					if (golden_mem2[idx] !== adder_out) begin
						$display("Mismatch occur!, neuron = %d, adder_out = %d, golden = %d", idx, adder_out, golden_mem2[idx]);
						mismatch = 1;
					end
					idx = idx + 1;
				end
			end
		end

		if (~mismatch) $display("All results are correct!");
	end
*/
	initial begin
		cycles = 0;
		while (1)
			@(posedge clk) begin
				if (done_enc) cycles = 1;
				else		  cycles = cycles + 1;
			end
	end

	initial begin
		$readmemh("./golden/enc_out.mem", enc_out_golden);
		$readmemh("./golden/dec_out.mem", dec_out_golden);

		for (t1 = 0; t1 < 10000; t1 = t1 + 1) begin
			$display("========================%d=========================", t1);

			mismatch_enc = 0;
			mismatch_dec = 0;
			
			for (k = 0; k < 10; k = k + 1) begin
				@(posedge done_enc) begin
					if (enc_out_golden[k + t1 * 10] !== membrane_out) begin
						$display ("Mismatch occur, idx = %d, encoder_out = %d, golden = %d", k, membrane_out, $signed(enc_out_golden[k + t1 * 10]));
						mismatch_enc = 1;
					end
				end
			end

			for (m = 0; m < 784; m = m + 1) begin
				@(posedge done_dec) begin
					if (dec_out_golden[m + t1 * 784] !== membrane_out) begin
						$display ("Mismatch occur, idx = %d, decoder_out = %d, golden = %d", m, membrane_out, $signed(dec_out_golden[m + t1 * 784]));
						mismatch_dec = 1;
					end
				end
			end

			if (~mismatch_enc) $display("All encoder output are correct!");
			if (~mismatch_dec) $display("All decoder output are correct!");

			if (mismatch_dec || mismatch_enc) $finish;
		end
	end
	
	initial begin
    	clk = 0;
    	while(1) #(period/2) clk = ~clk;
	end

	initial begin
		for (t2 = 0; t2 < 10000; t2 = t2 + 1) begin
    		reset = 0;
			start = 0;
			#(period * 1 + delay) reset = 1;
			#(period * 2) reset = 0;
			#(period * 0.5) start = 1;
			#(period * 1) start = 0;
			for (_ = 0; _ < 784; _ = _ + 1) begin
				wait (done_dec);
				wait (~done_dec);
			end
			/*wait (done_enc)
			#(period * 10);
			mem_done = 1;
			wait (done_dec)
			#(period * 10);*/
		end
	end

	initial begin
		$readmemb("./pat/pattern.mem", pattern);

		for (t3 = 0; t3 < 10000; t3 = t3 + 1) begin
			wait (reset == 1);
			wait (reset == 0);
			#(period * 1);
			for (s = 0; s < 14; s = s + 1)
				@(negedge clk) begin
					spike_input = pattern[t3 * 2 + 0][s * 56 +: 56];
				end
			wait (step);
			#(period * 2);
			for (s = 0; s < 14; s = s + 1)
				@(negedge clk) begin
					spike_input = pattern[t3 * 2 + 1][s * 56 +: 56];
				end
			wait (done_dec);
		end
	end

	initial begin
		#(200000000);
		$finish;
	end


initial 
begin
	$readmemb("param/enc1_weight.mem", enc1_w);
	for (j = 0; j < 78400; j = j + 1) begin
		enc1_w_flat[j*4 +: 4] = enc1_w[j];
	end
	$readmemb("param/enc2_weight.mem", enc2_w);
	for(j=0; j<1000; j=j+1) begin
		enc2_w_flat[j*4 +: 4] = enc2_w[j];
	end
	$readmemb("param/enc1_bias.mem", enc1_b);
	for(j=0; j<100; j=j+1) begin
		enc_bias_flat[j*4 +: 4] = enc1_b[j];
	end
	$readmemb("param/enc2_bias.mem", enc2_b);
	for(j=0; j<10; j=j+1) begin
		enc_bias_flat[(j + 100)*4 +: 4] = enc2_b[j];
	end
	$readmemb("param/dec1_weight.mem", dec1_w);
	for (j = 0; j < 1000; j = j + 1) begin
		dec1_w_flat[j*4 +: 4] = dec1_w[j];
	end
	$readmemb("param/dec2_weight.mem", dec2_w);
	for(j=0; j<78400; j=j+1) begin
		dec2_w_flat[j*4 +: 4] = dec2_w[j];
	end
	$readmemb("param/dec1_bias.mem", dec1_b);
	for(j=0; j<100; j=j+1) begin
		dec_bias_flat[j*4 +: 4] = dec1_b[j];
	end
	$readmemb("param/dec2_bias.mem", dec2_b);
	for(j=0; j<784; j=j+1) begin
		dec_bias_flat[(j + 100)*4 +: 4] = dec2_b[j];
	end
	top.load_param(enc1_w_flat, enc2_w_flat, enc_bias_flat, dec1_w_flat, dec2_w_flat, dec_bias_flat);
end

endmodule
