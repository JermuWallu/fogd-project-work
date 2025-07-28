extends Node2D

@onready var audio = $Audio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.startMusic()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
