class_name AudioPlayer extends Node2D

@onready var music = $Music
@onready var jump = $Jump
@onready var walk = $Walk
@onready var hurt = $Hurt
@onready var squashed = $Squashed
@onready var fly = $Fly

func startMusic() -> void:
	music.play()

func stopMusic() -> void:
	music.stop()

func playJump() -> void:
	jump.play()

func playWalk() -> void:
	walk.play()

func playHurt() -> void:
	hurt.play()

func playSquashed() -> void:
	squashed.play()

func startFly() -> void:
	fly.play()


func stopFly() -> void:
	fly.stop()
