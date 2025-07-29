class_name Player extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var audio = $Audio

@export var speed = 600.0
@export var jump_speed = -1000
@export var mass: float = 2.3
@export var acceleration = 5000
@export var deceleration = 7000
@export var knockback_force = 2000.0
@export var knockback_up_force = -1000

var isHurt = false
var powerup_enabled = false
var powerup_active = false
var powerup_on_cooldown = false
var input_disabled = false

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity_multiplier = 1.0  # Used to reverse gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Connect to global player death signal
	if Global.has_signal("player_died"):
		Global.player_died.connect(_on_player_died)

func _on_player_died():
	input_disabled = true
	sprite.play("hurt")  # Show hurt animation when dead


func _physics_process(delta: float) -> void:
	if input_disabled:
		return
	handleInput(delta)
	velocity.y += gravity * gravity_multiplier * mass * delta
	move_and_slide()
	handle_animation()

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
	var floor_check = is_on_floor() if gravity_multiplier > 0 else is_on_ceiling()
	if Input.is_action_just_pressed("jump") and floor_check:
		sprite.play("jump")
		audio.playJump()
		velocity.y = jump_speed * gravity_multiplier

	# Handle Powerup activation
	if Input.is_action_just_pressed("powerup"):
		activate_powerup()

func handle_animation():

	# Handle sprite side
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

	# Handle animations except jump
	if isHurt:
		sprite.play("hurt")
	elif (gravity_multiplier > 0 and !is_on_floor()) or (gravity_multiplier < 0 and !is_on_ceiling()):
		sprite.play("jump")
	elif velocity.x != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")

	# Flip sprite vertically when gravity is reversed
	if gravity_multiplier < 0:
		sprite.flip_v = true
	else:
		sprite.flip_v = false

func take_damage(knockback_direction: Vector2 = Vector2.ZERO):

	if not isHurt:  # Prevent damage spam
		isHurt = true
		sprite.play("hurt")
		# different visuals if powerup
		if powerup_active:
			deactivate_powerup()
		else:
			sprite.modulate = Color.DARK_RED

		if audio.has_method("playHurt"):
			audio.playHurt()

		# Apply knockback if direction is provided
		if knockback_direction != Vector2.ZERO:
			apply_knockback(knockback_direction)

		# Reset hurt state after animation
		await get_tree().create_timer(0.5).timeout
		isHurt = false
		if sprite.modulate == Color.DARK_RED:
			sprite.modulate = Color.WHITE

func apply_knockback(direction: Vector2):

	# Apply horizontal knockback
	velocity.x = direction.x * knockback_force

	# Add some upward force for better feel
	velocity.y = knockback_up_force * gravity_multiplier

	print("Knockback applied: ", direction)

func enable_powerup():

	powerup_enabled = true
	print("Powerup enabled! Press powerup key to activate.")

	# Visual feedback for having powerup available
	sprite.modulate = Color.AQUA

func activate_powerup():

	if not powerup_enabled:
		print("No powerup available!")
		return

	if powerup_on_cooldown:
		print("Powerup on cooldown!")
		return

	if powerup_active:
		print("Powerup already active!")
		return

	print("Powerup activated! Gravity reversed for 5 seconds.")
	powerup_active = true
	gravity_multiplier = -1.0  # Reverse gravity

	sprite.modulate = Color.CYAN
	# Disable powerup after 5 seconds
	await get_tree().create_timer(5.0).timeout
	deactivate_powerup()

func deactivate_powerup():

	print("Powerup deactivated!")
	powerup_active = false
	gravity_multiplier = 1.0

	# Start cooldown
	powerup_on_cooldown = true
	sprite.modulate = Color.ORANGE_RED

	# End cooldown after 5 seconds
	await get_tree().create_timer(5.0).timeout
	powerup_on_cooldown = false
	print("Powerup cooldown finished!")
	enable_powerup()
