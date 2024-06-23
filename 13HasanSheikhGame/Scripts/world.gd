extends Node2D

#@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var pause_menu = $Player/Camera2D/PauseMenu
@onready var player = $Player


#func _ready():
	#heartsContainer.setMaxHearts(player.maxHealth)




var paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused= !paused

