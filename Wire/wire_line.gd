class_name WireLine extends Line2D


var hovered: bool = false
var wire: Wire:
	set(value):
		wire = value
		if endpoint1 != null:
			endpoint1.wire = value
			endpoint2.wire = value

#@onready var collision_area: Area2D = $CollisionArea
#@onready var collision_area_shape: CollisionShape2D = collision_area.get_node("CollisionShape2D")
@onready var endpoint1: Endpoint = $Endpoint1
@onready var endpoint2: Endpoint = $Endpoint2


func draw(direction: Vector2):
	endpoint1.directions[direction] = true
	endpoint2.directions[-direction] = true
	rotation = direction.angle() # rotate segment

func finish_drawing():
	# update collision to work with already placed wires
	endpoint1.set_collision_layer_value(3, false)
	endpoint1.set_collision_mask_value(3, false)
	
	endpoint2.set_collision_layer_value(3, false)
	endpoint2.set_collision_mask_value(3, false)
	
	endpoint1.set_collision_layer_value(2, true)
	endpoint1.set_collision_mask_value(2, true)
	
	endpoint2.set_collision_layer_value(2, true)
	endpoint2.set_collision_mask_value(2, true)
	
	# Hack to make collisions work, this causes collisions to be rechecked since
	# just changing the mask and layer won't cause 'area_entered' to be rechecked
	endpoint1.monitoring = false
	endpoint1.monitorable = false
	endpoint2.monitoring = false
	endpoint2.monitorable = false
	
	endpoint1.monitoring = true
	endpoint1.monitorable = true
	endpoint2.monitoring = true
	endpoint2.monitorable = true
	

func _on_area_2d_mouse_entered() -> void:
	hovered = true

func _on_area_2d_mouse_exited() -> void:
	hovered = false
