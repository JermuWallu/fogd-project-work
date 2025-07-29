extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.monitoring = true
	self.body_entered.connect(on_area_entered)
	pass # Replace with function body.

func on_area_entered(body):
	if body.is_in_group("Player"):
		# Calculate knockback direction from enemy to player
		var knockback_direction = (body.global_position - global_position).normalized()

		print("Player hit by Spikes!")
		Global.damage_player(1)
		body.take_damage(knockback_direction)
