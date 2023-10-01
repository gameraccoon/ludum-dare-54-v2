extends Node


var finger_prefub = preload("res://fingers/Finger.tscn")

func strike_finger_at(position: Vector2):
	var new_finger = finger_prefub.instance()
	new_finger.strike_at(position)
	add_child(new_finger)
