extends Node

# Global variables and functions for the game
# This script can be used to manage game state, player health, etc.
var player_hp: int = 3
var max_hp: int = 3

signal player_health_changed(new_hp: int)
signal player_died()

func _ready():
	player_hp = max_hp

func damage_player(damage: int = 1):
	player_hp = max(0, player_hp - damage)
	player_health_changed.emit(player_hp)

	if player_hp <= 0:
		player_died.emit()
		print("Player died!")
        #TODO: Reset player health or handle game over logic here

func heal_player(heal_amount: int = 1):
	player_hp = min(max_hp, player_hp + heal_amount)
	player_health_changed.emit(player_hp)

func reset_player_health():
	player_hp = max_hp
	player_health_changed.emit(player_hp)

func get_player_hp() -> int:
	return player_hp
