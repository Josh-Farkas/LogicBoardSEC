class_name ANDGate extends LogicGate


func calculate() -> void:
<<<<<<< Updated upstream
	state = true
	for input in inputs:
=======
	# the 'and' here is the comparator, we change this for different gates
	state = true
	for input: Wire in inputs:
		if input == null: continue
>>>>>>> Stashed changes
		if input.state == false:
			state = false
			break
