class_name Wire extends Node2D

var wire_line_scn: PackedScene = preload("res://Wire/wire_line.tscn")
var wire_connection_point_scn: PackedScene = preload("res://Wire/wire_connection.tscn")

var horizontal_line: Line2D
var vertical_line: Line2D

var inputs: Array[LogicGate]
var outputs: Array[LogicGate]
var state: bool = false

var drawing: bool = false
var start_pos: Vector2
var horizontal_first = false

func _ready() -> void:
	start_drawing()

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
	if drawing:
		#if event.is_action_pressed("left_click"): # On left click
			#start_drawing()
		if event.is_action_released("left_click"): # Runs when left click released
			finish_drawing()
		if event is InputEventMouseMotion:
			draw_to_point(get_grid_mouse_position())
		if event.is_action_pressed("toggle_wire_direction"):
			horizontal_first = not horizontal_first
			draw_to_point(get_grid_mouse_position())
		if event.is_action_pressed("cancel_drawing"):
			drawing = false
			horizontal_line.queue_free()
			vertical_line.queue_free()

func start_drawing() -> void:
	drawing = true
	start_pos = get_closest_grid_point(get_global_mouse_position())
	horizontal_line = wire_line_scn.instantiate()
	vertical_line = wire_line_scn.instantiate()
	add_child(horizontal_line)
	add_child(vertical_line)
	


func finish_drawing() -> void:
	drawing = false
	draw_to_point(get_grid_mouse_position())
	
	# Add ports to wire to connect other wires to
	var sign: int = sign(horizontal_line.get_point_position(1).x - horizontal_line.get_point_position(0).x)
	if sign != 0:
		for x in range(horizontal_line.get_point_position(0).x, horizontal_line.get_point_position(1).x + sign, sign * 32):
			var connection_point: WireConnectionPoint = wire_connection_point_scn.instantiate()
			connection_point.position = Vector2(x, horizontal_line.get_point_position(0).y)
			connection_point.clicked.connect(start_drawing)
			horizontal_line.add_child(connection_point)
	
	sign = sign(vertical_line.get_point_position(1).y - vertical_line.get_point_position(0).y)
	if sign != 0:
		for y in range(vertical_line.get_point_position(0).y, vertical_line.get_point_position(1).y + sign, sign * 32):
			var connection_point: WireConnectionPoint = wire_connection_point_scn.instantiate()
			connection_point.position = Vector2(vertical_line.get_point_position(0).x, y)
			connection_point.clicked.connect(start_drawing)
			vertical_line.add_child(connection_point)
	
	horizontal_line = null
	vertical_line = null
	

func draw_to_point(point: Vector2) -> void:
	horizontal_line.clear_points()
	vertical_line.clear_points()
	if horizontal_first:
		horizontal_line.add_point(start_pos)
		horizontal_line.add_point(Vector2(point.x, start_pos.y))
		vertical_line.add_point(Vector2(point.x, start_pos.y))
		vertical_line.add_point(point)
	else:
		vertical_line.add_point(start_pos)
		vertical_line.add_point(Vector2(start_pos.x, point.y))
		horizontal_line.add_point(Vector2(start_pos.x, point.y))
		horizontal_line.add_point(point)
