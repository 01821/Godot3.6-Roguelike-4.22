extends Character

const DUST_SCENE:PackedScene = preload("res://scenes/character/player/dust.tscn")

enum {UP , DOWN}
var current_weapon:Node2D
@onready var weapons = %Weapon
@onready var dust_marker_2d = $DustMarker2D
@onready var parent:Node2D = get_parent()

func _ready():
	current_weapon = weapons.get_child(0)

func _process(delta):
	var mouse_direction:Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	
	current_weapon.move(mouse_direction)
	
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
	
	if not current_weapon.is_busy():
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
			_switch_weapon(DOWN)
		elif Input.is_action_just_pressed("ui_throw") and current_weapon.get_index() != 0:
			_drop_weapon()
	
	current_weapon.get_input()

func _switch_weapon(direction:int):
	var index : int = current_weapon.get_index()
	if direction == UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()

func pick_up_weapon(weapon:Node2D):
	weapon.get_parent().call_deferred("remove_child",weapon)
	weapons.call_deferred("add_child",weapon)
	weapon.set_deferred("owner",weapons)
	current_weapon.hide()
	current_weapon.cancel_attack()
	current_weapon = weapon

func cancel_attack():
	current_weapon.cancel_attack()

func _drop_weapon():
	var weapon_to_drop:Node2D = current_weapon
	_switch_weapon(UP)
	weapons.call_deferred("remove_child",weapon_to_drop)
	get_parent().call_deferred("add_child",weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	#await weapon_to_drop.tween.tree_entered
	weapon_to_drop.show()
	
	var throw_dir:Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position,position+throw_dir*50)
	
func _spawn_dust():
	var dust:Sprite2D = DUST_SCENE.instantiate()
	dust.position = dust_marker_2d.global_position
	get_parent().add_child(dust)
	parent.move_child(dust,self.get_index())
	
func switch_camera():
	var main_scene_camera:Camera2D = get_parent().get_node("Camera2D")
	main_scene_camera.position = position
	get_node("Camera2D").set_enabled(false)
	main_scene_camera.set_enabled(true)
