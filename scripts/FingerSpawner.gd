extends Node


var finger_prefub = preload("res://fingers/Finger.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventMouseButton and not event.is_pressed():
		var new_finger = finger_prefub.instance()
		new_finger.strike_at(event.position)
		add_child(new_finger)
