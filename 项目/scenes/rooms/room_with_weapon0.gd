extends Room

const WEAPONS:Array = [preload("res://scenes/weapons/Sword/sword.tscn"),
preload("res://scenes/weapons/WarHammer/war_hammer.tscn")]

@onready var weapon_pos:Marker2D = %WeaponPos

func _ready():
	var weapon:Node2D = WEAPONS[randi() % WEAPONS.size()].instantiate()
	weapon.position = weapon_pos.position
	weapon.on_floor = true
	add_child(weapon)
