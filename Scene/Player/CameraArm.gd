extends SpringArm3D
## 相机控制器
class_name CameraArm

## 控制x轴上的旋转速度
@export var x_speed: float = 5
## 控制y轴上的旋转速度
@export var y_speed: float = 5
## 最小角度(摄像机与地面的夹角)
@export_range(10, 80) var x_min_limit_angle : float = 20
## 最大角度(摄像机与地面的夹角)
@export_range(10, 80) var x_max_limit_angle : float = 80
## 默认相机视距(弹簧臂长度)
@export var distance:float = 15
## 最小相机视距
@export var min_distance:float = 5
## 最大相机视距
@export var max_distance:float = 30
## 视距滚动的速度
@export var distance_speed: float = 5
## 视角转动 - 是否需要阻尼
@export var need_damping:bool = true
## 视角转动 - 阻尼大小
@export var damping:float = 10

## 鼠标右键是否按下
var mouse_right_press:bool = false
## 鼠标滑动的状态枚举
enum MOUSE_WHEEL_STATE{
	NONE = 0, # 未滑动
	UP =  -1, # 向前滑动
	DOWN = 1, # 向后滑动
}
## 鼠标的滚轮状态
var mouse_wheel: MOUSE_WHEEL_STATE = MOUSE_WHEEL_STATE.NONE

# 存储x、y轴的旋转欧拉角，根据x，y来调整弹簧臂的旋转
var x:float = 0
var y:float = 0

## 初始化函数
func _ready() -> void:
	## 初始化x、y的值
	x = transform.basis.get_euler().x
	y = transform.basis.get_euler().y

func _process(delta: float) -> void:
	update_mouse_input()
	# 根据已有的欧拉角，来获取3D旋转的单位四元数
	var _rotation:Quaternion = Quaternion.from_euler(Vector3(x, y, 0))
	# 根据滚轮事件，来调整视距
	distance += mouse_wheel * distance_speed * delta
	# 限定distance长短，不越界
	distance = clamp(distance, min_distance, max_distance)
	# 判断是都需要阻尼
	if need_damping:
		# 使用slerp方法，来逐帧调整数值
		quaternion = quaternion.slerp(_rotation, delta * damping)
		# 使用lerp方法，来逐帧调整数值
		spring_length = lerp(spring_length, distance, delta * damping)
	else:
		quaternion = _rotation
		spring_length = distance

func _input(event: InputEvent) -> void:
	#判断当前事件是否为鼠标移动 且 鼠标右键被按下，来更新x,y的值
	if event is InputEventMouseMotion and mouse_right_press:
		# 鼠标上下位移，调整的是视野上下移动，此时旋转的是x轴
		x = x + -event.relative.y * x_speed * 0.0002
		# 鼠标左右移动，调整的是视野的左右移动，旋转的是y轴
		y = y + -event.relative.x * x_speed * 0.0002
		# 根据视角角度边界，来限制x的值
		var x_min_limit = x_min_limit_angle/180*PI #-3.14 到 +3.14
		var x_max_limit = x_max_limit_angle/180*PI
		x = -clamp(-x, x_min_limit, x_max_limit) # 限制x

## 更新鼠标输入
func update_mouse_input() -> void:
	## 判断鼠标有没有按下右键
	mouse_right_press = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	## 判断鼠标是否前滑
	var is_wheel_up = Input.is_action_just_released("mouse_scroll_up")
	## 判断鼠标是否后滑
	var is_wheel_down = Input.is_action_just_released("mouse_scroll_down")
	if is_wheel_up:
		mouse_wheel = MOUSE_WHEEL_STATE.UP ## 1
	elif is_wheel_down:
		mouse_wheel = MOUSE_WHEEL_STATE.DOWN ## -1
	else:
		mouse_wheel = MOUSE_WHEEL_STATE.NONE ## 0
