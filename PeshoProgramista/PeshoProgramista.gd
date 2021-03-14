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
var in_fire_zone = false
var wall_jumps_remaining = 1

var timer_for_intro = 0

func _ready():
	respawn_x = position.x
	respawn_y = position.y
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
	
	if Input.is_action_pressed('ui_up') and Input.is_action_pressed('ui_left') and !is_on_floor() and is_on_wall() and is_flipped and wall_jumps_remaining == 1:
		velocity.y = jump_speed*2
		velocity.x += speed*2
		is_jumping = true
		wall_jumps_remaining = 0
		Input.action_release("ui_left")
		
	
	if Input.is_action_pressed('ui_up') and Input.is_action_pressed('ui_right') and !is_on_floor() and is_on_wall() and !is_flipped and wall_jumps_remaining == 1:
		velocity.y = jump_speed*2
		velocity.x -= speed*2
		is_jumping = true
		wall_jumps_remaining = 0
		Input.action_release("ui_right")
		
	
	if is_on_floor():
		wall_jumps_remaining = 1

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	
	if is_jumping and is_on_floor():
		is_jumping = false
	
	if !is_on_floor() and can_double_jump and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		can_double_jump = false
	
	if !is_on_floor() and is_on_wall():
		can_double_jump = false
		if !is_flipped:
			velocity.x -= speed
		if is_flipped:
			velocity.x += speed
		velocity.y = velocity.y * 0.5
		is_jumping = false
		get_input()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))


func flip_right():
	$pesho_run.flip_h = false
	$pesho_jump.flip_h = false
	$pesho_idle.flip_h = false
	$pesho_hang.flip_h = false
	$pesho_extinguish.flip_h = false
	is_flipped = false


func flip_left():
	$pesho_run.flip_h = true
	$pesho_jump.flip_h = true
	$pesho_idle.flip_h = true
	$pesho_hang.flip_h = true
	$pesho_extinguish.flip_h = true
	is_flipped = true


func _process(delta):
	# while pressing right while on ground
	if Input.is_action_pressed('ui_right') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_extinguish.hide()
		$pesho_run.show()
		
		# managing character orientation
		flip_right()
		
		$AnimationPlayer.play('run')
	
	# while pressing left while on the ground
	if Input.is_action_pressed('ui_left') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_extinguish.hide()
		$pesho_run.show()
		
		# managing character orientation
		flip_left()
		
		$AnimationPlayer.play('run')
	
	# while trying to turn right mid-air
	if Input.is_action_pressed('ui_right'):
		# managing character orientation
		flip_right()
	
	#w while trying to turn left mid-air
	if Input.is_action_pressed('ui_left'):
		# managing character orientation
		flip_left()
	
	# while pressing up
	if !is_on_floor():
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_extinguish.hide()
		$pesho_jump.show()
		
		$AnimationPlayer.play('jump')
	
	# while pressing up and right
	if Input.is_action_just_pressed('ui_up') and Input.is_action_pressed('ui_right'):
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_extinguish.hide()
		$pesho_jump.show()
		
		# managing character orientation
		$pesho_jump.flip_h = false
		is_flipped = false
		
		$AnimationPlayer.play('jump')
	
	# while pressing up and left
	if Input.is_action_just_pressed('ui_up') and Input.is_action_pressed('ui_left'):
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_extinguish.hide()
		$pesho_jump.show()
		
		# managing character orientation
		$pesho_jump.flip_h = true
		is_flipped = true
		
		$AnimationPlayer.play('jump')
	
	# while not pressing anything
	if !Input.is_action_pressed('ui_up') and !Input.is_action_pressed('ui_right') and !Input.is_action_pressed('ui_left') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_run.hide()
		$pesho_hang.hide()
		$pesho_extinguish.hide()
		$pesho_idle.show()
		
		$AnimationPlayer.play('idle')
		
	if !is_on_floor() and is_on_wall():
		$pesho_jump.hide()
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_extinguish.hide()
		$pesho_hang.show()
		
	if Input.is_action_pressed('ui_down') and in_fire_zone == true:
		$pesho_jump.hide()
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_hang.hide()
		$pesho_extinguish.show()
	
	if position.y >= 650:
		position.x = respawn_x
		position.y = respawn_y



func _on_Area2D_area_entered(area):
	if "Checkpoint" in area.get_name():
		respawn_x = position.x
		respawn_y = position.y
		print("Checkpoint reached")
	if "Fire" in area.get_name():
		in_fire_zone = true


func _on_Pesho_area_exited(area):
	if "Fire" in area.get_name():
		in_fire_zone = false
