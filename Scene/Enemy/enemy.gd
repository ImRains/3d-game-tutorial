extends CharacterBody3D

## 敌人
class_name Enemy

## 敌人速度
@export var speed:float = 4.0
## 敌人追击玩家的停止距离
@export var stop_distance:float = 2.0

## 玩家节点
@onready var player:Player
## 导航代理节点
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var character_rotation_root: Node3D = $CharacterRotationRoot
@onready var enemy_skin: EnemySkin = $CharacterRotationRoot/EnemySkin


func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")

func _physics_process(delta: float) -> void:
	## 获取方向
	var direction_3d := (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	## 设置敌人速度
	velocity = direction_3d * speed
	## 距离大于停止距离，继续移动
	if navigation_agent_3d.distance_to_target() > stop_distance:
		enemy_skin.is_moving = true
		move_and_slide()
	else:
		enemy_skin.is_moving = false
	
	## 敌人转向
	var direction_2d := Vector2(direction_3d.z, direction_3d.x)
	var target_quaternion:Quaternion = Quaternion.from_euler(Vector3(0, direction_2d.angle(),0))
	character_rotation_root.quaternion = character_rotation_root.quaternion.slerp(target_quaternion, delta * 10)


func _on_timer_timeout() -> void:
	navigation_agent_3d.target_position = player.global_position
	navigation_agent_3d.target_position = navigation_agent_3d.get_final_position()
