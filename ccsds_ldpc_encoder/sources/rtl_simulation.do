#设置testbench模块名(将[]替换为testbench模块名)
set x_tb ccsds_ldpc_encoder_tb
#设置器件厂家(将[]替换为 xilinx 或 altera )
set MFR xilinx
#是否使用了IP核(use_IP=1代表使用了IP核,use_IP=0代表没有使用IP核)
set use_IP 0
#设定xilinx库路径
set xilinx_path {D:/Modelsim/xilinx2021_lib}
#设定altera库路径
#set altera_path {D:/Modelsim/altera_lib}

#退出当前仿真，因为打开软件时候，可能停留在上一个工程
quit -sim
#清除命令行显示信息
.main clear
#在rtl_sim文件夹中创建一个work文件夹 
vlib ./work    
#将modelsim中的work库与work文件夹相关联
vmap work ./work  
#编译sources-IP-ip_sim文件夹下所有的.v文件(IP仿真网表文件)，编译结果存放到work逻辑库里面  
if {$use_IP=="1"} {  
vlog -work work ../sources/IP/ip_sim/*.v
}
#编译sources-RTL文件夹下所有的.v文件(设计文件)，编译结果存放到work逻辑库里面  
vlog -work work ../sources/RTL/*.v
#编译sources-TB文件夹下所有的.v文件(测试文件)，编译结果存放到work逻辑库里面  
vlog -work work ../sources/TB/*.v
#调用testbench文件启动仿真
if {$MFR=="xilinx"} {  
vsim -voptargs=+acc work.$x_tb  -L $xilinx_path/simprims_ver
} elseif {$MFR=="altera"}  { 
vsim -voptargs=+acc work.$x_tb  -L $altera_path/altera_mf  -L $altera_path/altera_primitive  -L $altera_path/cyclone  -L $altera_path/lpm
} else {
puts *******************The "MFR" is wrong!*******************
}
#添加观测信号
add wave $x_tb/*
#执行仿真
run -all
#保存命令行信息
file copy -force "./transcript" "./report"