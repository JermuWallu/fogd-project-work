extends Control

@onready var congratulations_label = $CenterContainer/VBoxContainer/CongratulationsLabel
@onready var current_score_label = $CenterContainer/VBoxContainer/CurrentScoreLabel
@onready var new_record_label = $CenterContainer/VBoxContainer/NewRecordLabel
@onready var high_score_label = $CenterContainer/VBoxContainer/HighScoreLabel
@onready var play_again_button = $CenterContainer/VBoxContainer/ButtonContainer/PlayAgainButton
@onready var main_menu_button = $CenterContainer/VBoxContainer/ButtonContainer/MainMenuButton

var current_run_score: int
var previous_high_score: int
var is_new_record: bool = false

func _ready():
	Global.stop_timer()
	current_run_score = int(Global.get_current_score())
	previous_high_score = int(Global.get_high_score())
	print("Current run score: ", current_run_score)
	print("Previous high score: ", previous_high_score)
	if current_run_score < previous_high_score or previous_high_score <= 0.0:
		is_new_record = true
	else:
		is_new_record = false

	# Set up the UI before updating
	setup_labels()
	setup_buttons()

	# Update high score if needed
	if is_new_record:
		Global.set_high_score(current_run_score)
		Global.save_settings()

func setup_labels():
	# Set congratulations message
	congratulations_label.text = "CONGRATULATIONS!"
	congratulations_label.add_theme_font_size_override("font_size", 48)
	congratulations_label.add_theme_color_override("font_color", Color.GOLD)
	var time_text = format_time(current_run_score)

	# Set current score
	current_score_label.text = "Your Time: " + time_text
	current_score_label.add_theme_font_size_override("font_size", 32)
	current_score_label.add_theme_color_override("font_color", Color.WHITE)

	# Show new record message if applicable
	if is_new_record:
		new_record_label.text = "NEW RECORD!"
		new_record_label.add_theme_font_size_override("font_size", 36)
		new_record_label.add_theme_color_override("font_color", Color.YELLOW)
		new_record_label.visible = true
	else:
		new_record_label.visible = false

	# Set high score display
	if previous_high_score > 0:
		var prev_time_text = format_time(previous_high_score)

		if is_new_record:
			high_score_label.text = "Previous Best: " + prev_time_text
		else:
			high_score_label.text = "Current Best: " + prev_time_text

		high_score_label.add_theme_font_size_override("font_size", 24)
		high_score_label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
		high_score_label.visible = true
	else:
		high_score_label.visible = false

func setup_buttons():
	# Connect button signals
	play_again_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

	# Style buttons
	play_again_button.text = "Play Again"
	main_menu_button.text = "Main Menu"

func format_time(milliseconds: float) -> String:
	var total_seconds = milliseconds / 1000.0
	var minutes = int(total_seconds) / 60
	var seconds = int(total_seconds) % 60
	var ms = int(milliseconds) % 1000
	return "%02d:%02d.%03d" % [minutes, seconds, ms]

func _on_play_again_pressed():
	print("Restarting game...")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_main_menu_pressed():
	print("Returning to main menu...")
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
