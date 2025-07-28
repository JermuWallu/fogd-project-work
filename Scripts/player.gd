class_name Player extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var audio = $Audio

@export var speed = 300.0
@export var jump_speed = -400.0
@export var mass: float = 1.00 # abstract value to dampen the floatiness in jump 
@export var acceleration = 600
@export var deceleration = 800

var isHurt = false


func _physics_process(delta: float) -> void:
	handleInput(delta)
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
	if Input.is_action_just_pressed("up") and is_on_floor():
		sprite.play("jump")
		audio.playJump()
		velocity.y = jump_speed
		
		
func handle_animation(delta: float):
	# Handle animations except jump
	if isHurt:
		sprite.play("hurt")
	elif !is_on_floor():
		sprite.play("jump")
	
	elif velocity.x != 0:
		if velocity.x < 0:
			sprite.flip_h = true
		sprite.play("walk")
	else:
		sprite.play("idle")
