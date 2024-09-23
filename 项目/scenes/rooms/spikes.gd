extends Hitbox

@onready var animation_player:AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	animation_player.play("pierce")

func _collide(body:PhysicsBody2D):
	if not body.fly:
		knockback_direction = (body.global_position - global_position).normalized()
		body.take_damage(damage,knockback_direction,knockback_force)
