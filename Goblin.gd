extends Node2D

onready var goblin = $Enemy/EnemyBody2D
onready var goblin_animation = $Enemy/EnemyBody2D/AnimatedSprite
onready var enemy_progress = $Enemy/EnemyBody2D/ProgressBar
func _ready():
	goblin.speed = 25
	goblin.health = 3
	goblin.attack = 1
	enemy_progress.max_value = goblin.health
	enemy_progress.value = 3
	goblin_animation.play("Goblin_Idle")
	goblin.taking_damagae_animation = "Goblin_Taking_Damage"
	goblin.die_animation = "Goblin_Die"
	goblin.experience = 1
	goblin.attack_animation = "Goblin_Attack"
