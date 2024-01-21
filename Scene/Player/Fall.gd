extends StateBase

@export var player: Player

func enter() -> void:
	super.enter()
	print("[下落状态]")
	player.character_skin.fall()

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	if player.is_on_floor():
		state_machine.change_state("Idle")
	
	# 方向有值，说明在移动
	if player.direction:
		player.velocity.x = player.direction.x * player.SPEED
		player.velocity.z = player.direction.z * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	if abs(player.velocity.x) + abs(player.velocity.z) > 0.1:
		var characterDir = Vector2(player.velocity.z, player.velocity.x)
		var target_quaternion:Quaternion = Quaternion.from_euler(Vector3(0, characterDir.angle(), 0))
		player.character_rotation_root.quaternion = player.character_rotation_root.quaternion.slerp(target_quaternion, delta * 10)
