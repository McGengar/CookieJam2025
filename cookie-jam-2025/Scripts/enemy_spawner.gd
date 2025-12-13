extends Area2D

@export var enemy_to_spawn: PackedScene

@export var one_time_use: bool = true

@onready var spawn_point: Marker2D = $Spawnpoint

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		spawn_enemy()

func spawn_enemy() -> void:
	if enemy_to_spawn == null:
		push_error("Zapomniałeś przypisać przeciwnika w Inspektorze!")
		return

	var enemy_instance = enemy_to_spawn.instantiate()
	
	enemy_instance.global_position = spawn_point.global_position
	get_parent().call_deferred("add_child", enemy_instance)
	
	print("Zespawnowano: ", enemy_instance.name)
	
	if one_time_use:
		queue_free()
