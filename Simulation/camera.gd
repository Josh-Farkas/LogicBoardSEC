class_name Camera extends Camera2D

signal redraw

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		var mouse_pos := get_global_mouse_position()
		zoom *= .9
		zoom = zoom.clampf(.25, 2)
		var new_mouse_pos := get_global_mouse_position()
		position += mouse_pos - new_mouse_pos


	if event.is_action_pressed("zoom_out"):
		var mouse_pos := get_global_mouse_position()
		zoom *= 1.1
		zoom = zoom.clampf(.25, 2)
		var new_mouse_pos := get_global_mouse_position()
		position += mouse_pos - new_mouse_pos


	
	if event is InputEventMouseMotion and Input.is_action_pressed("pan"):
		position -= event.relative * 1 / zoom
		
		
