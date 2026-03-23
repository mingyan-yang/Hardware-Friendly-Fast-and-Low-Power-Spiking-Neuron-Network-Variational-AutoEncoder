# Setting Design and I/O Environment
set_operating_conditions -library slow_vdd1v2 PVT_1P08V_125C
# Assume outputs go to DFF and inputs also come from DFF
set_driving_cell -library slow_vdd1v2 -lib_cell DFFHQX1 -pin {Q} [all_inputs]
set_load [load_of "slow_vdd1v2/DFFHQX1/D"] [all_outputs]

# Setting wireload model
# ⽤ enclosed 的⽅式來決定 sub blocks 間的 wire
set_wire_load_mode enclosed
# TOP module 使⽤"Large" wire load
set_wire_load_model -name "Large" $TOPLEVEL

# Setting Timing Constraints
###  ceate your clock here
create_clock -name clk -period $TEST_CYCLE [get_ports clk]
###  set clock constrain
# ideal_network 忽略訊號 driving 能⼒問題
set_ideal_network [get_ports clk]
# 在這條路徑上不因時間考量⽽加入 buffer
set_dont_touch_network [all_clocks]

# I/O delay should depend on the real enironment. Here only shows an example of setting

# 設定 I/O 兩端所連接電路的 delay
# I/O delay should depend on the real environment
# 針對除了 clk 外的所有 primary I/O
set_input_delay [expr $TEST_CYCLE/2.0] -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay [expr $TEST_CYCLE/2.0] -clock clk [all_outputs]

# Setting DRC Constraint
# Defensive setting: default fanout_load 1.0 and our target max fanout # 20 => 1.0*20 = 20.0
# max_transition and max_capacitance are given in the cell library
set_max_fanout 20.0 $TOPLEVEL

# Area Constraint
set_max_area 0
