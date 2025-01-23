class_name Component extends Node2D

var inputs : Array[Wire]
var outputs : Array[Wire]
var max_inputs : int
var max_outputs : int
var data: Array[int]
var selected: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("SelectionArea").selected.connect(on_selection)
	
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
	
	
func on_selection():
	selected = true
	add_to_group("Selected")
	print("selected!")
	
func on_deselection():
	selected = false
	remove_from_group("Selected")

# Helpers

# Gets closest gridpoint to point
func get_closest_grid_point(point: Vector2):
	return Vector2(snapped(point.x, Constants.GRID_SIZE), snapped(point.y, Constants.GRID_SIZE))


# Gets the closest gridpoint to the mouse
func get_grid_mouse_position() -> Vector2:
	return get_closest_grid_point(get_global_mouse_position())
	
