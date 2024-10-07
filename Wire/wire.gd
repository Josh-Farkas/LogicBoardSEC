class_name Wire extends Node

var inputs: Array[LogicGate]
var outputs: Array[LogicGate]
var state: bool = false

func update() -> void:
	#state = false
	for input: LogicGate in inputs:
		if input.state == true:
			state = true
			
	for output: LogicGate in outputs:
		output.update()
		
