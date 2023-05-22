extends Node2D
onready var WizardBody = $Enemy/EnemyBody2D
onready var wizardSprite = $Enemy/EnemyBody2D/AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	wizardSprite.speed = 0.5
	wizardSprite.animation = "Wizard"
	pass # Replace with function body.

