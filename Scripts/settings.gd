extends Control

@onready var music_slider = $CenterContainer/VBoxContainer/MusicVolumeContainer/MusicSlider
@onready var music_value_label = $CenterContainer/VBoxContainer/MusicVolumeContainer/MusicValueLabel
@onready var back_button = $CenterContainer/VBoxContainer/BackButton


func _ready():
	# Connect signals
	music_slider.value_changed.connect(_on_music_volume_changed)
	back_button.pressed.connect(_on_back_button_pressed)

	# Load saved settings
	load_settings()

func load_settings():
	Global.load_settings()
	music_slider.value = Global.music_volume * 100 # this calls _on_music_volume_changed

func _on_music_volume_changed(value: int):
	print("Music volume set to: ", value)
	music_slider.value = value
	music_value_label.text = str(value)

func _on_back_button_pressed():
	Global.set_music_volume(music_slider.value / 100.0)
	Global.save_settings()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
