class_name Wire extends Node2D

@onready var line: Line2D = $Line2D

var inputs: Array[LogicGate]
var outputs: Array[LogicGate]
var state: bool = false

var start_pos: Vector2
var wire_first_dir_toggle = false

func update() -> void:
	#state = false
	for input: LogicGate in inputs:
		if input.state == true:
			state = true
			
	for output: LogicGate in outputs:
		output.update()
			

# Gets closest gridpoint to point
func get_closest_grid_point(point: Vector2):
	return Vector2(snapped(point.x, 32), snapped(point.y, 32))

# Gets the closest gridpoint to the mouse
func get_grid_mouse_position() -> Vector2i:
	return get_closest_grid_point(get_global_mouse_position())

# Runs whenever user input is given
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"): # On left click
		start_drawing()
	if event.is_action_released("left_click"): # Runs when left click released
		finish_drawing()
	if event is InputEventMouseMotion:
		draw_to_point(get_grid_mouse_position())
	if event.is_action_pressed("toggle_wire_direction"):
		wire_first_dir_toggle = not wire_first_dir_toggle
		draw_to_point(get_grid_mouse_position())


func start_drawing() -> void:
	start_pos = get_closest_grid_point(get_global_mouse_position())


func finish_drawing() -> void:
	draw_to_point(get_grid_mouse_position())

func draw_to_point(point: Vector2) -> void:
	line.clear_points()
	line.add_point(start_pos)
	if wire_first_dir_toggle:
		line.add_point(Vector2(point.x, start_pos.y))
	else:
		line.add_point(Vector2(start_pos.x, point.y))
	line.add_point(point)
