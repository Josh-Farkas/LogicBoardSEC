class_name Sidebar extends VBoxContainer

signal component_selected(component_name: StringName)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func test(a):
	print(a)


func _on_and_gate_pressed() -> void:
	component_selected.emit("ANDGate")
