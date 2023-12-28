extends CharacterBody3D
## 玩家
class_name Player

@onready var character_rotation_root: Node3D = $CharacterRotationRoot
@onready var character_skin: CharacterSkin = $CharacterRotationRoot/CharacterSkin


# 速度
const SPEED = 5.0
# 跳跃
const JUMP_VELOCITY = 4.5
# 方向
var direction: Vector3

# 重力
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# 添加重力
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 跳跃
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# 获得方向
	direction = (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()

	move_and_slide()
