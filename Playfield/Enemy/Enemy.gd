extends KinematicBody2D

var path: PoolVector2Array
var idx := 0

const speed := 60

onready var tm: TileMap = $"../Map/TileMap"
onready var monster: Node2D = $"../Map/Monster"

func _ready() -> void:
    var start_pos := position
    var end_pos := monster.position
    path = tm.get_astar_path(start_pos, end_pos)
    assert(len(path) > 0, "Enemy has no path")


func _do_move(movedist: float) -> void:
    if idx >= len(path):
        get_parent().remove_child(self)
        queue_free()
        return

    var cpos := path[idx]
    var dir := cpos - position
    var dist_to_point := dir.length()

    if movedist > dist_to_point:
        # advance to next point
        position = cpos
        idx += 1
        movedist -= dist_to_point
        _do_move(movedist)
    else:
        position += dir.normalized() * movedist


func _process(delta: float) -> void:
    var movedist := speed * delta
    _do_move(movedist)
