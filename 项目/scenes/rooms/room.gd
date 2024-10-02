extends Node2D

const SPAWN_EXPLOSION_SCENE = preload("res://scenes/character/enemy/spawn_explosion.tscn")

const ENEMY_SCENES:Dictionary = {
	"FLYING_CREATURE":
		preload("res://scenes/character/enemy/FlyingCreature/flying_creature.tscn" ),
	"GOBLIN":
		preload("res://scenes/character/enemy/Goblin/goblin.tscn" )
}

var num_enemies:int

@onready var tile_map:TileMap = $TileMap
@onready var tile_map_2 = $TileMap2
@onready var entrance:Node2D = $Entrance
@onready var doors:Node2D = $Doors
@onready var enemy_positions:Node2D = $EnemyPositions
@onready var player_detector:Area2D = $PlayerDetector

func _ready():
	num_enemies = enemy_positions.get_child_count()
	
func _open_doors():
	for door in doors.get_children():
		door.open()

func _close_entrance():
	for entry_position in entrance.get_children():
		tile_map_2.set_cell(0,tile_map.local_to_map(entry_position.position),0,Vector2(2,6))
		
func _spwan_enemies():
	for enemy_position in enemy_positions.get_children():
		var enemy:CharacterBody2D
		if randi() % 2 == 0:
			enemy = ENEMY_SCENES.FLYING_CREATURE.instantiate()
		else:
			enemy = ENEMY_SCENES.GOBLIN.instantiate()
			
		enemy.connect("tree_exited",_on_enemy_killed)
		enemy.global_position = enemy_position.position
		call_deferred("add_child",enemy)
		var spawn_explosion:AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.global_position = enemy_position.global_position
		call_deferred("add_child",spawn_explosion)

func _on_enemy_killed():
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()

func _on_player_detector_body_entered(body:CharacterBody2D):
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spwan_enemies()
	else:
		_close_entrance()
		_open_doors()
