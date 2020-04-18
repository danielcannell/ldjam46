tool
extends Node2D


const Enemy = preload("res://Playfield/Enemy/Enemy.tscn")


# Interval between spawns in seconds
export var spawn_interval := 1.0


onready var tm: TileMap = $"../TileMap"
onready var monster: Node2D = $"../Monster"
onready var rng := RandomNumberGenerator.new()


var spawn_points: PoolVector2Array
var spawn_paths: Array


func _find_spawn_points() -> void:
    spawn_points.resize(0)
    spawn_paths.resize(0)
    var mpos := monster.position
    for child in get_children():
        var spos: Vector2 = tm.get_closest_point_on_path(child.position)
        spawn_points.append(spos)
        var path: PoolVector2Array = tm.get_astar_path(spos, mpos)
        spawn_paths.append(path)


func _draw() -> void:
    if not Engine.editor_hint:
        return
    for point in spawn_points:
        # get path to monster
        var ep = tm.get_closest_point_on_path(point)
        var mp = monster.position
        var path: PoolVector2Array = tm.get_astar_path(ep, mp)

        if len(path) == 0:
            draw_circle(point, 8, Color.red)
        else:
            draw_circle(point, 8, Color.green)
            var idx := 0
            while idx < len(path)-1:
                var p1 := path[idx]
                var p2 := path[idx+1]
                var diff := p2 - p1
                p1 += diff * 0.1
                p2 -= diff * 0.1
                draw_line(p1, p2, Color.green, 3.0)
                idx += 1


func _on_spawn_timer() -> void:
    if len(spawn_points) < 1:
        return
    var idx := rng.randi_range(0, len(spawn_points) - 1)
    var point := spawn_points[idx]

    var enemy = Enemy.instance()
    var ep = tm.get_closest_point_on_path(point)
    enemy.path = spawn_paths[idx]
    enemy.position = ep
    add_child(enemy)


func _ready() -> void:
    _find_spawn_points()
    if not Engine.editor_hint:
        var timer := Timer.new()
        add_child(timer)
        var _err = timer.connect("timeout", self, "_on_spawn_timer")
        timer.start(spawn_interval)


func _process(_delta: float) -> void:
    if Engine.editor_hint:
        _find_spawn_points()
        update()
