class_name WireLine extends Line2D

signal clicked(WireLine)

var hovered: bool = false

@onready var collision_area: Area2D = $CollisionArea
@onready var collision_area_shape: CollisionShape2D = collision_area.get_node("CollisionShape2D")
@onready var endpoint1: Area2D = $Endpoint1
@onready var endpoint2: Area2D = $Endpoint2

func _ready() -> void:
	#wire = get_parent()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and hovered:
		clicked.emit(self)


func set_endpoints():
	endpoint1.monitoring = true
	endpoint2.monitoring = true
	endpoint1.monitorable = true
	endpoint2.monitorable = true
	collision_area.monitorable = true
	endpoint1.global_position = points[0]
	endpoint2.global_position = points[1]
	var direction_vec: Vector2 = (points[1] - points[0]).normalized()
	collision_area_shape.shape.a = points[0] + direction_vec * 5
	collision_area_shape.shape.b = points[1] - direction_vec * 5
	
	await get_tree().process_frame
	endpoint1.set_collision_mask_value(2, false)
	endpoint2.set_collision_mask_value(2, false)
	

func _on_area_2d_mouse_entered() -> void:
	hovered = true

func _on_area_2d_mouse_exited() -> void:
	hovered = false


func _on_endpoint_area_entered(area: Area2D, endpoint: Area2D) -> void:
	print(self, area)
	var other_wire: Wire = area.get_parent().get_parent() # overlapped wire
	if area.is_in_group("endpoints"):
		# when connecting by endpoints remove on so there is only a single endpoint left
		area.queue_free()
		print("deleted an endpoint")
	elif area.is_in_group("lines"):
		endpoint.queue_free()
		print("endpoint landed on line, deleted")
	if other_wire == get_parent():
		print("same wire") # TODO Split Wire Segment
		return
	print("aaa")
	get_parent().merge(other_wire)
	


func _on_endpoint1_area_entered(area: Area2D) -> void:
	_on_endpoint_area_entered(area, endpoint1)


func _on_endpoint2_area_entered(area: Area2D) -> void:
	_on_endpoint_area_entered(area, endpoint2)
