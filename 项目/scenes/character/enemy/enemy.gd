extends Character
class_name Enemy

var path:PackedVector2Array

@onready var navigation_agent_2d:NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var player_node:CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var path_timer = $Navigation/PathTimer


func chase():
	if navigation_agent_2d.is_navigation_finished():
		return
		
	var direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	move_direction = direction

	if move_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif move_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true

func _on_path_timer_timeout():
	if is_instance_valid(player_node):
		navigation_agent_2d.target_position = player_node.global_position
	else:
		path_timer.stop()
		move_direction = Vector2.ZERO
		navigation_agent_2d.target_position = global_position
