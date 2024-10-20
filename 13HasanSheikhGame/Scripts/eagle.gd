extends Area2D
@export var flip_time = 2

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
	#$AnimationPlayer.play("die")  # Assuming you have a death animation
	queue_free()  # Remove the enemy from the scene after death
