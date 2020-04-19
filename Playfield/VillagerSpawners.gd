tool
extends Node2D

class_name VillagerSpawners


const Enemy = preload("res://Playfield/Enemy/Enemy.tscn")


# Interval between spawns in seconds
export var spawn_interval := 1.0
export var monster_radius := 48.0


onready var tm: TileMap = $"../TileMap"
onready var ysort: YSort = $"../YSort"
onready var monster: Node2D = $"../YSort/Monster"
onready var rng := RandomNumberGenerator.new()


var spawn_points: PoolVector2Array
var spawn_paths: Array


func _find_spawn_points() -> void:
    spawn_points.resize(0)
    spawn_paths.resize(0)
    var mpos := monster.position
    for child in get_children():
        # TODO adjust path backwards so enemies spawn off the edge of the map
        var spos: Vector2 = tm.get_closest_point_on_path(child.position)
        spawn_points.append(spos)

        # path from spawn point to center of monster
        var path: PoolVector2Array = tm.get_astar_path(spos, mpos)

        # adjust the path so the end is a small distance away from the monster
        var adjust_len: float = monster_radius
        var end = len(path) - 1
        while adjust_len > 0.0 and end > 0:
            var segment := path[end] - path[end-1]
            var seg_len := segment.length()
            if seg_len <= adjust_len:
                adjust_len -= seg_len
                path.remove(end)
            else:
                var old := Vector2(path[end].x, path[end].y)
                path.set(end, old - (segment.normalized() * adjust_len))
                adjust_len = 0
            end -= 1
        spawn_paths.append(path)


func _draw() -> void:
    if not Engine.editor_hint:
        return
    for spawn_idx in range(len(spawn_points)):
        var point: Vector2 = spawn_points[spawn_idx]
        var path: PoolVector2Array = spawn_paths[spawn_idx]
        if len(path) == 0:
            draw_circle(point, 8, Color.red)
        else:
            draw_circle(point, 8, Color.green)
            var idx := 0
            while idx < len(path)-1:
                var p1 := path[idx]
                var p2 := path[idx+1]
                draw_circle(p2, 3.0, Color.green)
                draw_line(p1, p2, Color.green, 2.0)
                idx += 1


func on_enemy_reached_monster() -> void:
    print("An enemy reached the monster!")


func _on_spawn_timer() -> void:
    if len(spawn_points) < 1:
        return
    var idx := rng.randi_range(0, len(spawn_points) - 1)
    var point := spawn_points[idx]

    var enemy := Enemy.instance()
    var ep = tm.get_closest_point_on_path(point)
    enemy.path = spawn_paths[idx]
    enemy.position = ep
    add_child(enemy)
    assert(enemy.connect("attack_monster", monster, "on_attacked") == 0)
    assert(enemy.connect("on_reach_monster", self, "on_enemy_reached_monster") == 0)


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
