extends Area2D

@onready var collision_shape_2d:CollisionShape2D = $CollisionShape2D

func _on_body_entered(body):
	collision_shape_2d.set_deferred("disabled",true)
	SceneTransistor.start_transition_to("res://scenes/game/game.tscn")
