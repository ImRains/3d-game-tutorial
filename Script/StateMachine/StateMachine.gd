extends Node3D

## 角色的状态机
class_name StateMachine

## 默认状态
@export var current_state: StateBase

func _ready() -> void:
	for child in get_children():
		if child is StateBase:
			child.state_machine = self
	await get_parent().ready
	current_state.enter()

func _process(delta: float) -> void:
	current_state.process_update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_process_update(delta)

## 修改状态
func change_state(target_state_name: String) -> void:
	var target_state = get_node_or_null(target_state_name)
	if target_state == null:
		printerr("状态传入错误")
		return
	current_state.exit()
	current_state = target_state
	current_state.enter()
