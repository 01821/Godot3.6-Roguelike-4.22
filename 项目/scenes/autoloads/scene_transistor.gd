extends CanvasLayer

var new_scene:String
@onready var animation_player = %AnimationPlayer

func start_transition_to(path_to_scene:String):
	new_scene = path_to_scene
	animation_player.play("change_scene")

func change_scene():
	print(get_tree().change_scene_to_file(new_scene))
	#assert(get_tree().change_scene_to_file(new_scene) == OK)
