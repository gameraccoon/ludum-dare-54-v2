extends Node


var finger_prefub = preload("res://fingers/Finger.tscn")

signal finger_stroke

func finger_stroke_callback():
	emit_signal("finger_stroke")

func strike_finger_at(position: Vector2):
	var new_finger = finger_prefub.instance()
	new_finger.strike_at(position, funcref(self, "finger_stroke_callback"))
	add_child(new_finger)
