class_name Player extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $playerTexture
@onready var audio = $Audio

@export var speed = 300.0
@export var jump_speed = -400.0
@export var mass: float = 1.00 # abstract value to dampen the floatiness in jump 
@export var acceleration = 600
@export var deceleration = 800


func _physics_process(delta: float) -> void:
	handleInput(delta)
	
func handleInput(delta):

	# Handle horizontal movement
	if Input.is_action_pressed("left"):
		velocity.x = move_toward(velocity.x, -speed, acceleration * delta)
	elif Input.is_action_pressed("right"):
		velocity.x = move_toward(velocity.x, speed, acceleration * delta)
	else:
		# Decelerate when no input
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	# Handle Jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		animationPlayer.play("jump")
		audio.playJump()
		velocity.y = jump_speed
