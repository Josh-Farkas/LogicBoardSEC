class_name Endpoint extends Area2D

signal merge_wires(other: Wire)

var wire: Wire

var directions: Dictionary = {
	Vector2.UP: false,
	Vector2.DOWN: false,
	Vector2.LEFT: false,
	Vector2.RIGHT: false
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wire = get_parent().wire
	merge_wires.connect(wire.merge)


func merge(other: Endpoint):
	if other.wire != wire:
		pass
		
	for direction: Vector2 in directions:
		# if either are true set it to true
		directions[direction] = other.directions[direction] or directions[direction]
		other.directions[direction] = directions[direction]
	if other.wire != wire: # wires are different
		merge_wires.emit(other.wire)


func _on_area_entered(other: Area2D) -> void:
	if other is not Endpoint: return
	other = other as Endpoint # convert from Area2D to Endpoints
	# check for cross shape, we don't merge them if this is true
	if not ((other.directions[Vector2.RIGHT] and other.directions[Vector2.LEFT] and directions[Vector2.UP] and directions[Vector2.DOWN]) or (other.directions[Vector2.UP] and other.directions[Vector2.DOWN] and directions[Vector2.LEFT] and directions[Vector2.RIGHT])):
		merge(other)
	else:
		print("Failed Merge")
