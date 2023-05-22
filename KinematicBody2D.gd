extends KinematicBody2D

const GRAVITY = 750
const JUMP_SPEED = -100
const MOVE_SPEED = 200
var motion = Vector2.ZERO
var previous_motion = Vector2.ZERO

export var knockback_duration = 0.18
var knockback_timer = 0.0

onready var sprite = $AnimatedSprite
onready var stream = $AudioStreamPlayer2D

var jumpSound = load("res://Mp3/Fatboyjump.mp3")
var attackSound = load("res://Mp3/FatBoyAttack.mp3")
var weaponStatus = "none"

var is_jump_sound_playing = false
var is_attacking = false
var is_taking_damage = false

func _ready():
	sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

func _physics_process(delta):
	motion.y += GRAVITY * delta
	
	if($"/root/PlayerStats".health <= 0):
		sprite.play("die_animation")
	
	if knockback_timer > 0:
		knockback_timer -= delta
	else:
		motion.x = MOVE_SPEED * Input.get_action_strength("move_right") - MOVE_SPEED * Input.get_action_strength("move_left")

	if not is_taking_damage:
		if not is_attacking:
			if Input.is_action_pressed("move_left"):
				sprite.speed_scale = 1.5
				sprite.play(movement_animation_type())
				sprite.flip_h = true
			elif Input.is_action_pressed("move_right"):
				sprite.speed_scale = 1.5
				sprite.play(movement_animation_type())
				sprite.flip_h = false
			else:
				sprite.speed_scale = 0.5
				sprite.play(idle_animation_type())

			if is_on_floor() and Input.is_action_just_pressed("jump") and not is_jump_sound_playing:
				motion.y = JUMP_SPEED
				play_sound("Jump")

		if $"/root/CharacterEquipments".main_weapon == "Classic Sword" and Input.is_action_just_pressed("attack") :
			is_attacking = true
			sprite.speed_scale = 2.5
			$WeaponBody/WeaponCollision.disabled = false
			sprite.play("basic_attack")
			play_sound("Attack")

	motion = move_and_slide(motion, Vector2.UP)
	previous_motion = motion

func movement_animation_type():
	if $"/root/CharacterEquipments".main_weapon == "Classic Sword":
		return "sword_right"
	else:
		return "walk_right"

func idle_animation_type():
	if $"/root/CharacterEquipments".main_weapon == "Classic Sword":
		return "idle_sword"
	else:
		return "idle_right"

func play_sound(status):
	if status == "Jump":
		if not is_jump_sound_playing:
			print("Jump works")
			stream.stream = jumpSound
			
	elif status == "Attack":
		stream.stream = attackSound
	stream.play()

func _on_AudioStreamPlayer2D_finished():
	print("Finish")
	
	stream.stop()

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "basic_attack":
		is_attacking = false
		$WeaponBody/WeaponCollision.disabled = true
		sprite.play(idle_animation_type())
	elif sprite.animation == "damage_taken":
		is_taking_damage = false
		sprite.play(idle_animation_type())
	elif sprite.animation == "die_animation":		
		queue_free()
		$"/root/PlayerStats".reset()
		$"/root/CharacterEquipments".reset()
		get_tree().reload_current_scene()
	if not is_attacking:
		$WeaponBody/WeaponCollision.disabled = true
		
func _on_PlayerBodyArea_area_entered(area):
	if area.name == "PlayerAttackArea":
			var position = (global_position - area.global_position).normalized()
			take_hit(position)

func take_hit(position):
	if not is_taking_damage:
		is_taking_damage = true
		sprite.speed_scale = 2.0
		sprite.play("damage_taken")
		motion.x = position.x * 150
		knockback_timer = knockback_duration
