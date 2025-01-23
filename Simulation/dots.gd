extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# draws grid of dots
func _draw() -> void:
	var zoom: Vector2 = get_parent().get_parent().get_node("Camera2D").zoom
	var size: Vector2 = get_viewport_rect().size / .25
	var pos: Vector2 = get_parent().get_parent().get_node("Camera2D").position - size/2
	
	for x: int in range(snapped(pos.x, Constants.GRID_SIZE), snapped(pos.x + size.x, Constants.GRID_SIZE), Constants.GRID_SIZE): #  * max(1, int(1/zoom.y))
		for y: int in range(snapped(pos.y, Constants.GRID_SIZE), snapped(pos.y + size.y, Constants.GRID_SIZE), Constants.GRID_SIZE): #  * max(1, int(1/zoom.y))
			draw_circle(Vector2(x, y), 1/zoom.x, Color.DIM_GRAY)
