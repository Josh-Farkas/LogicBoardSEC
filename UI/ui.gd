extends Control

@onready var sidebar: Sidebar = $VBoxContainer/HSplitContainer/VSplitContainer/Sidebar
@onready var toolbar: HBoxContainer = $VBoxContainer/HSplitContainer/VBoxContainer/Toolbar
@onready var simulation: Node2D = $VBoxContainer/HSplitContainer/VBoxContainer/SubViewportContainer/SubViewport/Simulation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sidebar.component_selected.connect(simulation.spawn_component)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
