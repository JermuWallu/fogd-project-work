extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.monitoring = true
	self.body_entered.connect(_on_area_2d_body_entered)
	pass # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered spikes area")
		
		# Calculate knockback direction from spike center to player
		var knockback_direction = (body.global_position - global_position).normalized()
		
		# Only call player's take_damage, which now handles Global.damage_player internally
		body.take_damage(knockback_direction)
