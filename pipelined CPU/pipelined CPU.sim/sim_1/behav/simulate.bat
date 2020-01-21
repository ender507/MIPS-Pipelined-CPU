@echo off
set xv_path=D:\\vivado_data\\Vivado\\2015.4\\bin
call %xv_path%/xsim CPUsim_behav -key {Behavioral:sim_1:Functional:CPUsim} -tclbatch CPUsim.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
