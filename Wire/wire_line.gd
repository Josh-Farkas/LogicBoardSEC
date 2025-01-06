class_name WireLine extends Line2D

signal clicked(WireLine)

var hovered: bool = false
var direction: StringName
var merged_this_frame: bool = false

@onready var collision_area: Area2D = $CollisionArea
@onready var collision_area_shape: CollisionShape2D = collision_area.get_node("CollisionShape2D")
@onready var endpoint1: Area2D = $Endpoint1
@onready var endpoint2: Area2D = $Endpoint2


func _ready() -> void:
	points.resize(2)

func _process(delta: float) -> void:
	merged_this_frame = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and hovered:
		clicked.emit(self)

func merge(other: WireLine):
	if direction == "horizontal":
		var max_x: int = max(collision_area_shape.shape.a.x, collision_area_shape.shape.b.x, other.collision_area_shape.shape.a.x, other.collision_area_shape.shape.b.x)
		var min_x: int = min(collision_area_shape.shape.a.x, collision_area_shape.shape.b.x, other.collision_area_shape.shape.a.x, other.collision_area_shape.shape.b.x)
		collision_area_shape.shape.a.x = min_x
		collision_area_shape.shape.b.x = max_x
	else:
		var max_y: int = max(collision_area_shape.shape.a.y, collision_area_shape.shape.b.y, other.collision_area_shape.shape.a.y, other.collision_area_shape.shape.b.y)
		var min_y: int = min(collision_area_shape.shape.a.y, collision_area_shape.shape.b.y, other.collision_area_shape.shape.a.y, other.collision_area_shape.shape.b.y)
		collision_area_shape.shape.a.y = min_y
		collision_area_shape.shape.b.y = max_y
	
	if other.endpoint1 != null:
		other.endpoint1.reparent(self)
	if other.endpoint2 != null:
		other.endpoint2.reparent(self)
	#for point: Area2D in other.get_tree().get_nodes_in_group("endpoints"):
		#print("reparenting")
		#point.reparent(self)
	other.queue_free()


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
	endpoint1.set_meta("direction", direction_vec)
	endpoint2.set_meta("direction", -direction_vec)
	
	await get_tree().process_frame
	endpoint1.set_collision_mask_value(2, false)
	endpoint2.set_collision_mask_value(2, false)
	

func _on_area_2d_mouse_entered() -> void:
	hovered = true

func _on_area_2d_mouse_exited() -> void:
	hovered = false


func _on_endpoint_area_entered(other_endpoint: Area2D, endpoint: Area2D) -> void:
	if merged_this_frame: return
	print()
	print(self, other_endpoint)
	other_endpoint.get_parent().merged_this_frame = true
	var other_wire: Wire = other_endpoint.get_parent().get_parent() # overlapped wire
	if other_endpoint.is_in_group("endpoints"):
		if other_endpoint.get_meta("direction") == -endpoint.get_meta("direction"): # merging two wires in same direction
			print("self merging with other")
			merge(other_endpoint.get_parent())
			endpoint.queue_free()
		# when connecting by endpoints remove one so there is only a single endpoint left
		other_endpoint.queue_free()
		
	elif other_endpoint.is_in_group("lines"):
		endpoint.queue_free()

	if other_wire != get_parent():
		get_parent().merge(other_wire)	
		print("merged wire") # TODO Split Wire Segment
	# print("aaa")
	


func _on_endpoint1_area_entered(area: Area2D) -> void:
	_on_endpoint_area_entered(area, endpoint1)


func _on_endpoint2_area_entered(area: Area2D) -> void:
	_on_endpoint_area_entered(area, endpoint2)
