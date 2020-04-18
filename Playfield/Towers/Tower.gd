extends Node2D


enum State {
    WaitingToBeBuilt,
    BeingBuilt,
    Active,
}


var state: int = State.WaitingToBeBuilt
var build_progress: float = 0.0
var sprite: Sprite
var bounding_box: Rect2


static func tile_size(kind: String):
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
    add_child(sprite)

    var image_size = tower_def["image"].get_size()

    sprite.region_enabled = true
    sprite.region_rect = Rect2(0, 0, image_size.x, 0)
    adjust_sprite()

    bounding_box = Rect2(pos, tower_def["image"].get_size())


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
            sprite.visible = true
