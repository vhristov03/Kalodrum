extends AnimatedSprite


var pesho_in_zone = false
var waiting = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _process(delta):
	if pesho_in_zone == true and Input.is_action_pressed("ui_down"):
		waiting+=1
		if waiting >= 150:
			queue_free()



func _on_Fire_area_entered(area):
	if "Pesho" in area.get_name():
		pesho_in_zone = true


func _on_Fire_area_exited(area):
	if "Pesho" in area.get_name():
		pesho_in_zone = false
		waiting = 0
