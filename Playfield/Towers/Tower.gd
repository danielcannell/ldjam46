extends Node2D
class_name Tower


const Projectile = preload("res://Playfield/Projectile/Projectile.tscn")


export(Vector2) var tile_size := Vector2(2, 2)


enum State {
    WaitingToBeBuilt,
    BeingBuilt,
    Active,
}


signal build_complete()


const ATTACK_INTERVAL: float = 1.0


onready var collision_area: Area2D = $Area2D
onready var animated_sprite: AnimatedSprite = $AnimatedSprite


var attack_timer: float = ATTACK_INTERVAL
var state: int = State.WaitingToBeBuilt
var build_progress: float = 0.0
var bounding_box: Rect2


func init(kind: String, pos: Vector2):
    position = pos
    bounding_box = Rect2(pos, 16 * tile_size)


func get_most_progressed_enemy(enemies: Array) -> Node2D:
    var result: Node2D = null
    var best := 0.0
    for enemy in enemies:
        var prog: float = enemy.get_progress()
        if prog > best:
            result = enemy
            best = prog

    return result


# Perform an attack if there's something in range. Return true if we succeeded.
func do_attack() -> bool:
    # find an enemy in range
    var targets := collision_area.get_overlapping_areas()
    var target := get_most_progressed_enemy(targets)
    if target == null:
        return false

    # Shoot it
    var proj := Projectile.instance()
    add_child(proj)
    # TODO forward prediction of where enemy *will* be
    proj.look_at(target.position)
    return true


func contains_point(pos: Vector2):
    return bounding_box.has_point(pos)


func build_position() -> Vector2:
    # TODO: Offset this so the player is in a good position
    return position


func start_building():
    if state == State.WaitingToBeBuilt:
        state = State.BeingBuilt


func stop_building():
    if state == State.BeingBuilt:
        state = State.WaitingToBeBuilt


func _process(delta):
    if Engine.editor_hint:
        return

    if state == State.BeingBuilt:
        build_progress = min(1, build_progress + 0.1 * delta)  # TODO: Configurable rate
        
        var frame_count := animated_sprite.get_sprite_frames().get_frame_count("build")
        var frame := floor(build_progress * (frame_count - 1))
        animated_sprite.set_frame(frame)

        if build_progress >= 1.0:
            state = State.Active
            emit_signal("build_complete")

    elif state == State.Active:
        attack_timer += delta
        if attack_timer >= ATTACK_INTERVAL:
            attack_timer -= 0.25 # only check 4 times per second
            if do_attack():
                attack_timer = 0.0
