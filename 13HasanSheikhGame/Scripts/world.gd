extends Node2D

#@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var pause_menu = %PauseMenu
@onready var player = $Player

#func _ready():
	#heartsContainer.setMaxHearts(player.maxHealth)




var paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	print("pause")
	if paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true
	
	paused= !paused

