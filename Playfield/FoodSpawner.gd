extends Node2D

var Food = preload("res://Playfield/Food/Food.tscn")

const min_spawn_interval := 20.0
const max_spawn_interval := 60.0
const food_tile_rect := Vector2(1, 1)

onready var timer := Timer.new()
onready var spawn_interval := 10
onready var tilemap := get_parent().get_node("TileMap")


func _ready():
    add_child(timer)
    var _err = timer.connect("timeout", self, "_on_spawn_timer")
    timer.start(spawn_interval)


func _on_spawn_timer():
    do_spawn()
    spawn_interval = next_spawn_interval()
    timer.start(spawn_interval)


func do_spawn():
    var monster_pos = $"../YSort/Monster".global_position
    var food_pos = monster_pos + Vector2(rand_range(-200, 200), rand_range(-200, 200))

    Globals.tutorial_event(Globals.TutorialEvents.FOOD_SPAWNED)
    var food = Food.instance()
    food.position = food_pos
    add_child(food)


func next_spawn_interval():
    return int(rand_range(min_spawn_interval, max_spawn_interval))
