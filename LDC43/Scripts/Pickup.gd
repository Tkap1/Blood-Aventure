extends Area2D


func _ready():
	add_to_group("removables")
	z_index = Cfg.pickup_z

func _on_Pickup_body_entered(body):
	applyEffect(body)
