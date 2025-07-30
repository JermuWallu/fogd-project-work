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
	# Get the current run score and previous high score
	current_run_score = int(Global.current_time)
	previous_high_score = int(Global.high_score)
	
	# Check if this is a new record (for time-based scoring, lower is better)
	# But only if there was a previous score (high_score > 0)
	is_new_record = (previous_high_score == 0) or (current_run_score < previous_high_score)
	
	# Stop the timer since the level is complete
	Global.stop_timer()
	
	# Set up the UI first (before updating high score)
	setup_labels()
	setup_buttons()
	
	# Update high score AFTER setting up labels (but Global system expects higher = better)
	if is_new_record:
		Global.set_high_score(current_run_score)

func setup_labels():
	# Set congratulations message
	congratulations_label.text = "🎉 CONGRATULATIONS! 🎉"
	congratulations_label.add_theme_font_size_override("font_size", 48)
	congratulations_label.add_theme_color_override("font_color", Color.GOLD)
	
	# Format time as minutes:seconds (convert from milliseconds)
	var total_seconds = current_run_score / 1000.0
	var minutes = int(total_seconds) / 60
	var seconds = int(total_seconds) % 60
	var ms = int(current_run_score) % 1000
	var time_text = "%02d:%02d.%03d" % [minutes, seconds, ms]
	
	# Set current score
	current_score_label.text = "Your Time: " + time_text
	current_score_label.add_theme_font_size_override("font_size", 32)
	current_score_label.add_theme_color_override("font_color", Color.WHITE)
	
	# Show new record message if applicable
	if is_new_record:
		new_record_label.text = "🏆 NEW RECORD! 🏆"
		new_record_label.add_theme_font_size_override("font_size", 36)
		new_record_label.add_theme_color_override("font_color", Color.YELLOW)
		new_record_label.visible = true
	else:
		new_record_label.visible = false
	
	# Set high score display
	if previous_high_score > 0:
		var prev_total_seconds = previous_high_score / 1000.0
		var prev_minutes = int(prev_total_seconds) / 60
		var prev_seconds = int(prev_total_seconds) % 60
		var prev_milliseconds = int(previous_high_score) % 1000
		var prev_time_text = "%02d:%02d.%03d" % [prev_minutes, prev_seconds, prev_milliseconds]
		
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

func _on_play_again_pressed():
	print("Restarting game...")
	# Reset game state for new run
	Global.reset_game_state()
	# Go back to main game scene
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_main_menu_pressed():
	print("Returning to main menu...")
	# Reset game state
	Global.reset_game_state()
	# Go to main menu
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# Handle input for quick navigation
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Enter key
		_on_play_again_pressed()
	elif event.is_action_pressed("ui_cancel"):  # Escape key
		_on_main_menu_pressed()
