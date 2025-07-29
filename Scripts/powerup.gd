extends Area2D

@onready var sprite = $Sprite2D  # Using Sprite2D as shown in the scene
@onready var collision_shape = $CollisionShape2D
@onready var audio = $Powerup

func _ready() -> void:
	# Connect the body_entered signal to detect player collision
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	"""Handle collision with player"""
	if body.is_in_group("Player"):
		print("Player collected powerup!")

		# Enable powerup in player
		if body.is_in_group("Player"):
			body.enable_powerup()

		audio.play()

		disappear()

func disappear():
	"""Make the powerup disappear"""
	# Disable collision to prevent multiple triggers
	collision_shape.set_deferred("disabled", true)

	# Optional: Add disappear animation/effect
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3)

	# Wait for animation then remove
	await tween.finished
	queue_free()
