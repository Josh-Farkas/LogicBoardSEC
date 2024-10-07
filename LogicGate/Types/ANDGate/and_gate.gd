class_name ANDGate extends LogicGate


# calculation function for AND gate
func calculate() -> void:
	# the 'and' here is the comparator, we change this for different gates
	state = inputs.reduce(func (gate, out): gate.state and out)
	#state = true
	#for input in inputs:
		#if input.state == false:
			#state = false
			#break
