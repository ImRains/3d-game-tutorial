extends Node3D

## 敌人的骨骼，主要用于动画控制
class_name EnemySkin

## 动画树节点
@onready var animation_tree: AnimationTree = $AnimationTree
## 动画状态机
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
## 玩家是否移动
@onready var is_moving : bool = false :
	set(value):
		is_moving = value
		if is_moving:
			state_machine.travel("Run")
		else:
			state_machine.travel("Idle")
