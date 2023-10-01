extends Node2D

var lifetime

func _ready():
	lifetime = $Particles2D.lifetime + 0.1
	$Particles2D.emitting = true
	
func _process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()
