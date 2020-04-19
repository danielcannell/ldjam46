extends KinematicBody2D

class_name Enemy

var path: PoolVector2Array # Path - cached
var path_len := 0.0 # Total length of path - cached

var idx := 0 # Next path index
var npos: Vector2 # Next vector pos
var speed := 0.0 # Will be randomised from base_speed and speed_var
var distance_moved := 0.0 # Total distance travelled along path
var _t_distance := 0.0 # Distance moved within path segment
var _curr_seg_len := 0.0 # Length of current path segment
var damage := 3.0 # Damage dealt per attack - TODO config
onready var rng := RandomNumberGenerator.new()

# args: ()
signal on_reach_monster
# args: (damage: float)
signal attack_monster

const base_speed := 60.0
const speed_var := 10.0
const attack_interval := 1.0


func _ready() -> void:
    rng.randomize()
    assert(len(path) > 0, "Enemy has no path")
    speed = rng.randf_range(base_speed - speed_var, base_speed + speed_var)
    _set_npos()


func _set_npos() -> void:
    _curr_seg_len = 0.0
    if idx < len(path):
        var dx := (rng.randf() - 0.5) * 8.0
        var dy := (rng.randf() - 0.5) * 8.0
        npos = path[idx] + Vector2(dx, dy)

        if idx > 0:
            _curr_seg_len = (path[idx-1] - path[idx]).length()


func _on_attack_monster() -> void:
    emit_signal("attack_monster", damage)


func _on_reach_monster() -> void:
    emit_signal("on_reach_monster")
    var timer := Timer.new()
    add_child(timer)
    timer.start(attack_interval)
    assert(timer.connect("timeout", self, "_on_attack_monster") == 0)


# Return total progress along path to monster, from 0.0 to 1.0
func get_progress() -> float:
    return (distance_moved + _t_distance) / path_len


func die() -> void:
    get_parent().remove_child(self)
    queue_free()


func _do_move(movedist: float) -> void:
    if idx >= len(path):
        _on_reach_monster()
        return

    var dir := npos - position
    var dist_to_point := dir.length()

    if movedist > dist_to_point:
        # Keep track of total distance moved
        distance_moved += _curr_seg_len
        _t_distance = 0.0

        # advance to next point
        position = npos
        idx += 1
        _set_npos()
        movedist -= dist_to_point
        _do_move(movedist)
    else:
        position += dir.normalized() * movedist
        _t_distance += movedist


func _process(delta: float) -> void:
    var movedist := speed * delta
    if idx < len(path):
        _do_move(movedist)
