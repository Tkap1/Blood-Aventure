extends StaticBody2D

enum MOVE_STATE {CHASE,PATROL,IDLE,STATIC,JUMP}
export (MOVE_STATE) var moveState = null

enum ATTACK_STATE {MELEE,SHOOT}
export (ATTACK_STATE) var attackState = null

export (float) var spawnDelay = 3.0

export (float) var currHP = 100.0


func _ready():
	$SpawnTimer.wait_time = spawnDelay

func _on_SpawnTimer_timeout():
	if Refs.player.position.distance_to(position) <= Cfg.e_sleep_dist:
		spawn()
		
func spawn():
	var enemy = Refs.enemySc.instance()
	enemy.moveState = moveState
	enemy.attackState = attackState
	Refs.main.currLevel.add_child(enemy)
	enemy.position = position
	
func getHit(damage, invulnTime):
	currHP -= damage
	if currHP <= 0:
		die()
		
func die():
	var bloodPickup = Refs.bloodPickupSc.instance()
	Refs.main.add_child(bloodPickup)
	bloodPickup.position = position
	queue_free()
