#!/bin/bash -f
xv_path="/softslin/vivado_17.1/Vivado/2017.1"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim recep_rs232_vhd_tst_behav -key {Behavioral:sim_1:Functional:recep_rs232_vhd_tst} -tclbatch recep_rs232_vhd_tst.tcl -log simulate.log
