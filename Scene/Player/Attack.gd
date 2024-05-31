extends StateBase

@export var player: Player
@export var attack_speed_ratio:float = 0.5
@export var hit_box_collision_shape:CollisionShape3D
@export var hit_box_animation_player:AnimationPlayer

func enter() -> void:
	super.enter()
	print("[攻击状态]")
	## 播放攻击动画
	player.character_skin.attack()
	hit_box_animation_player.play("hit_box_attack")

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	
	# 方向有值，说明在移动
	if player.direction:
		player.velocity.x = player.direction.x * player.SPEED * attack_speed_ratio
		player.velocity.z = player.direction.z * player.SPEED * attack_speed_ratio
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	if abs(player.velocity.x) + abs(player.velocity.z) > 0.1:
		var characterDir = Vector2(player.velocity.z, player.velocity.x)
		var target_quaternion:Quaternion = Quaternion.from_euler(Vector3(0, characterDir.angle(), 0))
		player.character_rotation_root.quaternion = player.character_rotation_root.quaternion.slerp(target_quaternion, delta * 10)

## 攻击检测区域开启
func hit_box_enable() -> void:
	hit_box_collision_shape.disabled = false

## 攻击检测区域关闭
func hit_box_disable() -> void:
	hit_box_collision_shape.disabled = true

## 转为待机状态
func turn_idle() -> void:
	state_machine.change_state("Idle")
