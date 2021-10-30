
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name LCD_Project -dir "E:/projects/Xilinx/LCD_Project/planAhead_run_5" -part xc6slx9ftg256-2
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "E:/projects/Xilinx/LCD_Project/top_LCD.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/projects/Xilinx/LCD_Project} {ipcore_dir} }
add_files [list {ipcore_dir/fifo.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ram2.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "top_LCD.ucf" [current_fileset -constrset]
add_files [list {top_LCD.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "E:/projects/Xilinx/LCD_Project/top_LCD.xdl"
if {[catch {read_twx -name results_1 -file "E:/projects/Xilinx/LCD_Project/top_LCD.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"E:/projects/Xilinx/LCD_Project/top_LCD.twx\": $eInfo"
}
