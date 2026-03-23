verdiSetActWin -dock widgetDock_<Decl._Tree>
debImport "-f" "../sim_rtl.f"
wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/home/u111/u111061243/SNN/project/sim/Simulation_Result/test.fsdb}
verdiWindowResize -win $_Verdi_1 "318" "82" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvSetCursor -win $_nWave2 688.908322
verdiSetActWin -win $_nWave2
debExit
