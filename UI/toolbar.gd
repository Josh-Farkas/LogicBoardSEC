class_name Toolbar extends HBoxContainer

signal tool_selected(tool_name: StringName)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_tool_button_pressed(tool_name: StringName) -> void:
	tool_selected.emit(tool_name)
