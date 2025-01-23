class_name SelectionArea extends Area2D

signal selected

func _on_area_entered(area: Area2D) -> void:
	selected.emit()
	print("Sleasdfa")
