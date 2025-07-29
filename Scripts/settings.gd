extends Control

@onready var music_slider = $CenterContainer/VBoxContainer/MusicVolumeContainer/MusicSlider
@onready var music_value_label = $CenterContainer/VBoxContainer/MusicVolumeContainer/MusicValueLabel
@onready var high_score_value_label = $CenterContainer/VBoxContainer/HighScoreContainer/HighScoreValueLabel
@onready var reset_button = $CenterContainer/VBoxContainer/ResetButton
@onready var back_button = $CenterContainer/VBoxContainer/BackButton


func _ready():
	# Connect signals
	music_slider.value_changed.connect(_on_music_volume_changed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	# Load saved settings
	load_settings()

func load_settings():
	Global.load_settings()
	music_slider.value = Global.music_volume * 100 # this calls _on_music_volume_changed
	update_high_score_display()

func update_high_score_display():
	high_score_value_label.text = str(int(Global.get_high_score()))

func _on_music_volume_changed(value: int):
	print("Music volume set to: ", value)
	music_slider.value = value
	music_value_label.text = str(value)

func _on_reset_button_pressed():
	print("Reset button pressed! Resetting all settings to 0.")
	# Reset music slider to 0
	music_slider.value = 0
	# Update labels
	music_value_label.text = "0"
	# Reset high score
	Global.reset_high_score()
	update_high_score_display()
	# Apply the changes through Global
	Global.set_music_volume(0.0)
	# Save the reset settings
	Global.save_settings()

func _on_back_button_pressed():
	Global.set_music_volume(music_slider.value / 100.0)
	Global.save_settings()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
