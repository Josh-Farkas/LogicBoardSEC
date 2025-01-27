extends Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("pan"):
		position += event.relative * 1 / get_parent().zoom
		position.x = fmod(position.x, Constants.GRID_SIZE)
		position.y = fmod(position.y, Constants.GRID_SIZE)
		

# draws grid of dots
func _draw() -> void:
	var zoom: Vector2 = get_parent().zoom
	var size: Vector2 = get_viewport_rect().size *  7
	var pos: Vector2 = get_parent().position - size/2
	
	for x: int in range(snapped(pos.x, Constants.GRID_SIZE), snapped(pos.x + size.x, Constants.GRID_SIZE), Constants.GRID_SIZE): #  * max(1, int(1/zoom.y))
		for y: int in range(snapped(pos.y, Constants.GRID_SIZE), snapped(pos.y + size.y, Constants.GRID_SIZE), Constants.GRID_SIZE): #  * max(1, int(1/zoom.y))
			draw_circle(Vector2(x, y), 3, Color.DIM_GRAY)
