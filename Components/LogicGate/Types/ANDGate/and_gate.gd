class_name ANDGate extends LogicGate

var following_cursor := true

func _ready():
	super()
	
	
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
