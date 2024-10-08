extends Node2D

var wire_scn = preload("res://Wire/wire.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.redraw.connect(queue_redraw)
	
	var gate1 = ANDGate.new()
	var wire1 = Wire.new()
	var wire2 = Wire.new()
	var wire3 = Wire.new()
	
	wire1.state = false
	wire2.state = false
	
	wire1.outputs.append(gate1)
	wire2.outputs.append(gate1)
	wire3.inputs.append(gate1)
	gate1.inputs.append(wire1)
	gate1.inputs.append(wire2)
	gate1.output = wire3
	
	wire1.update()
	
	print(wire3.state)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var wire = wire_scn.instantiate()
		add_child(wire)
		wire.start_drawing()
	

# draws grid of dots
func _draw() -> void:
	var zoom: Vector2 = $Camera2D.zoom
	var size: Vector2 = get_viewport_rect().size / zoom
	var pos: Vector2 = $Camera2D.position - size/2
	
	for x in range(snapped(pos.x, Constants.GRID_SIZE), snapped(pos.x + size.x, Constants.GRID_SIZE), Constants.GRID_SIZE * max(1, int(1/zoom.x))):
		for y in range(snapped(pos.y, Constants.GRID_SIZE), snapped(pos.y + size.y, Constants.GRID_SIZE), Constants.GRID_SIZE * max(1, int(1/zoom.y))):
			draw_circle(Vector2(x, y), 1 / zoom.x, Color.DIM_GRAY)
	
