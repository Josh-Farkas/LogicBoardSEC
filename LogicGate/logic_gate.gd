class_name LogicGate extends Node2D


var state := false
@export var inputs: Array[Wire] = [null, null, null, null, null]
var output: Wire


# calculates the gate's state and then updates the output wire
func update() -> void:
	calculate()
	output.update()

# calculates state based on input values, and then updates output
func calculate() -> void:
	state = false
	
