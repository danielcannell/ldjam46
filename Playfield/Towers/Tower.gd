extends Node2D


const progress_bar_texture = preload("res://Art/progress_bar.png");
const progress_bar_under_texture = preload("res://Art/progress_bar_under.png")


enum State {
    WaitingToBeBuilt,
    BeingBuilt,
    Active,
}


var state: int = State.WaitingToBeBuilt


static func tile_size(kind: String):
    var image = Globals.TOWERS["large"]["image"];
    var width = image.get_size().x / 16

    # For now, towers will be as wide as they are tall
    return Vector2(width, width)


func _init(kind: String, pos: Vector2):
    position = pos
    
    var tower_def = Globals.TOWERS[kind]

    # Create the sprite
    var sprite = Sprite.new()
    sprite.texture = tower_def["image"]
    add_child(sprite)
    
    # Translate the sprite so it lines up where we are expecting it to
    var image_size = tower_def["image"].get_size()
    sprite.position += Vector2(image_size.x / 2, image_size.x - image_size.y / 2)
    
    # Create the progress bar
    var progress_bar = TextureProgress.new()
    progress_bar.texture_under = progress_bar_under_texture
    progress_bar.texture_under = progress_bar_texture
    add_child(progress_bar)
