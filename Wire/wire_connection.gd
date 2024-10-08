class_name WireConnectionPoint extends Area2D

signal clicked
signal overlap(wire: Wire)

var hovered: bool = false

@onready var wire: Wire = get_parent().get_parent()

# stores the position and owner of all connection points
# if any point is created where one already exists those two wires should merge
static var all_connections: Dictionary = {
	# Vector2:  Wire
	# position: wire
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if all_connections.has(position) and all_connections[position] != wire:
		overlap.emit(all_connections[position])
	all_connections[position] = wire

func _input(event: InputEvent) -> void:
	if hovered and event.is_action_pressed("left_click"):
		clicked.emit()


func change_wire(new_wire: Wire) -> void:
	all_connections[position] = new_wire


func _on_mouse_entered() -> void:
	hovered = true
	$Polygon2D.visible = true


func _on_mouse_exited() -> void:
	hovered = false
	$Polygon2D.visible = false
	
	
func _exit_tree() -> void:
	all_connections.erase(position)
