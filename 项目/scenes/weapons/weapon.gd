extends Node2D
class_name Weapon

@onready var hitbox:Area2D = %Hitbox
@onready var charge_particles:GPUParticles2D = %ChargeParticles
@onready var animation_player:AnimationPlayer = %AnimationPlayer
@onready var player_detector = $Node2D/PlayerDetector

@export var on_floor:bool = false

func _ready():
	if not on_floor:
		player_detector.set_collision_mask_value(1,false)
		player_detector.set_collision_mask_value(2,false)
	

func get_input():
	if Input.is_action_pressed("attack") and not animation_player.is_playing():
		animation_player.play("charge")
	elif Input.is_action_just_released("attack"):
		if animation_player.is_playing() and animation_player.current_animation == "charge" and not charge_particles.emitting:
			animation_player.play("attack")
		elif charge_particles.emitting:
			animation_player.play("circular_attack")
			
func move(mouse_direction:Vector2):
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		rotation = mouse_direction.angle()
		hitbox.knockback_direction = mouse_direction
		if scale.y == 1 and mouse_direction.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0:
			scale.y = 1

func cancel_attack():
	animation_player.play("cancel_attack")

func is_busy() -> bool:
	if animation_player.is_playing() or charge_particles.emitting:
		return true
	return false
	
func interpolate_pos(initial_pos:Vector2,final_pos:Vector2):
	var tween:Tween = create_tween()
	var __ = tween.tween_property(self,"position",final_pos,0.8).as_relative().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	assert(__)
	player_detector.set_collision_mask_value(1,true)
	await __.finished
	player_detector.set_collision_mask_value(2,true)
	
	
func _on_player_detector_body_entered(body:PhysicsBody2D):
	if body != null:
		player_detector.set_collision_mask_value(1,false)
		player_detector.set_collision_mask_value(2,false)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		#tween.stop()
		player_detector.set_collision_mask_value(1,true)
