extends Character

@onready var sword = %Sword
@onready var sword_animation_player = %SwordAnimationPlayer
@onready var sword_hitbox:Area2D = $Sword/Node2D/Sprite2D/Hitbox

func _process(delta):
	var mouse_direction:Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	
	sword.rotation = mouse_direction.angle()
	sword_hitbox.knockback_direction = mouse_direction
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
func get_input():
	move_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		move_direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		move_direction = Vector2.UP
	elif Input.is_action_pressed("ui_left"):
		move_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		move_direction = Vector2.RIGHT
		
	if Input.is_action_pressed("attack") and not sword_animation_player.is_playing():
		sword_animation_player.play("attack")
