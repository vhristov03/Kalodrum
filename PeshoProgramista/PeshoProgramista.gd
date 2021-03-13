extends KinematicBody2D

export (int) var speed = 300
export (int) var jump_speed = -500
export (int) var gravity = 1500

var velocity = Vector2()
var is_jumping = false
var can_double_jump = false
var is_flipped = false
var respawn_x
var respawn_y


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
	
	if Input.is_action_pressed('ui_up') and Input.is_action_pressed('ui_right') and !is_on_floor() and is_on_wall():
		velocity.y = jump_speed
		is_jumping = true
	
	if Input.is_action_pressed('ui_up') and Input.is_action_pressed('ui_left') and !is_on_floor() and is_on_wall():
		velocity.y = jump_speed
		is_jumping = true

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	
	if is_jumping and is_on_floor():
		is_jumping = false
	
	if !is_on_floor() and can_double_jump and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		can_double_jump = false
	
	if !is_on_floor() and is_on_wall():
		velocity.x = 0
		velocity.y = velocity.y * 0.5
		is_jumping = false
		get_input()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))


func _process(delta):
	# while pressing right while on ground
	if Input.is_action_pressed('ui_right') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_run.show()
		
		# managing character orientation
		$pesho_run.flip_h = false
		$pesho_jump.flip_h = false
		$pesho_idle.flip_h = false
		$pesho_hang.flip_h = false
		
		$AnimationPlayer.play('run')
	
	# while pressing left while on the ground
	if Input.is_action_pressed('ui_left') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_run.show()
		
		# managing character orientation
		$pesho_run.flip_h = true
		$pesho_jump.flip_h = true
		$pesho_idle.flip_h = true
		$pesho_hang.flip_h = true
		
		$AnimationPlayer.play('run')
	
	# while trying to turn right mid-air
	if Input.is_action_pressed('ui_right'):
		# managing character orientation
		$pesho_run.flip_h = false
		$pesho_jump.flip_h = false
		$pesho_idle.flip_h = false
		$pesho_hang.flip_h = false
	
	#w while trying to turn left mid-air
	if Input.is_action_pressed('ui_left'):
		# managing character orientation
		$pesho_run.flip_h = true
		$pesho_jump.flip_h = true
		$pesho_idle.flip_h = true
		$pesho_hang.flip_h = true
	
	# while pressing up
	if !is_on_floor():
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_jump.show()
		
		$AnimationPlayer.play('jump')
	
	# while pressing up and right
	if Input.is_action_just_pressed('ui_up') and Input.is_action_pressed('ui_right'):
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_jump.show()
		
		# managing character orientation
		$pesho_jump.flip_h = false
		
		$AnimationPlayer.play('jump')
	
	# while pressing up and left
	if Input.is_action_just_pressed('ui_up') and Input.is_action_pressed('ui_left'):
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_jump.show()
		
		# managing character orientation
		$pesho_jump.flip_h = true
		
		$AnimationPlayer.play('jump')
	
	# while not pressing anything
	if !Input.is_action_pressed('ui_up') and !Input.is_action_pressed('ui_right') and !Input.is_action_pressed('ui_left') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_run.hide()
		$pesho_hang.hide()
		$pesho_idle.show()
		
		$AnimationPlayer.play('idle')
		
	if !is_on_floor() and is_on_wall():
		$pesho_jump.hide()
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_hang.show()
	
	if position.y >= 500:
		position.x = respawn_x
		position.y = respawn_y


func _on_Area2D_area_entered(area):
	if "f_ex" in area.get_name():
		print("Fire extinguisher picked up")
	if "Checkpoint" in area.get_name():
		respawn_x = position.x
		respawn_y = position.y
		print("Checkpoint reached")
	
