class_name LogicGate extends Component

var state := false

func _ready() -> void:
	max_inputs = 2
	max_outputs = 1
	inputs = [null, null]
	outputs = [null]
	

# calculates the gate's state and then updates the output wire
func update() -> void:
	calculate()
	if outputs[0] != null:
		outputs[0].update()

# calculates state based on input values, and then updates output
func calculate() -> void:
	state = false

	
