extends CharacterBody3D
## 玩家
class_name Player

@onready var character_rotation_root: Node3D = $CharacterRotationRoot
@onready var character_skin: CharacterSkin = $CharacterRotationRoot/CharacterSkin
@onready var camera_arm: SpringArm3D = $CameraArm
@onready var state_machine: StateMachine = $StateMachine

## ---------Player属性 -----------
## 当前生命值
@export var current_health:int = 10
## 最大生命值
@export var max_health:int = 10
## 攻击力
@export var attack_power:int = 1

## 速度
const SPEED = 5.0
# 跳跃
const JUMP_VELOCITY = 14
# 方向
var direction: Vector3

# 重力
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# 添加重力
	if not is_on_floor():
		velocity.y -= gravity * delta * 2
		# 高出掉落进入下落状态
		if state_machine.current_state.name != "Jump" and state_machine.current_state.name != "Fall":
			state_machine.change_state("Fall")

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# 获得方向
	var _rotation:Quaternion = Quaternion.from_euler(Vector3(0, camera_arm.transform.basis.get_euler().y, 0))
	direction = (_rotation * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		state_machine.change_state("Jump")
	if event.is_action_pressed("mouse_left"):
		state_machine.change_state("Attack")


func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		## 敌人受到伤害
		body.take_damage(attack_power)
		pass
