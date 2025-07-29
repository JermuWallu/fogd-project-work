extends Node2D

@onready var audio = $Audio
@onready var level_current = $Level_current
@onready var player = $Player
@onready var hud = $HUD

var level_number: int = 1
var max_level: int = 3
var current_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add to Game group for easy access
	add_to_group("Game")
	
	audio.startMusic()
	current_level = level_current.get_children()[0]
	print("Current level: ", current_level)
	
	# Start the timer for high score tracking
	Global.start_timer()
	
	# Place player on the level's spawnpoint
	player.global_position = current_level.get_node("SpawnPoint").global_position


# Start the level by loading the scene
# and putting player in the spawn point
func start_level(level_num: int) -> void:
	print("Starting level: ", level_num)
	level_number = level_num
	
	var level_scene_path = ""
	if level_num > max_level:
		level_scene_path = "res://Scenes/levels/level_final.tscn"
	else:
		level_scene_path = "res://Scenes/levels/level_" + str(level_number) + ".tscn"
	
	var level_scene = load(level_scene_path)
	if level_scene:
		current_level.queue_free()  # Remove the old level
		current_level = level_scene.instantiate()
		current_level.position = Vector2(0, 0)
		level_current.add_child(current_level)
		# Place player on the level's spawnpoint
		player.global_position = current_level.get_node("SpawnPoint").global_position
