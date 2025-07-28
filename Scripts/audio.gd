class_name AudioPlayer extends Node2D

@onready var music = $Music

@onready var jump = $Jump
@onready var walk = $Walk
@onready var punch = $Punch

@onready var bubblePop = $BubblePop
@onready var bubbleMove = $BubbleMove

func startMusic() -> void:
	music.play()
	
func stopMusic() -> void:
	music.stop()

func playJump() -> void:
	jump.play()

func playWalk() -> void:
	walk.play()
	
func playPunch() -> void:
	punch.play()

func playBubblePop() -> void:
	bubblePop.play()
	
func playBubbleMove() -> void:
	bubbleMove.play()
