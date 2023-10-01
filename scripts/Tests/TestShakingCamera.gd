extends Node

func _input(event):
	if event is InputEventMouseButton and not event.is_pressed():
		$Camera2D.shake_camera(5.0, 0.5)
