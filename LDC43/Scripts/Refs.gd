extends Node

var level1 = load("res://Scenes/Levels/Level1.tscn")
var level2 = load("res://Scenes/Levels/Level2.tscn")
var level3 = load("res://Scenes/Levels/Level3.tscn")
var level4 = load("res://Scenes/Levels/Level4.tscn")
var level5 = load("res://Scenes/Levels/Level5.tscn")
var level6 = load("res://Scenes/Levels/Level6.tscn")
var level7 = load("res://Scenes/Levels/Level7.tscn")
var level8 = load("res://Scenes/Levels/Level8.tscn")
var level9 = load("res://Scenes/Levels/Level9.tscn")
var level10 = load("res://Scenes/Levels/Level10.tscn")

var playerSc = load("res://Scenes/Player.tscn")
var bulletParticlesSc = load("res://Scenes/BulletParticles.tscn")
var enemySc = load("res://Scenes/Enemy.tscn")
var bulletSc = load("res://Scenes/Bullet.tscn")
var bloodPickupSc = load("res://Scenes/Levels/BloodPickup.tscn")

var player
var curr_level
var main


var mask_player = 0
var mask_enemy = 1
var mask_terrain = 2