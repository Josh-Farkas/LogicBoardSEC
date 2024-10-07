class_name LogicGate extends Node2D


var state := false
var inputs: Array[Wire] = []
var output: Wire


func update() -> void:
	calculate()
	output.update()

# calculates state based on input values, and then updates output
func calculate() -> void:
	state = false
	
