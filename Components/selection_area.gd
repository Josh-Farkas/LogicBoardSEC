class_name SelectionArea extends Area2D

signal selected

func _on_area_entered(area: Area2D) -> void:
	var rect: Rect2 = Rect2(global_position - $CollisionShape2D.shape.extents, $CollisionShape2D.shape.size)
	var other_size: Vector2 = area.get_node("CollisionShape2D").shape.size
	var other_rect: Rect2 = Rect2(area.global_position - other_size / 2, other_size)
	
	if other_rect.encloses(rect) or rect.encloses(other_rect):
		selected.emit()
