extends RigidBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var killbox = $Killbox

@onready var audio = $Audio

@export var movement_speed: int = 300
@export var detection_range: int = 600
@export var view_range: int = 800 # Range at which the enemy can see the player
@export var spawn_return_threshold: float = 20.0 # How close to spawn before going idle

var is_dying: bool = false
var player_node: Node2D = null
var spawn_coords: Vector2

enum EnemyState {
	IDLE,
	CHASE,
	RETURN_TO_SPAWN,
	DYING
}

var current_state: EnemyState = EnemyState.IDLE

func _ready():
	# Store spawn coordinates
	spawn_coords = global_position

	# Initialize hitboxes ()
	# RigidBody2D uses body_entered signal through contact monitoring
	self.contact_monitor = true
	self.max_contacts_reported = 10
	self.body_entered.connect(_on_hitbox_body_entered)
	killbox.body_entered.connect(_on_killbox_body_entered)

	sprite.play("hang")
	# Find player node
	player_node = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if is_dying:
		return

	match current_state:
		EnemyState.IDLE:
			handle_idle_state()
		EnemyState.CHASE:
			handle_chase_state(delta)
		EnemyState.RETURN_TO_SPAWN:
			handle_return_to_spawn_state(delta)

func handle_idle_state():
	# Check if player is in detection range
	if player_node and global_position.distance_to(player_node.global_position) <= detection_range:
		current_state = EnemyState.CHASE
		sprite.play("hang")

func handle_chase_state(delta):
	# Chase the player
	if player_node:
		var direction = (player_node.global_position - global_position).normalized()
		linear_velocity = direction * movement_speed * delta

		# Flip sprite based on direction
		if direction.x > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

		# Only play the fly animation and sound if not already playing
		if sprite.animation != "fly":
			sprite.play("fly")
			audio.startFly()

		# If player gets too far, return to spawn instead of going idle
		if global_position.distance_to(player_node.global_position) > view_range:
			current_state = EnemyState.RETURN_TO_SPAWN
			print("Player out of range, returning to spawn")

func handle_return_to_spawn_state(delta):
	var distance_to_spawn = global_position.distance_to(spawn_coords)

	# Check if we've reached spawn (within a small threshold)
	if distance_to_spawn < spawn_return_threshold:
		current_state = EnemyState.IDLE
		linear_velocity = Vector2.ZERO
		sprite.play("hang")
		audio.stopFly()
		print("Reached spawn, going idle")
		return

	# Fly towards spawn coordinates
	var direction_to_spawn = (spawn_coords - global_position).normalized()
	linear_velocity = direction_to_spawn * movement_speed * delta

	# Flip sprite based on direction
	if direction_to_spawn.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	# Only play the fly animation and sound if not already playing
	if sprite.animation != "fly":
		sprite.play("fly")
		audio.startFly()

func _on_hitbox_body_entered(body):
	if is_dying:
		return
	if body.is_in_group("Player"):
		# Calculate knockback direction from enemy to player
		var knockback_direction = (body.global_position - global_position).normalized()

		print("Player hit by enemy - taking damage!")
		Global.damage_player(1)
		body.take_damage(knockback_direction)

func _on_killbox_body_entered(body):
	if body.is_in_group("Player") and not is_dying:
		print("Enemy squashed by player!")
		# Give player a little bounce for successful enemy kill
		if body.has_method("apply_bounce"):
			body.apply_bounce()

		squash_enemy()

func squash_enemy():
	is_dying = true
	current_state = EnemyState.DYING # Useless atm due to is_dying

	# Stop all movement and sounds
	linear_velocity = Vector2.ZERO
	gravity_scale = 0
	sprite.play("squashed")
	audio.stopFly()
	audio.playSquashed()

	disable_all_hitboxes()

	# Wait 1 second then destroy enemy
	await get_tree().create_timer(1.0).timeout
	die()

func disable_all_hitboxes():
	# check due to crashes
	if collision_shape:
		collision_shape.set_deferred("disabled", true)

	if killbox:
		killbox.set_deferred("monitoring", false)
		killbox.set_deferred("monitorable", false)

func die():
	print("Enemy destroyed!")
	queue_free()
