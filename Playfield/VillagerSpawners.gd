tool
extends Node2D


onready var tm: TileMap = $"../TileMap"
onready var monster: Node2D = $"../Monster"


func _draw() -> void:
    if not Engine.editor_hint:
        return
    for spawn_point in get_children():
        var point: Vector2 = spawn_point.position
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



func _ready() -> void:
    set_process(Engine.editor_hint)


func _process(_delta: float) -> void:
    update()
