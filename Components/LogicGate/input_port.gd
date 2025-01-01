class_name InputPort extends Area2D

static var hovered: InputPort
var parent_gate: LogicGate
var loc: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	hovered = self


func _on_mouse_exited() -> void:
	hovered = null
