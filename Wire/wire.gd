class_name Wire extends Node2D

var wire_line_scn: PackedScene = preload("res://Wire/wire_line.tscn")
var wire_connection_point_scn: PackedScene = preload("res://Wire/wire_connection.tscn")

var horizontal_line: WireLine
var vertical_line: WireLine

var inputs: Array[LogicGate]
var outputs: Array[LogicGate]
var state: bool = false:
	set(value):
		state = value
		if value:
			modulate = Color(0, 0.75, 0)
		else:
			modulate = Color(0.75, 0, 0)

var drawing: bool = false
var start_pos: Vector2
var horizontal_first = false


func input_connect(gate: LogicGate, loc: int) -> void:
	outputs.append(gate)
	gate.inputs[loc] = self
	
	
func output_connect(gate: LogicGate) -> void:
	inputs.append(gate)
	gate.output = self
	
	
func update() -> void:
	#state = false
	for input: LogicGate in inputs:
		if input.state == true:
			state = true
			
	for output: LogicGate in outputs:
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
			cancel_drawing()
			

func start_drawing() -> void:
	drawing = true
	start_pos = get_closest_grid_point(get_global_mouse_position())
	horizontal_line = wire_line_scn.instantiate()
	vertical_line = wire_line_scn.instantiate()
	horizontal_line.clicked.connect(on_line_clicked)
	vertical_line.clicked.connect(on_line_clicked)
	add_child(horizontal_line)
	add_child(vertical_line)
	


func finish_drawing() -> void:
	drawing = false
	if start_pos == get_grid_mouse_position():
		cancel_drawing()
		return
		
	draw_to_point(get_grid_mouse_position())
	# Add ports to wire to connect other wires to
	var sign: int = sign(horizontal_line.get_point_position(1).x - horizontal_line.get_point_position(0).x)
	if sign != 0:
		for x in range(horizontal_line.get_point_position(0).x, horizontal_line.get_point_position(1).x + sign, sign * Constants.GRID_SIZE):
			var connection_point: WireConnectionPoint = wire_connection_point_scn.instantiate()
			connection_point.position = Vector2(x, horizontal_line.get_point_position(0).y)
			connection_point.clicked.connect(start_drawing)
			connection_point.overlap.connect(merge)
			horizontal_line.add_child(connection_point)
	
	sign = sign(vertical_line.get_point_position(1).y - vertical_line.get_point_position(0).y)
	if sign != 0:
		for y in range(vertical_line.get_point_position(0).y, vertical_line.get_point_position(1).y + sign, sign * Constants.GRID_SIZE):
			var connection_point: WireConnectionPoint = wire_connection_point_scn.instantiate()
			connection_point.position = Vector2(vertical_line.get_point_position(0).x, y)
			connection_point.clicked.connect(start_drawing)
			connection_point.overlap.connect(merge)
			vertical_line.add_child(connection_point)
	
	horizontal_line = null
	vertical_line = null
	


# draws the wire from start_point to point
func draw_to_point(point: Vector2) -> void:
	if start_pos == point: return
	horizontal_line.clear_points()
	vertical_line.clear_points()
	print("A")
	print(horizontal_line)
	print(vertical_line)
	if horizontal_first:
		vertical_line.add_new_point(Vector2(point.x, start_pos.y))
		vertical_line.add_new_point(point)
		horizontal_line.add_new_point(start_pos)
		horizontal_line.add_new_point(Vector2(point.x, start_pos.y))
	else:
		horizontal_line.add_new_point(Vector2(start_pos.x, point.y))
		horizontal_line.add_new_point(point)
		vertical_line.add_new_point(start_pos)
		vertical_line.add_new_point(Vector2(start_pos.x, point.y))


# combines two seperate wires into one
func merge(other: Wire) -> void:
	if other == self: return
	inputs.append_array(other.inputs)
	outputs.append_array(other.outputs)
	
	# update output node inputs to this wire
	for output in other.outputs:
		output.inputs[output.inputs.find(other)] = self
	
	# update input nodes outputs to be this wire
	for input in other.inputs:
		input.output = self
	
	# reparent lines to be part of this wire
	for line: Line2D in other.get_tree().get_nodes_in_group("wire_line"):
		line.reparent(self)
	
	# reparent connections to be part of this wire
	for connection: WireConnectionPoint in other.get_tree().get_nodes_in_group("wire_connection"):
		connection.change_wire(self)
	
	other.queue_free()
	update()
	
func cancel_drawing() -> void:
	drawing = false
	horizontal_line.queue_free()
	vertical_line.queue_free()
	horizontal_line = null
	vertical_line = null


func on_line_clicked(line: WireLine) -> void:
	line.modulate.b = 1


	
func disconnect_output(gate: LogicGate) -> void:
	pass
	
func disconnect_input(gate: LogicGate) -> void:
	pass
