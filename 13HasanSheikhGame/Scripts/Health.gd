extends Area2D

@onready var sfx_collected = $sfx_collected

func collected():
	sfx_collected.play()
	var vanish = preload("res://Scenes/health_vanish.tscn")
	var new_vanish_object = vanish.instantiate()
	get_tree().current_scene.add_child(new_vanish_object)
	new_vanish_object.global_position = global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_body_entered(body):
	if body.is_in_group("Player"):
		collected()
		queue_free()
