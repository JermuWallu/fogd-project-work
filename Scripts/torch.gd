extends Node2D
@onready var sprite = $TorchSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play()
