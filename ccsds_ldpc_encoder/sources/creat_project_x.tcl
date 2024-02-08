# 设置工程名(将[]替换为工程名)
set project_name ccsds_ldpc_encoder
# 设置芯片型号(将[]替换为芯片型号)
set chip_type xc7a200tfbg484-1
# 是否将当前设计导出为自定义IP核(ip_out_p=1进行)
set ip_out_p 1
# 是否进行综合操作(synth_p=1进行)
set synth_p 0
# 是否进行布局布线、生成比特流的操作(bitstream_p=1进行)
set bitstream_p 0
# 是否在所有操作结束后关闭工程(close_p=1关闭)
set close_p 1

# 规定线程数(提升线程数可以使运行更快)
set_param general.maxThreads 12
#新建outputs文件夹,存储 RTL视图、比特流文件、综合报告等输出
file delete -force ./outputs
file mkdir ./outputs
# 创建工程
create_project -part $chip_type -force $project_name    
# 添加RTL设计文件至sources_1文件集
add_files -fileset sources_1 -norecurse -scan_for_includes ../sources/RTL
# 添加测试文件至sim_1文件集
add_files -fileset sim_1 -norecurse -scan_for_includes ../sources/TB
# 添加约束文件至constrs_1文件集
if {$bitstream_p=="1"} {
add_files -fileset constrs_1 ../sources/CONSTRS
}
# 更新编译顺序(形成模块间的层次关系,找到顶层模块)
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
# 生成RTL视图并导出为PDF
synth_design -rtl -rtl_skip_mlo -name rtl_1
write_schematic -format pdf -orientation portrait ./schematic.pdf
file copy -force ./schematic.pdf ./outputs/schematic.pdf
file delete -force ./schematic.pdf

# 将当前设计导出为IP
if {$ip_out_p=="1"} { 
file delete -force ../../$project_name/my_ip/$project_name
file mkdir ../../$project_name/my_ip/$project_name
file mkdir ../../$project_name/my_ip/$project_name/misc
file copy ../sources/LOGO/logo.png ../../$project_name/my_ip/$project_name/misc/logo.png

ipx::package_project -root_dir ../../$project_name/my_ip/$project_name -vendor xilinx.com -library user -taxonomy /UserIP -import_files -set_current false
ipx::unload_core ../../$project_name/my_ip/$project_name/component.xml
ipx::edit_ip_in_project -upgrade true -name tmp_edit_project -directory ../../$project_name/my_ip/$project_name ../../$project_name/my_ip/$project_name/component.xml

set_property name $project_name [ipx::current_core]
set_property version 1.0 [ipx::current_core]
set_property display_name $project_name [ipx::current_core]

set_property description {wyxee2000@163.com} [ipx::current_core]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "stander" -component [ipx::current_core]] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "width" -component [ipx::current_core]] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
set_property widget {textEdit} [ipgui::get_guiparamspec -name "stander" -component [ipx::current_core] ]
set_property tooltip {8176,7154 and 8160,7136 for near earth, others for deep space applications.} [ipgui::get_guiparamspec -name "stander" -component [ipx::current_core] ]
set_property widget {textEdit} [ipgui::get_guiparamspec -name "width" -component [ipx::current_core] ]
set_property tooltip {Parallel encoding bit width.} [ipgui::get_guiparamspec -name "width" -component [ipx::current_core] ]
set_property widget {comboBox} [ipgui::get_guiparamspec -name "stander" -component [ipx::current_core] ]
set_property value_validation_list {"8176,7154" "8160,7136" "1280,1024" "1536,1024" "2048,1024" "5120,4096" "6144,4096" "8192,4096" "20480,16384" "24576,16384" "32768,16384"} [ipx::get_user_parameters stander -of_objects [ipx::current_core]]

cd ../../$project_name/my_ip/$project_name
ipx::add_file_group -type misc {} [ipx::current_core]
ipx::add_file ./misc/logo.png [ipx::get_file_groups xilinx_miscfiles -of_objects [ipx::current_core]]
set_property type image [ipx::get_files misc/logo.png -of_objects [ipx::get_file_groups xilinx_miscfiles -of_objects [ipx::current_core]]]
ipx::add_file_group -type utility {} [ipx::current_core]
ipx::add_file ./misc/logo.png [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]
set_property type image [ipx::get_files misc/logo.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
set_property type LOGO [ipx::get_files misc/logo.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
cd ../../project

ipx::update_source_project_archive -component [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::move_temp_component_back -component [ipx::current_core]
close_project -delete
}

# 进行综合
if {$synth_p=="1"} {
launch_runs synth_1 -jobs 12
wait_on_run synth_1
}

# 布局布线、生成比特流(若不使用wait_on_run命令,布局布线还没执行完就会执行生成比特流的命令,从而导致错误)
if {$bitstream_p=="1"} { 
launch_runs impl_1 -jobs 12
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 12
wait_on_run impl_1
file copy -force ./$project_name.runs/impl_1/$project_name.bit ./outputs/$project_name.bit
file delete -force ./$project_name.runs/impl_1/$project_name.bit
}

# 结束后关闭工程
if {$close_p=="1"} { 
close_project
stop_gui
exit
}