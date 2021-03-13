extends KinematicBody2D

export (int) var speed = 300
export (int) var jump_speed = -500
export (int) var gravity = 1500

var velocity = Vector2()
var is_jumping = false
var can_double_jump = false
var is_flipped = false


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


func _process(delta):
	# while pressing right while on ground
	if Input.is_action_pressed('ui_right') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_idle.hide()
		$pesho_run.show()
		
		# managing character orientation
		$pesho_run.flip_h = false
		$pesho_jump.flip_h = false
		$pesho_idle.flip_h = false
		
		$AnimationPlayer.play('run')
	
	# while pressing left while on the ground
	if Input.is_action_pressed('ui_left') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_idle.hide()
		$pesho_run.show()
		
		# managing character orientation
		$pesho_run.flip_h = true
		$pesho_jump.flip_h = true
		$pesho_idle.flip_h = true
		
		$AnimationPlayer.play('run')
	
	# while trying to turn right mid-air
	if Input.is_action_pressed('ui_right'):
		# managing character orientation
		$pesho_run.flip_h = false
		$pesho_jump.flip_h = false
		$pesho_idle.flip_h = false
	
	#w while trying to turn left mid-air
	if Input.is_action_pressed('ui_left'):
		# managing character orientation
		$pesho_run.flip_h = true
		$pesho_jump.flip_h = true
		$pesho_idle.flip_h = true
	
	# while pressing up
	if !is_on_floor():
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_jump.show()
		
		$AnimationPlayer.play('jump')
	
	# while pressing up and right
	if Input.is_action_just_pressed('ui_up') and Input.is_action_pressed('ui_right'):
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_jump.show()
		
		# managing character orientation
		$pesho_jump.flip_h = false
		
		$AnimationPlayer.play('jump')
	
	# while pressing up and left
	if Input.is_action_just_pressed('ui_up') and Input.is_action_pressed('ui_left'):
		# managing animation visibility
		$pesho_run.hide()
		$pesho_idle.hide()
		$pesho_jump.show()
		
		# managing character orientation
		$pesho_jump.flip_h = true
		
		$AnimationPlayer.play('jump')
	
	# while not pressing anything
	if !Input.is_action_pressed('ui_up') and !Input.is_action_pressed('ui_right') and !Input.is_action_pressed('ui_left') and is_on_floor():
		# managing animation visibility
		$pesho_jump.hide()
		$pesho_run.hide()
		$pesho_idle.show()
		
		$AnimationPlayer.play('idle')
