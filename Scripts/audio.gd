class_name AudioPlayer extends Node2D

@onready var music = $Music

@onready var jump = $Jump
@onready var walk = $Walk


func startMusic() -> void:
	music.play()
	
func stopMusic() -> void:
	music.stop()

func playJump() -> void:
	jump.play()

func playWalk() -> void:
	walk.play()
