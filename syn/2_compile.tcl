# before synthesis settings
set case_analysis_with_logic_constants true
set_fix_multiple_port_nets -feedthroughs -outputs -constants -buffer_constants

####check design####
# Checks for possible timing problems in the current design
check_design > ./$RPT_DIR/check_design.log
# Checks the current design for consistency
check_timing > ./$RPT_DIR/check_timing.log

set_clock_gating_style -max_fanout 10

# Synthesis all design (using : compile_ultra)
# you can add "-gate_clock" to do gated-clock
# you can add "-incremental" for higher performance
compile_ultra -exact_map -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -gate_clock

# remove dummy ports
remove_unconnected_ports [get_cells -hierarchical *]
# decompose buses and remove dummy ports
remove_unconnected_ports [get_cells -hierarchical *] -blast_buses
