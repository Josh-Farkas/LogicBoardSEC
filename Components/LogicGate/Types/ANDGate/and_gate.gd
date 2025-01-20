class_name ANDGate extends LogicGate

var following_cursor = true


# Gets closest gridpoint to point
func get_closest_grid_point(point: Vector2):
	return Vector2(snapped(point.x, Constants.GRID_SIZE), snapped(point.y, Constants.GRID_SIZE))


# Gets the closest gridpoint to the mouse
func get_grid_mouse_position() -> Vector2:
	return get_closest_grid_point(get_global_mouse_position())

func _ready():
	set_process(true)
	
	
func _process(delta):
	if following_cursor:
		global_position = get_grid_mouse_position()
		

func _input(event):
	if event.is_action_released("left_click"):
		following_cursor = false

# calculation function for AND gate
func calculate() -> void:
	# the 'and' here is the comparator, we change this for different gates
	state = true
	for input: Wire in inputs:
		if input == null: continue
		if input.state == false:
			state = false
			break
