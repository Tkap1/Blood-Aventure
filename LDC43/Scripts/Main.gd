extends Node2D

var currLevel

var levelNumber = 1
var player

onready var bloodBar = $CanvasLayer/Control/BloodBar


func _ready():
	Refs.main = self
	startGame()
	
	
func _playerBlood(player):
	bloodBar.max_value = Cfg.p_max_blood
	bloodBar.value = player.blood

func _playerDead(player):
	startGame()
	
	
func _levelBeat():
	levelNumber += 1
	startGame()
	
func startGame():
	
	# Delete remaining bullets, particles, etc
	for removable in get_tree().get_nodes_in_group("removables"):
		removable.queue_free()
		
	yield(get_tree(), "idle_frame")
	
	if currLevel != null:
		currLevel.queue_free()
		currLevel = null
	currLevel = Refs.get("level%s" % levelNumber).instance()
	add_child(currLevel)
	
	if player != null:
		player.queue_free()
		player = null
	player = Refs.playerSc.instance()
	add_child(player)
	Refs.player = player
	player.position = currLevel.playerStartPos.position
	player.connect("bloodChanged", self, "_playerBlood")
	player.connect("playerDead", self, "_playerDead")
	player.connect("levelBeat", self, "_levelBeat")
	