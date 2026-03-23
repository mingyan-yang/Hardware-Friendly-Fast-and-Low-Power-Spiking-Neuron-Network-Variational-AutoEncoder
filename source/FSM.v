module FSM (
	input clk,
	input rst,
	input start,
	input open,
	input close,
	input [1:0] state,
	input step,
	input mem_done,
	output reg [2:0] FSM_state
);

	localparam MEM_LOAD = 3'd0;
	localparam ENC_DATA = 3'd1;
	localparam ENC_COMP = 3'd2;
	localparam MEM_WRITE = 3'd3;
	localparam DEC_DATA = 3'd4;
	localparam DEC_COMP = 3'd5;
	localparam DONE = 3'd6;
	localparam IDLE = 3'd7;

	reg [2:0] state_next;

	always @* begin
		case (FSM_state)
			IDLE:
				if (start) state_next = ENC_DATA;
				else state_next = IDLE;
			MEM_LOAD:
				if (mem_done) state_next = ENC_DATA;
				else state_next = MEM_LOAD;
			ENC_DATA:
				if (close) 
					if (state == 1 && step) state_next = MEM_WRITE;
					else state_next = ENC_COMP;
				else state_next = ENC_DATA;
			ENC_COMP:
				if (open) state_next = ENC_DATA;
				else state_next = ENC_COMP;
			MEM_WRITE:
				if (mem_done) state_next = DEC_DATA;
				else state_next = MEM_WRITE;
			DEC_DATA:
				if (close)
					if (state == 3 && step) state_next = DONE;
					else state_next = DEC_COMP;
				else state_next = DEC_DATA;
			DEC_COMP:
				if (open) state_next = DEC_DATA;
				else state_next = DEC_COMP;
			DONE:
				state_next = DONE;
			default:
				state_next = IDLE;
		endcase
	end

	always @(posedge clk) begin
		if (rst) FSM_state <= IDLE;
		else FSM_state <= state_next;
	end
endmodule	
