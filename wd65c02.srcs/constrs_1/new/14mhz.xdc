create_clock -period 70.000 -name phi2 -waveform {0.000 35.000} [get_ports phi2]
set_input_delay -clock [get_clocks phi2] -clock_fall -min -add_delay 10.000 [get_ports {data_in[*]}]
set_input_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 60.000 [get_ports {data_in[*]}]
set_input_delay -clock [get_clocks phi2] -clock_fall -min -add_delay 35.000 [get_ports RES]
set_input_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 35.000 [get_ports RES]
set_output_delay -clock [get_clocks phi2] -clock_fall -min -add_delay -10.000 [get_ports {address[*]}]
set_output_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 40.000 [get_ports {address[*]}]
set_output_delay -clock [get_clocks phi2] -clock_fall -min -add_delay -10.000 [get_ports sync]
set_output_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 40.000 [get_ports sync]
