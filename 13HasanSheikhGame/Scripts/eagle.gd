extends Area2D
@export var flip_time = 2
@onready var sfx_deathh = $sfx_deathh
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = flip_time

var hp = 5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction)
	$AnimatedSprite2D.flip_h = direction > 0


func _on_timer_timeout():
	direction *= -1


func _on_hit(damage):
	hp -= damage
	if hp <= 0:
		die()

func die():
	sfx_deathh.play()
	await sfx_deathh.finished
	await $AnimationPlayer.play("death")  
	queue_free()  
