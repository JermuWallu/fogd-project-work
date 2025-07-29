extends Node

# Global variables and functions for the game
# This script can be used to manage game state, player health, etc.
var player_hp: int = 3
var max_hp: int = 3
var music_volume: float
var sfx_volume: float
var high_score: float

signal player_health_changed(new_hp: int)
signal player_died()

func _ready():
	player_hp = max_hp
	load_settings()

func damage_player(damage: int = 1):
	player_hp = max(0, player_hp - damage)

	if player_hp <= 0:
		player_died.emit()
		get_tree().paused = true
		print("Player died!")
		#TODO: handle game over logic here

func heal_player(heal_amount:   = 1):
	print("Healing player by: ", heal_amount)
	if heal_amount < 0:
		print("Heal amount must be positive!")
		return
	if heal_amount > 0:
		print("Healing player by: ", heal_amount)

	player_hp = min(max_hp, player_hp + heal_amount)

func reset_player_health():
	print("Resetting player health to max")
	player_hp = max_hp
	player_health_changed.emit(player_hp)

func get_player_hp() -> int:
	print("Current player HP: ", player_hp)
	# Return the current player health
	return player_hp

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_settings():
	print("Loading settings...")
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var data = json.data
		print(data)

		# set data to global variables
		set_music_volume(data.get("music_volume", music_volume))
		set_high_score(data.get("high_score", high_score))

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
func save_settings():
	print("Saving settings...")
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify({
		"music_volume": music_volume,
		"high_score": high_score
	})
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func get_high_score() -> float:
	print("Current high score: ", high_score)
	return high_score

func set_high_score(score: float):
	if score > high_score or !high_score:
		high_score = score
		print("New high score set: ", high_score)

func set_music_volume(volume: float):
	if volume < 0.0 or volume > 1.0:
		print("Volume must be between 0.0 and 1.0")
		return
	music_volume = volume
	print("Global Music volume set to: ", music_volume)

	# Update the audio bus with the new volume
	var db_value = linear_to_db(music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_value)
