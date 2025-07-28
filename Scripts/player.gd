class_name Player extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var audio = $Audio

@export var speed = 600.0
@export var jump_speed = -1000
@export var mass: float = 2.3 # abstract value to dampen the floatiness in jump 
@export var acceleration = 5000
@export var deceleration = 7000

var isHurt = false

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	handleInput(delta)
	velocity.y += gravity * mass * delta 
	move_and_slide()
	handle_animation(delta)
	
func handleInput(delta: float):
	# Handle horizontal movement
	if Input.is_action_pressed("left"):
		velocity.x = move_toward(velocity.x, -speed, acceleration * delta)
	elif Input.is_action_pressed("right"):
		velocity.x = move_toward(velocity.x, speed, acceleration * delta)
	else:
		# Decelerate when no input
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		sprite.play("jump")
		audio.playJump()
		velocity.y = jump_speed
		
		
func handle_animation(delta: float):
	
	# Handle sprite side
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
	# Handle animations except jump
	if isHurt:
		sprite.play("hurt")
	elif !is_on_floor():
		sprite.play("jump")
	elif velocity.x != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
