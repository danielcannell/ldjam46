extends KinematicBody2D

var path: PoolVector2Array
var idx := 0
var npos: Vector2
var speed := 0.0
var damage := 3.0
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
    if idx < len(path):
        var dx := (rng.randf() - 0.5) * 8.0
        var dy := (rng.randf() - 0.5) * 8.0
        npos = path[idx] + Vector2(dx, dy)


func _on_attack_monster() -> void:
    emit_signal("attack_monster", damage)


func _on_reach_monster() -> void:
    emit_signal("on_reach_monster")
    var timer := Timer.new()
    add_child(timer)
    timer.start(attack_interval)
    assert(timer.connect("timeout", self, "_on_attack_monster") == 0)


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
        # advance to next point
        position = npos
        idx += 1
        _set_npos()
        movedist -= dist_to_point
        _do_move(movedist)
    else:
        position += dir.normalized() * movedist


func _process(delta: float) -> void:
    var movedist := speed * delta
    if idx < len(path):
        _do_move(movedist)
