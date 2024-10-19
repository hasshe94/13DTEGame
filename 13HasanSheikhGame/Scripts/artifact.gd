extends Area2D

@onready var sfx_collected = $sfx_collected


func _ready():
	if GameManager.score == 1:
		get_tree().change_scene_to_file("res://Scenes/about.tscn")

func collected():
	sfx_collected.play()
	var vanish = preload("res://Scenes/vanish.tscn")
	var new_vanish_object = vanish.instantiate()
	get_tree().current_scene.add_child(new_vanish_object)
	new_vanish_object.global_position = global_position
	GameManager.score += 1
	if GameManager.score == 15:
		get_tree().change_scene_to_file("res://Scenes/about.tscn")


func reset():
	GameManager.score = 0


	


func _on_body_entered(body):
	if body.is_in_group("Player"):
		collected()
		queue_free()
