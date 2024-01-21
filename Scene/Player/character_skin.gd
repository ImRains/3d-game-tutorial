extends Node3D
## 玩家骨骼
class_name CharacterSkin

## 玩家动画节点
@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer
## 动画树节点
@onready var animation_tree: AnimationTree = $AnimationTree
## 动画状态机
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
## 玩家是否移动
@onready var is_moving : bool = false :
	set(value):
		is_moving = value
		if is_moving:
			state_machine.travel("Move")
		else:
			state_machine.travel("Idle")

## 跳跃动画播放
func jump() -> void:
	state_machine.travel("Jump")

## 下落动画播放
func fall() -> void:
	state_machine.travel("Fall")
