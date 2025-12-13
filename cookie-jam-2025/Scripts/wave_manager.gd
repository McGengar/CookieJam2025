extends Node

signal wave_started(wave_number)
signal wave_finished
signal level_cleared

@export_group("Konfiguracja")
@export var possible_enemies: Array[PackedScene] 

@export var spawn_points_container: Node2D
@export var initial_wait_time: float = 2.0
@export var time_between_waves: float = 3.0

# Ustalamy tylko ogólną ilość wrogów
@export var enemies_in_first_wave: int = 5
@export var max_waves: int = 5

var current_wave: int = 0
var enemies_alive: int = 0

func _ready():
	await get_tree().create_timer(initial_wait_time).timeout
	start_next_wave()

func start_next_wave():
	current_wave += 1
	emit_signal("wave_started", current_wave)
	
	var total_enemies_count = enemies_in_first_wave + (current_wave - 1) * 2 
	
	print("Start fali nr: ", current_wave, "/", max_waves, " | Do pokonania: ", total_enemies_count)
	
	var spawn_queue: Array[PackedScene] = []
	
	if possible_enemies.is_empty():
		push_error("WaveManager: Lista 'Possible Enemies' jest pusta!")
		return

	for i in range(total_enemies_count):
		var random_enemy = possible_enemies.pick_random()
		spawn_queue.append(random_enemy)
	
	_spawn_enemies_from_queue(spawn_queue)

func _spawn_enemies_from_queue(queue: Array[PackedScene]):
	if spawn_points_container == null:
		push_error("WaveManager: Brak kontenera punktów!")
		return
		
	var points = spawn_points_container.get_children()
	enemies_alive = queue.size()
	
	for scene_to_spawn in queue:
		var enemy = scene_to_spawn.instantiate()
		var random_point = points.pick_random()
		
		enemy.global_position = random_point.global_position
		enemy.tree_exited.connect(_on_enemy_killed)
		
		get_parent().call_deferred("add_child", enemy)
		
		await get_tree().create_timer(randf_range(0.8, 1.5)).timeout

func _on_enemy_killed():
	enemies_alive -= 1
	
	if enemies_alive == 0:
		_on_wave_cleared()

func _on_wave_cleared():
	emit_signal("wave_finished")
	print("Fala ", current_wave, " wyczyszczona!")
	
	if current_wave >= max_waves:
		print("GRATULACJE! Wszystkie fale pokonane.")
		emit_signal("level_cleared")
		return

	print("Następna fala za ", time_between_waves, "s...")
	await get_tree().create_timer(time_between_waves).timeout
	start_next_wave()
