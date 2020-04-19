extends Node2D
class_name Tower


enum State {
    WaitingToBeBuilt,
    BeingBuilt,
    Active,
}


signal build_complete()


const ATTACK_INTERVAL: float = 1.0
const ATTACK_RANGE: float = 64.0


onready var playfield = Globals.playfield


var attack_timer: float = ATTACK_INTERVAL
var state: int = State.WaitingToBeBuilt
var build_progress: float = 0.0
var sprite: Sprite
var bounding_box: Rect2


static func tile_size(kind: String) -> Vector2:
    var image = Globals.TOWERS[kind]["image"];
    var width = image.get_size().x / 16

    # For now, towers will be as wide as they are tall
    return Vector2(width, width)


func _init(kind: String, pos: Vector2):
    position = pos

    var tower_def = Globals.TOWERS[kind]

    # Create the sprite
    sprite = Sprite.new()
    sprite.texture = tower_def["image"]
    sprite.region_enabled = true
    adjust_sprite()
    add_child(sprite)

    # Create the collision area
    var area = Area2D.new()
    var collision_shape = CollisionShape2D.new()
    var shape = CircleShape2D.new()
    shape.radius = tower_def["range"]
    collision_shape.set_shape(shape)
    area.add_child(collision_shape)
    add_child(area)

    bounding_box = Rect2(pos, tower_def["image"].get_size())


func _ready() -> void:
    assert(playfield != null)


# Perform an attack if there's something in range. Return true if we succeeded.
func do_attack() -> bool:
    # TODO find a monster in range
    var targets: Array = playfield.get_enemies_near(position, ATTACK_RANGE)
    # TODO shoot it
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


func adjust_sprite():
    var p = (0.2 + build_progress) / 1.2
    var width = sprite.texture.get_width()
    var full_height = sprite.texture.get_height()
    var current_height = int(full_height * p)

    sprite.region_rect = Rect2(0, full_height - current_height, width, current_height)
    sprite.position = Vector2(width / 2, width - current_height / 2)


func _process(delta):
    if state == State.BeingBuilt:
        build_progress += 0.1 * delta  # TODO: Configurable rate
        adjust_sprite()

        if build_progress >= 1.0:
            state = State.Active
            emit_signal("build_complete")

    elif state == State.Active:
        attack_timer += delta
        if attack_timer >= ATTACK_INTERVAL:
            attack_timer -= 0.25 # only check 4 times per second
            if do_attack():
                attack_timer = 0.0
