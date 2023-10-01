extends Node2D

const scale_from = 0.0
const scale_to = 1.0

const alpha_from = 0.0
const alpha_to = 0.6

func set_weigth(weigth):
	weigth = clamp(weigth, 0.0, 1.0)
	scale = Vector2(1, 1) * lerp(scale_from, scale_to, weigth)
	$Sprite.self_modulate.a = lerp(alpha_from, alpha_to, weigth)
