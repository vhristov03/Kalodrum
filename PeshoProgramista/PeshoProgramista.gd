extends KinematicBody2D

export (int) var speed = 300
export (int) var jump_speed = -500
export (int) var gravity = 1500

var velocity = Vector2()
var is_jumping = false
var can_double_jump = false

func _ready():
	pass

func get_input():
	velocity.x = 0
	
	if Input.is_action_pressed('ui_right'):
		velocity.x += speed
	if Input.is_action_pressed('ui_left'):
		velocity.x -= speed
	if Input.is_action_pressed('ui_up') and is_on_floor():
		velocity.y = jump_speed
		is_jumping = true
		can_double_jump = true


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if is_jumping and is_on_floor():
		is_jumping = false
	if !is_on_floor() and can_double_jump and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		can_double_jump = false
	velocity = move_and_slide(velocity, Vector2(0, -1))


