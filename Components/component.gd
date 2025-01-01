class_name Component extends Node2D

var inputs : Array[Wire]
var outputs : Array[Wire]
var max_inputs : int
var max_outputs : int
var data: Array[int]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func update() -> void:
	operation()
	for i in range(len(outputs)):
		var output: Wire = outputs[i]
		if output != null:
			output.data = data[i]
			output.update()
	
# operation of component (and_gate: and operation)
func operation() -> void:
	return

# adds input wire to components inputs array
func connect_input(wire: Wire, index: int) -> void:
	inputs[index] = wire
	
# adds output wire to components outputs array
func connect_output(wire: Wire, index: int = 0) -> void:
	outputs[index] = wire
	
# disconnect (remove) wire from inputs array
func disconnect_input(index: int) -> void:
	inputs[index] = null
	
# disconnect (remove) wire from outputs array
func disconnect_output(index: int = 0) -> void:
	outputs[index] = null

func delete():
	pass
	
func drag():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
