@tool
extends Tree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Generating tree")
	var root = create_item()
	hide_root = true
	var child1 = create_item(root)
	var child2 = create_item(root)
	var subchild1 = create_item(child1)
	subchild1.set_text(0, "Subchild1")
	print("A")

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
