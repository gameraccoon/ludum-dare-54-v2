extends Node


func _input(event):
	if event is InputEventMouseButton and not event.is_pressed():
		$FingerSpawner.strike_finger_at(event.position)
