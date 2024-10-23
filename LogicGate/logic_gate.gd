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
	

func connect_input(wire: Wire, index: int) -> void:
	pass
	
func connect_output(wire: Wire) -> void:
	pass
	
func disconnect_input(index) -> void:
	pass
	
func disconnect_output() -> void:
	output = null


func delete():
	pass
	
func drag():
	pass
	
