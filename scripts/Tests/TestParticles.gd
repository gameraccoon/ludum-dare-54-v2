extends Node

var particle_prefub = preload("res://fingers/FingerParticle.tscn")

func _input(event):
	if event is InputEventMouseButton and not event.is_pressed():
		var particle = particle_prefub.instance()
		particle.position = event.position
		add_child(particle)
