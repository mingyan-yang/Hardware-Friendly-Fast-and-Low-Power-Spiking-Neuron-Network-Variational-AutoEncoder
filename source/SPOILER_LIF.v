module LIF(
    input en,
    input clk,
    input reset,
    input signed [`SUM_WIDTH-1:0] v,
	input signed [`DATA_WIDTH-1:0] bias,
    input signed [`SUM_WIDTH-1:0] potential,
	input accum,
	output reg signed [`SUM_WIDTH-1:0] potential_out,
	output reg done,
    output reg spike
);

	localparam signed VTH = 6'd16;

    reg next_spike;
    reg signed [`SUM_WIDTH-1:0] next_potential;
	reg next_done;

	reg accum_ff;
	reg signed [`SUM_WIDTH-1:0] v_ff;
	reg en_ff;

    always @(posedge clk) begin
        if (reset) begin
			accum_ff  <= 0;
			v_ff      <= 0;
			en_ff     <= 0;
            spike     <= 0;
			potential_out <= 0;
        end else begin
			accum_ff      <= accum;
			v_ff          <= v;
			en_ff         <= en;
            potential_out <= (en_ff && next_spike) ? 0 : next_potential;
            spike     	  <= next_spike;
			done 		  <= next_done;
        end
    end

    always @(*) begin
        if (en_ff) begin
			next_done 	  	   = 1;
			if (accum_ff) begin
				next_spike     = 0;
				next_potential = potential + v_ff + bias;
			end else begin 
				next_potential = ((potential >>> 1) + v_ff + bias < -16) ? -16 : (potential >>> 1) + v_ff + bias;
				next_spike     = (next_potential >= VTH) ? 1 : 0;
			end
        end else begin
            next_potential     = potential;
            next_spike         = spike;
			next_done          = 0;
        end	
    end
    
endmodule
