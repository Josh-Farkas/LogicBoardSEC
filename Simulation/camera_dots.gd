extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom *= .9
		zoom = zoom.clampf(.25, 2)

	if event.is_action_pressed("zoom_out"):
		zoom *= 1.1
		zoom = zoom.clampf(.25, 2)
	
	if event is InputEventMouseMotion and Input.is_action_pressed("pan"):
		position -= event.relative
		position.x = fmod(position.x, Constants.GRID_SIZE)
		position.y = fmod(position.y, Constants.GRID_SIZE)
		
