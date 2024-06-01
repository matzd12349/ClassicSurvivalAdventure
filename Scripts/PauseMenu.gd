extends Control

#Pause menu Script / Deals with inventory, map, and files

@export var paused: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("Status"):
		PauseMenu()

func PauseMenu() -> void:

	if paused == true:
		show()
		Engine.time_scale = 0
	else:
		hide()
		Engine.time_scale = 1

	paused = !paused
