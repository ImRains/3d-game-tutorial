extends CharacterBody3D

## 敌人
class_name Enemy

## ---------Enemy属性 -----------
## 当前生命值
@export var current_health:int = 3:
	set(value):
		if value <= 0:
			current_health = 0
			is_death = true
			# 处理死亡操作
			enemy_death()
		else:
			current_health = value
			# 没有死亡，播放受击动画
			enemy_skin.hit()
## 最大生命值
@export var max_health:int = 3
## 攻击力
@export var attack_power:int = 1
@export var is_death:bool = false

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
	# 敌人死亡后，不进行其他操作
	if is_death:
		return
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

## 受到伤害
func take_damage(damage:int) -> void:
	print("受到伤害",damage)
	current_health = current_health - damage

## 角色死亡 销毁节点
func enemy_death() -> void:
	# 播放死亡动画
	enemy_skin.death()
	await  get_tree().create_timer(3).timeout
	queue_free()
