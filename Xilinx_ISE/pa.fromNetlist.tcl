
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name LCD_Project -dir "E:/projects/Xilinx/LCD_Project/planAhead_run_2" -part xc6slx9ftg256-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/projects/Xilinx/LCD_Project/top_LCD.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/projects/Xilinx/LCD_Project} {ipcore_dir} }
add_files [list {ipcore_dir/fifo.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ram2.ncf}] -fileset [get_property constrset [current_run]]
set_param project.pinAheadLayout  yes
set_property target_constrs_file "top_LCD.ucf" [current_fileset -constrset]
add_files [list {top_LCD.ucf}] -fileset [get_property constrset [current_run]]
link_design
