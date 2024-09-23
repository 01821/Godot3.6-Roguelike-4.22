extends Enemy

const MAX_DISTANCE_TO_PLAYER:int = 80
const MIN_DISTANCE_TO_PLAYER:int = 40

var distance_to_player:float
const THROWABLE_KNIKE_SCENE = preload("res://scenes/character/enemy/Goblin/throwable_knike.tscn")
@export var projectile_speed:int = 150
var can_attack:bool = true

@onready var attack_timer:Timer = $AttackTimer

func _on_path_timer_timeout():
	if is_instance_valid(player_node):
		distance_to_player = (player_node.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			navigation_agent_2d.target_position = player_node.global_position
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			if can_attack and state_machine.state == state_machine.states.idle:
				can_attack = false
				_throw_knife()
				attack_timer.start()
	else:
		path_timer.stop()
		move_direction = Vector2.ZERO
		navigation_agent_2d.target_position = global_position

func _get_path_to_move_away_from_player():
	var dir:Vector2 = (global_position - player_node.position).normalized()
	navigation_agent_2d.target_position = global_position + dir  * 100
	
func _throw_knife():
	var projectile:Area2D = THROWABLE_KNIKE_SCENE.instantiate()
	projectile.launch(global_position,(player_node.position - global_position).normalized(),projectile_speed)
	get_tree().current_scene.add_child(projectile)
	
func _on_attack_timer_timeout():
	can_attack = true
