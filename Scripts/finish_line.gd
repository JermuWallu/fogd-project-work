extends Area2D

@onready var collision_shape = $CollisionShape2D
signal level_completed

func _ready():

	self.monitoring = true
	body_entered.connect(_on_body_entered)
	self.modulate = Color.GOLD
	print("Finish line ready!")

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		print("Player reached the finish line!")
		
		# Disable collision to prevent multiple triggers
		self.monitoring = false
		get_tree().change_scene_to_file("res://Scenes/final_stats.tscn")
