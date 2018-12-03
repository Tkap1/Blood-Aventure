extends "res://Scripts/Pickup.gd"


func applyEffect(body):
	if body.has_method("beatLevel"):
		body.beatLevel()