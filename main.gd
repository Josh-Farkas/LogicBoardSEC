extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gate1 = ANDGate.new()
	#var gate2 = ANDGate.new()
	var wire1 = Wire.new()
	var wire2 = Wire.new()
	var wire3 = Wire.new()
	
	wire1.state = false
	wire2.state = false
	
	wire1.outputs.append(gate1)
	wire2.outputs.append(gate1)
	wire3.inputs.append(gate1)
	gate1.inputs.append(wire1)
	gate1.inputs.append(wire2)
	gate1.output = wire3
	
	wire1.update()
	
	print(wire3.state)
	
