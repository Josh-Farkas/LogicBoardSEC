class_name Wire extends Node2D

var wire_line_scn: PackedScene = preload("res://Wire/wire_line.tscn")
var wire_connection_point_scn: PackedScene = preload("res://Wire/wire_connection.tscn")


enum error_type {
	NONE,
	MULTIPLE_INPUTS,
	DATA_WIDTH,
	LOOP
}

var lines: Array[WireLine]
var input: Component
var outputs: Dictionary
var data: int = 0:
	set(value):
		data = value
		if value > 0:
			modulate = Color(0, 0.75, 0)
		else:
			modulate = Color(0.75, 0, 0)
var error: error_type = error_type.NONE

var drawing: bool = false
var start_pos: Vector2
var swapped = false


func _ready() -> void:
	modulate = Color(randf(), randf(), randf())


func connect_to_input(component: Component, index: int) -> void:
	if component not in outputs:
		outputs[component] = 0
	outputs[component] += 1
	component.connect_input(self, index)
	
	
func connect_to_output(component: Component, index: int) -> void:
	input = component
	component.connect_output(self, index)
	
	
func disconnect_from_input(component: Component, index: int) -> void:
	outputs[component] -= 1
	if outputs[component] == 0:
		outputs.erase(component) # remove output component if it has no connections
	component.disconnect_input(index)
	
	
func disconnect_from_output(component: Component, index: int) -> void:
	input = null
	component.disconnect_output(index)
	
	
func update() -> void:
	if error != error_type.NONE:
		# TODO Throw Error
		return
	for output: Component in outputs:
		output.update()
			

# Gets closest gridpoint to point
func get_closest_grid_point(point: Vector2):
	return Vector2(snapped(point.x, Constants.GRID_SIZE), snapped(point.y, Constants.GRID_SIZE))


# Gets the closest gridpoint to the mouse
func get_grid_mouse_position() -> Vector2:
	return get_closest_grid_point(get_global_mouse_position())

# Runs whenever user input is given
func _input(event: InputEvent) -> void:
	if drawing:
		if event.is_action_released("left_click"): # Runs when left click released
			finish_drawing(get_grid_mouse_position())
		if event is InputEventMouseMotion:
			draw_to_point(start_pos, get_grid_mouse_position())
		if event.is_action_pressed("toggle_wire_direction"):
			swapped = not swapped
			draw_to_point(start_pos, get_grid_mouse_position())
		if event.is_action_pressed("cancel_drawing"):
			cancel_drawing()
			

func start_drawing() -> void:
	drawing = true
	start_pos = get_closest_grid_point(get_global_mouse_position())
	lines = []
	

func finish_drawing(end: Vector2) -> void:
	drawing = false
	if start_pos == end:
		cancel_drawing()
		return
	
	await get_tree().process_frame # wait 1 frame for other collisions to happen
	
	for line: WireLine in lines:
		line.finish_drawing()
	lines.clear()
	
	

# draws the wire from start_point to point
func draw_to_point(start: Vector2, end: Vector2) -> void:
	if start == end: return
	for line: WireLine in lines: 
		line.queue_free()
	lines.clear()

	for x: int in range(min(start.x, end.x), max(start.x, end.x), Constants.GRID_SIZE):
		var line: WireLine = wire_line_scn.instantiate()
		line.global_position = Vector2(x, start.y)
		line.wire = self
		add_child(line)
		line.draw(Vector2.RIGHT)
		lines.append(line)
	for y: int in range(min(start.y, end.y), max(start.y, end.y), Constants.GRID_SIZE):
		var line: WireLine = wire_line_scn.instantiate()
		line.position = Vector2(end.x, y)
		line.wire = self
		add_child(line)
		line.draw(Vector2.DOWN)
		lines.append(line)
			
	

# combines two seperate wires into one
func merge(other: Wire) -> void:
	if other == self: return
	if is_queued_for_deletion(): return
	
	if input != null and other.input != null:
		error = error_type.MULTIPLE_INPUTS
		return
	elif other.input != null:
		
		var index: int = other.input.outputs.find(other)
		other.input.outputs[index] = self
		input = other.input
		
	# merge outputs
	for component in other.outputs:
		if component in outputs:
			outputs[component] += other.outputs[component]
		else:
			outputs[component] = other.outputs[component]
	
	# reparent lines to be part of this wire
	for line: WireLine in other.get_children():
		line.wire = self
		line.call_deferred("reparent", self)

	other.queue_free()
	
	update()
	
	
func cancel_drawing() -> void:
	drawing = false
	for line: WireLine in lines:
		line.queue_free()
	lines.clear()


func on_line_clicked(line: WireLine) -> void:
	line.modulate.b = 1
