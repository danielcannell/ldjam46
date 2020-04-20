extends Node2D
class_name Tower


const Projectile = preload("res://Playfield/Projectile/Projectile.tscn")


export(Vector2) var tile_size := Vector2(2, 2)
export(bool) var rotate = false


enum State {
    WaitingToBeBuilt,
    BeingBuilt,
    Active,
}


signal build_complete()


onready var collision_area: Area2D = $Area2D
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var weapon = $Weapon


# Params set when built
var attack_interval: float = 5.0
var damage_type: int = Globals.DamageType.FIRE


var attack_timer: float = attack_interval
var state: int = State.WaitingToBeBuilt
var build_progress: float = 0.0


func _ready():
    var w := weapon as AnimatedSprite
    if w != null:
        var err := w.connect("animation_finished", self, "on_animation_finished"); assert(err == 0)

        if w.get_sprite_frames().has_animation("idle"):
            w.play("idle")


func on_animation_finished():
    if weapon.get_sprite_frames().has_animation("idle"):
        weapon.play("idle")
    else:
        weapon.stop()
        weapon.set_frame(0)


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

    if rotate:
        angle -= 1.57
        weapon.set_rotation(angle)
    else:
        weapon.set_flip_h(abs(angle) < 1.570796327)

    # Shoot it
    var proj := Projectile.instance()
    proj.position = weapon.position
    proj.set_damage_type(damage_type)
    add_child(proj)
    # TODO forward prediction of where enemy *will* be
    proj.look_at(target.position)

    var w = weapon as AnimatedSprite
    if w != null:
        w.set_frame(1)
        w.play("fire")

    return true


func contains_point(pos: Vector2):
    var sprite_size := animated_sprite.get_sprite_frames().get_frame("build", animated_sprite.get_frame()).get_size()
    var sprite_pos := animated_sprite.global_position
    return Rect2(sprite_pos - sprite_size / 2, sprite_size).has_point(pos)


func build_position() -> Vector2:
    # TODO: Offset this so the player is in a good position
    return position


func start_building():
    if state == State.WaitingToBeBuilt:
        state = State.BeingBuilt


func stop_building():
    if state == State.BeingBuilt:
        state = State.WaitingToBeBuilt


func _process(delta: float):
    if Engine.editor_hint:
        return

    if state == State.BeingBuilt:
        var progress = delta / Config.TOWER_BUILD_TIME_S
        build_progress = min(1, build_progress + progress)

        var frame_count := animated_sprite.get_sprite_frames().get_frame_count("build")
        var frame := int(build_progress * (frame_count - 1))
        animated_sprite.set_frame(frame)

        if build_progress >= 1.0:
            weapon.visible = true
            state = State.Active
            emit_signal("build_complete")

    elif state == State.Active:
        attack_timer += delta
        if attack_timer >= attack_interval:
            attack_timer -= 0.25 # only check 4 times per second
            if do_attack():
                attack_timer = 0.0
