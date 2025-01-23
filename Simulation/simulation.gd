extends Node2D

var wire_scn: PackedScene = preload("res://Wire/wire.tscn")

var component_scenes: Dictionary = {
	"ANDGate": preload("res://Components/LogicGate/Types/ANDGate/and_gate.tscn")
}

var selecting: bool
var selection_start_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.redraw.connect(queue_redraw)

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("left_click"):
		#var wire = wire_scn.instantiate()
		#add_child(wire)
		#wire.start_drawing()
	
	if event is InputEventMouseMotion and selecting:
		draw_selection()
		
	if event.is_action_released("left_click"):
		end_selection()

# only runs if nothing else handles the input
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		start_selection()
		
func start_selection():
	selecting = true
	selection_start_pos = get_global_mouse_position()
	$SelectionBox.position = selection_start_pos
	$SelectionBox/CollisionShape2D.shape.size = Vector2(1, 1)
	$SelectionBox/ColorRect.size = Vector2(1, 1)
	$SelectionBox/ColorRect.visible = true
	$SelectionBox.monitorable = true
	
	
func end_selection():
	selecting = false
	$SelectionBox/ColorRect.visible = false
	$SelectionBox.monitorable = false
	# Move box far away so it never stays overlapping
	# otherwise if the obect is clicked again it wont be detected
	$SelectionBox.global_position = Vector2(-100000, -100000)
	
# Update the Area2Ds CollisionShape and update the visual ColorRect
func draw_selection():
	$SelectionBox/CollisionShape2D.shape.size = abs(get_global_mouse_position() - selection_start_pos)
	if selection_start_pos.x < get_global_mouse_position().x:
		$SelectionBox.position.x = selection_start_pos.x + $SelectionBox/CollisionShape2D.shape.size.x / 2
	else:
		$SelectionBox.position.x = get_global_mouse_position().x + $SelectionBox/CollisionShape2D.shape.size.x / 2

	if selection_start_pos.y < get_global_mouse_position().y:
		$SelectionBox.position.y = selection_start_pos.y + $SelectionBox/CollisionShape2D.shape.size.y / 2
	else:
		$SelectionBox.position.y = get_global_mouse_position().y + $SelectionBox/CollisionShape2D.shape.size.y / 2
	
	$SelectionBox/ColorRect.size = $SelectionBox/CollisionShape2D.shape.size
	$SelectionBox/ColorRect.global_position = $SelectionBox.global_position -  $SelectionBox/CollisionShape2D.shape.size / 2


func _process(delta: float) -> void:
	queue_redraw()

# draws grid of dots
func _draw() -> void:
	var zoom: Vector2 = $Camera2D.zoom
	var size: Vector2 = get_viewport_rect().size
	var pos: Vector2 = $Camera2D.position - size/2
	
	for x: int in range(snapped(pos.x, Constants.GRID_SIZE), snapped(pos.x + size.x, Constants.GRID_SIZE), Constants.GRID_SIZE): #  * max(1, int(1/zoom.y))
		for y: int in range(snapped(pos.y, Constants.GRID_SIZE), snapped(pos.y + size.y, Constants.GRID_SIZE), Constants.GRID_SIZE): #  * max(1, int(1/zoom.y))
			draw_circle(Vector2(x, y), 1/zoom.x, Color.DIM_GRAY)


func spawn_component(component_name: StringName) -> void:
	print(component_name, "Spawned")
	var component: Component = component_scenes[component_name].instantiate()
	add_child(component)

#
#func save(file_path) -> void:
	#return
#
#func load_save(file_path: String) -> void:
	#pass
	
