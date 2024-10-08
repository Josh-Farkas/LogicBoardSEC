class_name WireConnectionPoint extends Area2D

signal clicked

var hovered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if hovered and event.is_action_pressed("left_click"):
		clicked.emit()


func _on_mouse_entered() -> void:
	hovered = true
	$Polygon2D.visible = true


func _on_mouse_exited() -> void:
	hovered = false
	$Polygon2D.visible = false
