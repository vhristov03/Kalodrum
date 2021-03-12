extends Area2D
var jumpspeed = 0
var speed = 10
var GravitySpeed = 10
 
func _ready():
	print("Na pesho mu e sprql toka")

func _process(delta):
	var inputx = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	position.x = position.x + inputx * speed
	
	var inputy = Input.is_action_just_pressed("jump")
	if inputy == true:
		jumpspeed = 110
	position.y = clamp(position.y + gravity - jumpspeed , 0, 500)
	jumpspeed = clamp(jumpspeed-1,0,110)
	
	
	
	
	
	
