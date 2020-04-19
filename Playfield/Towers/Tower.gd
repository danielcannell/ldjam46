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
onready var weapon: Sprite = $Weapon


var attack_timer: float = ATTACK_INTERVAL
var state: int = State.WaitingToBeBuilt
var build_progress: float = 0.0
var bounding_box: Rect2
var damage_type: int = Globals.DamageType.FIRE


func init(_kind: String, pos: Vector2):
    # TODO set damage_type?
    position = pos
    bounding_box = Rect2(pos, 16 * tile_size)


func _sort_enemies(a: Enemy, b: Enemy) -> bool:
    var aprog := a.get_progress()
    var bprog := b.get_progress()

    if damage_type == Globals.DamageType.FIRE:
        var afire := a.onfire_time
        var bfire := b.onfire_time
        # Prioritise enemies which have less fire-time remaining
        if afire != bfire:
            # if a is more 'on-fire' than b, b should come second
            return afire < bfire

    elif damage_type == Globals.DamageType.SLOWNESS:
        var aspeedmult: float = a.speed_mult
        var bspeedmult: float = b.speed_mult
        # Prioritise enemies which are not slowed
        if aspeedmult != bspeedmult:
            return aspeedmult > bspeedmult

        var aslowtime: float = a.slow_time
        var bslowtime: float = b.slow_time
        # Prioritise enemies which will soon speed up
        if aslowtime != bslowtime:
            return aslowtime < bslowtime

    # Prioritise enemies at the front
    return aprog > bprog


# Perform an attack if there's something in range. Return true if we succeeded.
func do_attack() -> bool:
    # find an enemy in range
    var targets := collision_area.get_overlapping_areas()
    if len(targets) == 0:
        return false
    targets.sort_custom(self, "_sort_enemies")
    var target: Enemy = targets[0]

    # Point at it
    var angle = weapon.global_position.angle_to_point(target.global_position)
    weapon.set_rotation(angle)

    # Shoot it
    var proj := Projectile.instance()
    proj.position = weapon.position
    proj.damage_type = damage_type
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
        build_progress = min(1, build_progress + 10.1 * delta)  # TODO: Configurable rate

        var frame_count := animated_sprite.get_sprite_frames().get_frame_count("build")
        var frame := int(build_progress * (frame_count - 1))
        animated_sprite.set_frame(frame)

        if build_progress >= 1.0:
            weapon.visible = true
            state = State.Active
            emit_signal("build_complete")

    elif state == State.Active:
        attack_timer += delta
        if attack_timer >= ATTACK_INTERVAL:
            attack_timer -= 0.25 # only check 4 times per second
            if do_attack():
                attack_timer = 0.0
