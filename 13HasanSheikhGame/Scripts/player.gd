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
	if dead: return
	hp -= 2
	health_bar.value = hp
	sfx_hurt.play()
	if hp <= 0:
		animation_player.play("die")
		sfx_death.play()
		dead = true
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")

func death():
	if dead: return
	hp -= 1000000000
	health_bar.value = hp
	if hp <= 0:
		animation_player.play("die")
		sfx_death.play()
		dead = true
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")

func update_state():
	if anim_state == state.ATTACK:
		await animation_player.animation_finished
		print("Attack done")
		anim_state = state.IDLE
		return

func attack():
	if not is_attacking:  # Only attack if the player is attacking
		return
	
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		if area.is_in_group("enemies"):
			area.queue_free()
			print("Enemy defeated")

func attacking():
	if not is_attacking:
		is_attacking = true
		print("Attacking!")
		$AnimationPlayer.play("attack")
		await $AnimationPlayer.animation_finished  # Wait for attack animation to finish
		is_attacking = false  # Reset the attacking state after the attack animation finishes

func _physics_process(delta):
	if dead: return
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		sfx_jump.play()

	# Handle attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		anim_state = state.ATTACK
		attacking()

	# Handle crouch
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		anim_state = state.CROUCH

	# Handle roll
	if Input.is_action_just_pressed("roll") and is_on_floor():
		anim_state = state.ROLL

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	
	update_state()
	update_animation(direction)
	move_and_slide()

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

func _on_hurt_box_area_entered(area):
	if area.is_in_group("hurt"):
		hit()
	elif area.is_in_group("health"):
		health()
	elif area.is_in_group("death"):
		death()

func _on_attack_area_area_entered(area):
	if area.is_in_group("enemies"):
		attack()
