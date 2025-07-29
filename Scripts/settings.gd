extends Control

@onready var music_slider = $CenterContainer/VBoxContainer/MusicVolumeContainer/MusicSlider
@onready var music_value_label = $CenterContainer/VBoxContainer/MusicVolumeContainer/MusicValueLabel
@onready var high_score_value_label = $CenterContainer/VBoxContainer/HighScoreContainer/HighScoreValueLabel
@onready var reset_button = $CenterContainer/VBoxContainer/ResetButton
@onready var back_button = $CenterContainer/VBoxContainer/BackButton

var default_music_value = 50
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
	print("Reset button pressed! Resetting all settings...")
	Global.reset_high_score()
	update_high_score_display()
	music_slider.value = default_music_value

func _on_back_button_pressed():
	Global.set_music_volume(music_slider.value / 100.0)
	Global.save_settings()
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
