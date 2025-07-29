extends Control

@onready var play_button = $CenterContainer/VBoxContainer/VBoxContainer/PlayButton
@onready var settings_button = $CenterContainer/VBoxContainer/VBoxContainer/SettingsButton
@onready var quit_button = $CenterContainer/VBoxContainer/VBoxContainer/QuitButton

func _ready():
	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_play_button_pressed():
	print("Play button pressed!")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_settings_button_pressed():
	print("Settings button pressed!")
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_quit_button_pressed():
	print("Quit button pressed!")
	get_tree().quit()
