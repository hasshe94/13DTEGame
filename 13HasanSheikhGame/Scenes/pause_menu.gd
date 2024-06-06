extends Control

@onready var World = get_node("/root/World")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_resume_pressed():
	World.pauseMenu()
	
