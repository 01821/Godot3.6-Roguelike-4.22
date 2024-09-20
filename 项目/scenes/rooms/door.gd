extends StaticBody2D

@onready var animation_player:AnimationPlayer = $AnimationPlayer

func open():
	animation_player.play("open")
