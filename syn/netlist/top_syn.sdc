###################################################################

# Created by write_sdc on Wed Nov 19 18:15:42 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions PVT_1P08V_125C -library slow_vdd1v2
set_wire_load_mode enclosed
set_wire_load_model -name Large -library slow_vdd1v2
set_max_fanout 20 [current_design]
set_max_area 0
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports clk]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports rst]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
start]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[55]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[54]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[53]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[52]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[51]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[50]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[49]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[48]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[47]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[46]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[45]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[44]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[43]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[42]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[41]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[40]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[39]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[38]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[37]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[36]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[35]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[34]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[33]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[32]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[31]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[30]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[29]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[28]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[27]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[26]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[25]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[24]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[23]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[22]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[21]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[20]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[19]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[18]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[17]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[16]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[15]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[14]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[13]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[12]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[11]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[10]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[9]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[8]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[7]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[6]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[5]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[4]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[3]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[2]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[1]}]
set_driving_cell -lib_cell DFFHQX1 -library slow_vdd1v2 -pin Q [get_ports      \
{spike_input[0]}]
set_load -pin_load 0.00033692 [get_ports {FSM_state[2]}]
set_load -pin_load 0.00033692 [get_ports {FSM_state[1]}]
set_load -pin_load 0.00033692 [get_ports {FSM_state[0]}]
set_load -pin_load 0.00033692 [get_ports step]
set_load -pin_load 0.00033692 [get_ports done_enc]
set_load -pin_load 0.00033692 [get_ports done_dec]
set_load -pin_load 0.00033692 [get_ports {membrane_out[11]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[10]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[9]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[8]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[7]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[6]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[5]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[4]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[3]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[2]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[1]}]
set_load -pin_load 0.00033692 [get_ports {membrane_out[0]}]
set_ideal_network [get_ports clk]
create_clock [get_ports clk]  -period 2.5  -waveform {0 1.25}
set_input_delay -clock clk  1.25  [get_ports rst]
set_input_delay -clock clk  1.25  [get_ports start]
set_input_delay -clock clk  1.25  [get_ports {spike_input[55]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[54]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[53]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[52]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[51]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[50]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[49]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[48]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[47]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[46]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[45]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[44]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[43]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[42]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[41]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[40]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[39]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[38]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[37]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[36]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[35]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[34]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[33]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[32]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[31]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[30]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[29]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[28]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[27]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[26]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[25]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[24]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[23]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[22]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[21]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[20]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[19]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[18]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[17]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[16]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[15]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[14]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[13]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[12]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[11]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[10]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[9]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[8]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[7]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[6]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[5]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[4]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[3]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[2]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[1]}]
set_input_delay -clock clk  1.25  [get_ports {spike_input[0]}]
set_output_delay -clock clk  1.25  [get_ports {FSM_state[2]}]
set_output_delay -clock clk  1.25  [get_ports {FSM_state[1]}]
set_output_delay -clock clk  1.25  [get_ports {FSM_state[0]}]
set_output_delay -clock clk  1.25  [get_ports step]
set_output_delay -clock clk  1.25  [get_ports done_enc]
set_output_delay -clock clk  1.25  [get_ports done_dec]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[11]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[10]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[9]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[8]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[7]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[6]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[5]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[4]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[3]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[2]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[1]}]
set_output_delay -clock clk  1.25  [get_ports {membrane_out[0]}]
set_clock_gating_check -rise -setup 0 [get_cells                               \
B1/clk_gate_counter_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells                               \
B1/clk_gate_counter_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells                                \
B1/clk_gate_counter_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells                                \
B1/clk_gate_counter_reg/main_gate]
