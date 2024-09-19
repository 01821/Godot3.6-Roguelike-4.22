extends CanvasLayer

const MIN_HEALTH:int = 23
var max_hp:int = 4

@onready var player:CharacterBody2D = get_parent().get_node("Player")
@onready var texture_progress_bar:TextureProgressBar = $TextureProgressBar

func _ready():
	max_hp = player.hp
	_update_health_bar(100)

func _update_health_bar(new_value:int):
	var health_bar_tween = create_tween()
	health_bar_tween.tween_property(texture_progress_bar,"value",new_value,0.5)
	
func _on_player_hp_changed(new_hp:int):
	var new_health:int = int((100 - MIN_HEALTH) * float(new_hp) / max_hp) + MIN_HEALTH
	_update_health_bar(new_health)
