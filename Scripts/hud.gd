extends CanvasLayer

@onready var health_container = $UI/HealthContainer
@onready var death_screen = $UI/DeathScreen
@onready var restart_button = $UI/DeathScreen/CenterContainer/VBoxContainer/RestartButton
@onready var quit_button = $UI/DeathScreen/CenterContainer/VBoxContainer/QuitButton

@export var heart_full_texture: Texture2D
@export var heart_empty_texture: Texture2D

var heart_icons: Array[TextureRect] = []
var max_health: int = 3
var current_health: int = 3
var is_player_dead: bool = false
var timer_label: Label

func _ready():
	# Connect to global health signals
	if Global.has_signal("player_health_changed"):
		Global.player_health_changed.connect(_on_health_changed)
	if Global.has_signal("player_died"):
		Global.player_died.connect(_on_player_died)

	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

	max_health = Global.max_hp
	current_health = Global.get_player_hp()
	create_heart_icons()
	update_health_display()

	# Ensure death screen is hidden initially
	death_screen.visible = false
	is_player_dead = false

	# Create timer display
	create_timer_display()

func create_timer_display():
	timer_label = Label.new()
	timer_label.text = "Time: 0:00.00"
	timer_label.position = Vector2(20, 80)  # Below health hearts

	var timer_settings = LabelSettings.new()
	timer_settings.font_size = 24
	timer_settings.font_color = Color.WHITE
	timer_label.label_settings = timer_settings

	$UI.add_child(timer_label)

func _process(_delta):
	# Update timer display
	if timer_label and Global.timer_running:
		var current_time = Global.get_current_score()
		timer_label.text = "Time: " + format_time(current_time)

func format_time(seconds: float) -> String:
	var minutes = int(seconds / 60)
	var remaining_seconds = int(seconds) % 60
	return "%d:%02d" % [minutes, remaining_seconds]

func create_heart_icons():
	for heart in heart_icons:
		heart.queue_free()
	heart_icons.clear()

	for i in range(max_health):
		var heart_icon = TextureRect.new()
		heart_icon.texture = heart_full_texture
		heart_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart_icon.custom_minimum_size = Vector2(40, 40)

		health_container.add_child(heart_icon)
		heart_icons.append(heart_icon)

func update_health_display():
	for i in range(heart_icons.size()):
		if i < current_health:
			# Show full heart for available health
			heart_icons[i].texture = heart_full_texture
			heart_icons[i].modulate = Color.WHITE
		else:
			# Show empty heart for missing health
			heart_icons[i].texture = heart_empty_texture
			heart_icons[i].modulate = Color.WHITE

func _on_health_changed(new_health: int):
	current_health = new_health
	update_health_display()

	if current_health > 0:
		animate_health_change()

func animate_health_change():
	var tween = create_tween()
	tween.tween_property(health_container, "modulate", Color.RED, 0.1)
	tween.tween_property(health_container, "modulate", Color.WHITE, 0.1)

func _on_player_died():
	print("Player died! Showing death screen.")
	is_player_dead = true
	Global.timer_running = false
	show_death_screen()

func show_death_screen():
	death_screen.visible = true
	death_screen.modulate.a = 0.0

	# Animate death screen fade in
	var tween = create_tween()
	tween.tween_property(death_screen, "modulate:a", 1.0, 0.5)

func _on_restart_button_pressed():
	print("Restart button pressed!")
	Global.reset_player_health()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	print("Quit button pressed!")
	Global.reset_player_health()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
