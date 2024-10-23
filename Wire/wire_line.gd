class_name WireLine extends Line2D

signal clicked(WireLine)

var hovered: bool = false

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	area.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and hovered:
		clicked.emit(self)
	
func add_new_point(point: Vector2, index = -1) -> void:
	add_point(point, index)
	if get_point_count() >= 2:
		area.visible = true
		area.position = (get_point_position(0) + get_point_position(1)) / 2
		collision_shape.shape.size.x = max(4, abs(get_point_position(0).x - get_point_position(1).x))
		collision_shape.shape.size.y = max(4, abs(get_point_position(0).y - get_point_position(1).y))
		print(abs(get_point_position(0).y - get_point_position(1).y))
		


func _on_area_2d_mouse_entered() -> void:
	hovered = true

func _on_area_2d_mouse_exited() -> void:
	hovered = false
