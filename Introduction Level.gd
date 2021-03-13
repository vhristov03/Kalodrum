extends Node2D

var timer_for_intro = 0

func _ready():
	print("level loaded")


func _process(delta):
	if timer_for_intro == 0:
		$VideoPlayer.show()
		
	timer_for_intro += 1
	
	if timer_for_intro >= 660:
		$VideoPlayer.hide()
	pass
	

	pass # Replace with function body.
