extends KinematicBody2D

export (int) var speed = 10000
var velocity = Vector2()


func _ready():
	pass

func get_input(delta):
	velocity = Vector2()
	velocity.y += 1
	if Input.is_action_pressed("collide"):
		velocity.y -= 1
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1
	if Input.is_action_pressed("jump"):
		velocity.y -= 2
	velocity = velocity.normalized() * speed * delta
	
	
	
	
	

func _physics_process(delta):
	get_input(delta)
	velocity = move_and_slide(velocity)
	



func _on_Area2D_area_entered(area):
	if "platform" in area.get_name():
		Input.action_press("collide")
		print("collision")
	pass # Replace with function body.
	



func _on_Area2D_area_exited(area):
	if "platform" in area.get_name():
		Input.action_release("collide")
		print("No longer colliding")
	pass # Replace with function body.
