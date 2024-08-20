extends Node2D

@export var speed = 160.00
var current_speed = 0.0

func _physics_process(delta):
	position.y += current_speed * delta
	




func fall():
	current_speed = speed


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent.death()
