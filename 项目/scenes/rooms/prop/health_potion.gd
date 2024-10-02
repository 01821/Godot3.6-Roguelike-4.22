extends Area2D

var tween:Tween
var duration := 0.6
@onready var collision_shape:CollisionShape2D = $CollisionShape2D

func _on_body_entered(player:CharacterBody2D):
	collision_shape.set_deferred("disabled",true)
	player.hp += 1
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self,"modulate",Color(1,1,1,0),duration)
	tween.tween_property(self,"position",position + Vector2.UP*16,duration)
	tween.tween_callback(queue_free)
	
