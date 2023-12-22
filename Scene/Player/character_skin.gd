extends Node3D
class_name CharacterSkin

@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer

@onready var is_moving : bool = false :
	set(value):
		is_moving = value
		if is_moving:
			animation_player.play("Running_A")
		else:
			animation_player.play("Idle")
