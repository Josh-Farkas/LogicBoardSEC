extends Node2D

var wire_scn: PackedScene = preload("res://Wire/wire.tscn")

var component_scenes: Dictionary = {
	"ANDGate": preload("res://Components/LogicGate/Types/ANDGate/and_gate.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.redraw.connect(queue_redraw)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var wire = wire_scn.instantiate()
		add_child(wire)
		wire.start_drawing()
	

# draws grid of dots
func _draw() -> void:
	var zoom: Vector2 = $Camera2D.zoom
	var size: Vector2 = get_viewport_rect().size / zoom
	var pos: Vector2 = $Camera2D.position - size/2
	
	for x in range(snapped(pos.x, Constants.GRID_SIZE), snapped(pos.x + size.x, Constants.GRID_SIZE), Constants.GRID_SIZE * max(1, int(1/zoom.x))):
		for y in range(snapped(pos.y, Constants.GRID_SIZE), snapped(pos.y + size.y, Constants.GRID_SIZE), Constants.GRID_SIZE * max(1, int(1/zoom.y))):
			draw_circle(Vector2(x, y), 1 / zoom.x, Color.DIM_GRAY)


func spawn_component(component_name: StringName) -> void:
	print(component_name, "Spawned")
	var component: Component = component_scenes[component_name].instantiate()
	add_child(component)


func save(file_path: String) -> void:
	return

func load_save(file_path: String) -> void:
	pass
	
