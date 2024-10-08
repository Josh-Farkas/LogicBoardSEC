class_name ANDGate extends LogicGate


func calculate() -> void:
	# the 'and' here is the comparator, we change this for different gates
	state = true
	for input: Wire in inputs:
		if input == null: continue
		if input.state == false:
			state = false
			break
