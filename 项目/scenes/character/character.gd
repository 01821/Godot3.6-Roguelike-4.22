extends CharacterBody2D
class_name Character

@export var FRICTION:float = 0.15
@export var accerelation:int = 40
@export var max_speed:int = 100
@export var max_hp:int = 2
@export var hp:int = 2:set = set_hp
signal hp_changed(new_hp)
var move_direction:Vector2 = Vector2.ZERO
@export var fly:bool = false
@onready var animated_sprite = %AnimatedSprite2D
@onready var state_machine:Node = get_node("FiniteStateMachine")
const HIT_EFFECT_SCENE:PackedScene = preload("res://scenes/character/player/hit_effect.tscn")

func _physics_process(delta):
	move_and_slide()
	velocity = lerp(velocity,Vector2.ZERO,FRICTION)

func move():
	move_direction = move_direction.normalized()
	velocity += move_direction * accerelation

func take_damage(dam:int,dir:Vector2,force:int):
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead :
		self.hp -= dam
		if name == "Player":
			SavedData.hp = self.hp
		_spawn_hit_effect()
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
		else:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 2

func set_hp(new_hp:int):
	hp = clamp(new_hp,0,max_hp)
	emit_signal("hp_changed",new_hp)

func _spawn_hit_effect():
	var hit_effect:Sprite2D = HIT_EFFECT_SCENE.instantiate()
	add_child(hit_effect)
