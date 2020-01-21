@echo off
set xv_path=D:\\vivado_data\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto c2679034c76e4921b12ba88a5752478e -m64 --debug typical --relax --mt 2 -L dist_mem_gen_v8_0_9 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot CPUsim_behav xil_defaultlib.CPUsim xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
