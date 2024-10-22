extends CharacterBody2D
var is_attacking = false
@onready var sfx_jump = $sfx_jump
@onready var sfx_death = $sfx_death
@onready var sfx_hurt = $sfx_hurt

signal healthChanged
@export var speed = 300.0
@export var jump_velocity = -400.0
@export var acceleration : float = 15.0
@export var jumps = 1
var dead = false
var hp = 10
@onready var health_bar = %HealthBar
@onready var sfx_collectedd = $sfx_collectedd
#@export var maxHealth = 3
#@onready var currentHealth: int = maxHealth

enum state {IDLE, RUNNING, JUMPUP, JUMPDOWN, HURT, CROUCH, ROLL, ATTACK, DIE}

@export var anim_state = state.IDLE

@onready var animator = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	health_bar.value = hp
	
func _process(delta):
	health_bar.value = hp
	

func health():
	hp += 3
	health_bar.value = hp
	sfx_collectedd.play()


func hit():
	if dead:return
	hp -= 2
	health_bar.value = hp
	sfx_hurt.play()
	if hp <=0:
		animation_player.play("die")
		sfx_death.play()
		dead = true
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")

func death():
	if dead:return
	hp -=1000000000
	health_bar.value = hp
	if hp <=0:
		animation_player.play("die")
		sfx_death.play()
		dead = true
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")

#func die():
	#anim_state=state.DIE
	#update_animation(0)
#
#func _on_animaition_finished(anim_state):
	#if anim_state == "die":
		#get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")
	


func update_state():
	if anim_state == state.ATTACK:
		await animation_player.animation_finished
		print("done")
		anim_state = state.IDLE
		return
		
func attacking():
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	for area in overlapping_objects:
		if area.is_in_group("enemies"):  
			area.get_parent().die()  
			print("Enemy defeated")




	if anim_state == state.HURT:
		return

	if Input.is_action_just_pressed("attack"):
		anim_state = state.ATTACK
		return  
		
		
		
	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.IDLE
		elif velocity.x !=0:
			anim_state = state.RUNNING
	else:
		if velocity.y < 0:
			anim_state = state.JUMPUP
		else:
			anim_state = state.JUMPDOWN


func update_animation(direction):

	if direction > 0:
		animator.flip_h = false
	elif direction < 0:
		animator.flip_h = true
	match anim_state:
		state.IDLE:
			animation_player.play("idle")
		state.RUNNING:
			animation_player.play("run")
		state.JUMPUP:
			animation_player.play("jump_up")
		state.JUMPDOWN:
			animation_player.play("jump_down")
		state.HURT:
			animation_player.play("hurt")
		state.CROUCH:
			animation_player.play("crouch")
		state.ROLL:
			animation_player.play("roll")
		state.ATTACK:
			animation_player.play("attack")
		state.DIE:
			animation_player.play("die")

func attack():
	var overlappng_objects = $AttackArea.get_overlapping_areas()

	
	for area in overlappng_objects:
		
		area.queue_free()
	

	
#func attack():
	#if not is_attacking:
		#is_attacking = true
		#print("Attacking!")
		#$AnimationPlayer.play("attack")
		#is_attacking = false


func _physics_process(delta):
	# Add the gravity.
	if dead : return
	if not is_on_floor():
		velocity.y += gravity * delta




	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		sfx_jump.play()

		
	if Input.is_action_just_pressed("attack"):
		anim_state = state.ATTACK
		attack()

	if Input.is_action_just_pressed("crouch") and is_on_floor():
		anim_state = state.CROUCH

	if Input.is_action_just_pressed("roll") and is_on_floor():
		anim_state = state.ROLL


	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x,direction*speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	
	update_state()
	update_animation(direction)
	move_and_slide()








#func _on_area_2d_body_entered(body):
	#if body.is_in_group("Hurt"):
		#get_tree().change_scene_to_file("res://Scenes/world.tscn")


	

#func _on_area_2d_2_body_entered(body):
	#if body.is_in_group("Hurt"):
		#get_tree().change_scene_to_file("res://Scenes/world.tscn")


#func _on_area_2d_area_entered(area):
	#if area.name == "hitBox":
		#currentHealth -=1
		#if currentHealth <0:
			#currentHealth = maxHealth
		
		#healthChanged.emit(currentHealth)


func _on_area_2d_area_entered(area):
	pass # Replace with function body.


func _on_hurt_box_area_entered(area):
	if area.is_in_group("hurt"):
		hit()
	elif area.is_in_group("health"):
		health()
	elif area.is_in_group("death"):
		death()




	


func _on_attack_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_attack_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
