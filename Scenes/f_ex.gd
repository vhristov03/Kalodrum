extends Sprite




func _ready():
	pass




func _on_f_ex_area_entered(area):
	if "Pesho" in area.get_name():
		queue_free()
