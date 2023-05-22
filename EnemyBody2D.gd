extends KinematicBody2D

#Animation
export var taking_damagae_animation = ""
export var idle_animation = ""
export var walk_animation = ""
export var die_animation = ""
export var attack_animation = ""

#Exp
export var experience = ""

#End multiple hit
var multiple_hits = false

# Variables
export var health = 100
export var enemy_name = "Goblin"
export var attack = 3
export var speed = 100
export var knockback_force = 200
export var knockback_duration = 0.18
const GRAVITY = 750
onready var progress_bar = $ProgressBar

var velocity = Vector2()
var knockback_timer = 0.0
var area_enter = false

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	if knockback_timer > 0:
		knockback_timer -= delta
	else:
		velocity.x = -speed
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true

	move_and_slide(velocity, Vector2.UP)
	
	
	if area_enter:
		$PlayerAttackArea/CollisionShape2D.disabled = true
		$AnimatedSprite.speed_scale = 4.0
		$AnimatedSprite.play(attack_animation)
		$"/root/PlayerStats".health -= attack
		
func _on_EnemyBodyArea_area_entered(area):
	if area.name == "WeaponBody":
		var knockback_direction = (global_position - area.global_position).normalized()
		print(knockback_direction.x)
		take_hit(knockback_direction)
		progress_bar.value -= 1
		if progress_bar.value <= 0:
			$AnimatedSprite.speed_scale = 1.4
			$AnimatedSprite.play(die_animation)
			
			  
		print("I got hit")

func take_hit(knockback_direction):
	$AnimatedSprite.speed_scale = 3.5
	$AnimatedSprite.play(taking_damagae_animation)
	velocity.x = knockback_direction.x * knockback_force
	knockback_timer = knockback_duration


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == taking_damagae_animation:
		$AnimatedSprite.stop()
		$AnimatedSprite.speed_scale = 1.5
		$AnimatedSprite.play("Goblin_Walk")
	if $AnimatedSprite.animation == die_animation:
		$AnimatedSprite.stop()
		queue_free()
		$"/root/PlayerStats".num_of_kill_points += experience
	if $AnimatedSprite.animation == attack_animation:
		$AnimatedSprite.stop()
		$AnimatedSprite.speed_scale = 1.5
		$AnimatedSprite.play("Goblin_Walk")
		$PlayerAttackArea/CollisionShape2D.disabled = false
		



func _on_PlayerAttackArea_area_entered(area):
	if area.name == "PlayerBodyArea":
		print("Detected")
		area_enter = true
		
		
	


func _on_PlayerAttackArea_area_exited(area):
	if area.name == "PlayerBodyArea":
		area_enter = false
