extends Sprite


var fires_extinguished = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Fire_tree_exited():
	fires_extinguished += 1
	pass # Replace with function body.


func _on_Finish_area_entered(area):
	if "Pesho" in area.get_name() and fires_extinguished == 1:
		get_tree().change_scene("res://Scenes/Level 2.tscn")
	pass
