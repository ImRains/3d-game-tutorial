extends StateBase

## 玩家节点
@export var player: Player

func enter() -> void:
	super.enter()
	print("[待机状态]")
	player.character_skin.is_moving = false

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	if player.direction:
		state_machine.change_state("Run")
