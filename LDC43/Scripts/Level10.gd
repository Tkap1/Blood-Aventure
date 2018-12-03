extends "res://Scripts/Level.gd"

var beaten = false

onready var rect = $CanvasLayer/ColorRect

func _physics_process(delta):
	if not beaten:
		if $Other/RichTextLabel.modulate.a > 0:
			$Other/RichTextLabel.modulate.a -= 0.01
	print($Timer.time_left)

func _on_Timer_timeout():
	beaten = true
	for child in $Other.get_children():
		child.queue_free()
	for child in $Enemies.get_children():
		child.queue_free()
		
	yield(get_tree().create_timer(5.0), "timeout")
	Refs.player.ignore_input = true
	$TileMap.queue_free()
	rect.show()
	$Noo.play()
	$Tween.interpolate_property(rect, "modulate:a", 0, 1, 3.0, Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	$CanvasLayer/RichTextLabel3.show()
	yield(get_tree().create_timer(5.0), "timeout")
	get_tree().quit()
	
