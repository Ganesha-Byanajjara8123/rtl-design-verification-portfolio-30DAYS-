# Run Simulation

Compile all files:

vlog rtl/alu.sv
vlog interface/alu_if.sv
vlog tb/*.sv

Run simulation:

vsim tb
run -all
