extends Area2D

@onready var game = $".."

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player touched Advance point!")
		game.Load_level(game.level_number+1)
	else:
		print("Who tf touched Advance point?!")
