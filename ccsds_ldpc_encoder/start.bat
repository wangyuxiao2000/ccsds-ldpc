@echo off
setlocal enabledelayedexpansion

:begin
echo;
echo;
echo **************FPGA Design Platform**************
echo Author  : WangYuxiao
echo Email   : wyxee2000@163.com
echo Version : V 1.0  
echo;                                       
echo Enter "1" for RTL Simulation Model
echo Enter "2" for Vivado Model
echo Enter "3" for Vitis HLS Model
echo Enter "4" to exit 
echo ************************************************
set option=0
set/p option=

::::::::::::使用Modelsim运行RTL仿真::::::::::::
if "!option!"=="1" (
:rtl_model
echo;
echo;
echo **************RTL Simulation Model**************
echo Enter "1" to reset RTL Simulation
echo Enter "2" to run RTL Simulation
echo Enter "3" to view the RTL simulation result
echo Enter "4" to exit RTL Simulation Model
echo ************************************************
set rtl_choose=0
set/p rtl_choose=

if "!rtl_choose!"=="1" (
if not exist rtl_sim (
echo There is no rtl_sim project.
goto rtl_model
)else (
del/f/s/q rtl_sim\*.*
rd/s/q rtl_sim
goto rtl_model
)
)

if "!rtl_choose!"=="2" (
if not exist rtl_sim (
md rtl_sim
)
if exist ./sources\rtl_simulation.do (
copy "./sources\rtl_simulation.do" "rtl_sim" /y
)else (
echo Missing file rtl_simulation.do in "sources"
goto rtl_model
)
cd ./rtl_sim
if not exist report (
md report
)
modelsim -do rtl_simulation.do
cd ../
goto rtl_model
)

if "!rtl_choose!"=="3" (
if not exist rtl_sim (
echo There is no rtl_sim project.
goto rtl_model
)else (
if exist ./sources\rtl_simulation_results.do (
copy "./sources\rtl_simulation_results.do" "rtl_sim" /y
)else (
echo Missing file rtl_simulation_results.do in "sources"
goto rtl_model
)
cd ./rtl_sim
start notepad "./report/transcript"
modelsim -do rtl_simulation_results.do
cd ../
goto rtl_model
)
)

if "!rtl_choose!"=="4" (
goto begin
)else (
echo INVALID ENTRY
goto rtl_model
)

)

::::::::::::使用Vivado建立工程::::::::::::
if "!option!"=="2" (
:vivado_model
echo;
echo;
echo ******************Vivado Model******************
echo Enter "1" to reset Vivado project
echo Enter "2" to creat Vivado project
echo Enter "3" to exit Vivado Model
echo ************************************************
set vivado_choose=0
set/p vivado_choose=

if "!vivado_choose!"=="1" (
if not exist project (
echo There is no Vivado project.
goto vivado_model
)else (
del/f/s/q project\*.*
rd/s/q project
goto vivado_model
)
)

if "!vivado_choose!"=="2" (
if not exist project (
md project
)
if exist ./sources\creat_project_x.tcl (
copy "./sources\creat_project_x.tcl" "project" /y
)else (
echo Missing file creat_project_x.tcl in "sources"
goto vivado_model
)
cd ./project
start cmd /c vivado -source creat_project_x.tcl
cd ../
goto vivado_model
)

if "!vivado_choose!"=="3" (
goto begin
)else (
echo INVALID ENTRY
goto vivado_model
)

)

::::::::::::使用Vitis HLS建立工程::::::::::::
if "!option!"=="3" (
:hls_model
echo;
echo;
echo ****************Vitis HLS Model*****************-0
echo Enter "1" to reset HLS project
echo Enter "2" to creat HLS project
echo Enter "3" to exit HLS Model
echo ************************************************
set hls_choose=0
set/p hls_choose=

if "!hls_choose!"=="1" (
if not exist project (
echo There is no HLS project.
goto hls_model
)else (
del/f/s/q project\*.*
rd/s/q project
goto hls_model
)
)

if "!hls_choose!"=="2" (
if not exist project (
md project
)
if exist ./sources\creat_project_h.tcl (
copy "./sources\creat_project_h.tcl" "project" /y
)else (
echo Missing file creat_project_h.tcl in "sources"
goto hls_model
)
cd ./project
start cmd /c vitis_hls -f creat_project_h.tcl
cd ../
goto hls_model
)

if "!hls_choose!"=="3" (
goto begin
)else (
echo INVALID ENTRY
goto hls_model
)

)

::::::::::::退出::::::::::::
if "!option!"=="4" (
exit)else (
echo INVALID ENTRY
goto begin
)

pause