extends Area2D

const MAX_JUMPS = 2

var jumps_remaining = 0;
var jumpspeed = 0
var speed = 10
var GravitySpeed = 10

 
func _ready():
	print("Na pesho mu e sprql toka")

func _process(delta):
	var inputx = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	position.x = position.x + inputx * speed
	
	var inputy = Input.is_action_just_pressed("jump")
	if inputy == true && jumps_remaining > 0:
		jumpspeed = 110
		jumps_remaining = jumps_remaining - 1
	position.y = clamp(position.y + gravity - jumpspeed , 0, 500)
	jumpspeed = clamp(jumpspeed-1,0,110)
		
	if position.y == 500:
		jumps_remaining = MAX_JUMPS
	
	
	
	
	
	
