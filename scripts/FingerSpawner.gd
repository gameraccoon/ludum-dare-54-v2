extends Node

export var fingers_root:NodePath


var finger_prefub = preload("res://fingers/Finger.tscn")
var particles_prefub = preload("res://fingers/FingerParticle.tscn")

signal finger_stroke

func finger_stroke_callback(finger_pos: Vector2):
	emit_signal("finger_stroke")
	var finger_bang = particles_prefub.instance()
	finger_bang.position = finger_pos
	add_child(finger_bang)

func strike_finger_at(position: Vector2):
	var new_finger = finger_prefub.instance()
	new_finger.strike_at(position, funcref(self, "finger_stroke_callback"))
	get_node(fingers_root).add_child(new_finger)
