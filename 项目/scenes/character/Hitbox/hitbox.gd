extends Area2D
class_name Hitbox

@export var damage:int = 1
var knockback_direction:Vector2 = Vector2.ZERO
@export var knockback_force:int = 800

@onready var collision_shape:CollisionShape2D = get_child(0)

func _init():
	connect("body_entered",_on_body_entered)
	
func _ready():
	assert(collision_shape != null)

func _on_body_entered(body:PhysicsBody2D):
	body.take_damage(damage,knockback_direction,knockback_force)
