class_name ANDGate extends LogicGate


func calculate() -> void:
	state = true
	for input in inputs:
		if input.state == false:
			state = false
			break
