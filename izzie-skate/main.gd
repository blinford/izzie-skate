extends Node3D

@onready var navigation_region := $NavigationRegion3D
@onready var skatepark = $NavigationRegion3D/skatepark
@onready var coin_spawn_timer = $CoinSpawnTimer
@onready var sun := $Sun

var coin_scene := preload("res://coin/coin.tscn")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	#sun.rotation.x -= delta * 0.1
	pass

func _on_coin_spawn_timer_timeout() -> void:
	var coin = coin_scene.instantiate()
	var spawn_point = NavigationServer3D.map_get_random_point(navigation_region.get_navigation_map(), 1, true)
	spawn_point.y += 0.5
	coin.position = spawn_point
	add_child(coin)
