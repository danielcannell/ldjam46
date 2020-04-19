extends Area2D

class_name Enemy

const max_health := 100.0 # TODO config
const damage := 3.0 # Damage dealt per attack - TODO config
const base_speed := 60.0 # TODO config
const speed_var := 20.0 # TODO config
const attack_interval := 1.0 # TODO config
const burn_interval := 0.25 # TODO config
const burn_damage := 10.0 # TODO config
const animations := ["axe", "fire"]

var path: PoolVector2Array # Path - cached
var path_len := 0.0 # Total length of path - cached

var idx := 0 # Next path index
var npos: Vector2 # Next vector pos
var speed := 0.0 # Will be randomised from base_speed and speed_var
var distance_moved := 0.0 # Total distance travelled along path
var _t_distance := 0.0 # Distance moved within path segment
var _curr_seg_len := 0.0 # Length of current path segment
var dead := false # Is enemy dead?
var health := max_health # Health remaining

var onfire_time := 0.0 # Time enemy has left on fire
var burn_tick := burn_interval
var speed_mult := 1.0 # Speed multiplier
var slow_time := 0.0 # Time enemy is slowed for

onready var rng := RandomNumberGenerator.new()
onready var health_bar = $HealthBar

# args: ()
signal on_reach_monster
# args: (damage: float)
signal attack_monster


func _ready() -> void:
    rng.randomize()
    
    $AnimatedSprite.play(animations[randi() % len(animations)])
    
    assert(len(path) > 0, "Enemy has no path")
    speed = rng.randf_range(base_speed - speed_var, base_speed + speed_var)
    _set_npos()
    health_bar.max_value = max_health
    health_bar.value = health


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
    $AnimatedSprite.stop()

    emit_signal("on_reach_monster")
    var timer := Timer.new()
    add_child(timer)
    timer.start(attack_interval)
    var err := timer.connect("timeout", self, "_on_attack_monster"); assert(err == 0)


# Return total progress along path to monster, from 0.0 to 1.0
func get_progress() -> float:
    return (distance_moved + _t_distance) / path_len


func hurt(damage: float) -> void:
    health -= damage
    health_bar.value = health
    if health <= 0:
        dead = true


# Set enemy on fire for (time) seconds
func set_on_fire(time: float) -> void:
    onfire_time = time


# Slow an enemy for (time) seconds to (mult) * base speed
func apply_slowness(mult: float, time: float) -> void:
    slow_time = time
    speed_mult = mult


func die() -> void:
    get_parent().remove_child(self)
    queue_free()


func _do_move(movedist: float) -> void:
    if idx >= len(path):
        _on_reach_monster()
        return

    var dir := npos - position
    var dist_to_point := dir.length()

    $AnimatedSprite.set_flip_h(abs(dir.angle()) > 1.57)

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


func _draw() -> void:
    if onfire_time > 0:
        # TODO fire animation?
        draw_circle(Vector2(-5,-10), 5, Color.orange)

    if slow_time > 0:
        # TODO slowness animation?
        draw_circle(Vector2(5,-10), 5, Color.black)


func _process(delta: float) -> void:
    if dead:
        die()
    else:
        var movedist := speed * speed_mult * delta
        if idx < len(path):
            _do_move(movedist)

        if onfire_time > 0:
            onfire_time -= delta
            burn_tick -= delta
            if burn_tick <= 0:
                hurt(burn_damage)
                burn_tick = burn_interval
        else:
            burn_tick = burn_interval

        if slow_time > 0:
            slow_time -= delta
        else:
            speed_mult = 1.0

        update()
