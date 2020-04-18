extends Node2D

const TowerImage = preload("res://Art/BasicTower.png")


static func tile_size():
    var width = TowerImage.get_size().x / 16
    
    # For now, towers will be as wide as they are tall
    return Vector2(width, width)


func _init(pos: Vector2):
    position = pos

    # Create the sprite
    var sprite = Sprite.new()
    sprite.texture = TowerImage
    
    # Translate the sprite so it lines up where we are expecting it to
    var x_offset = TowerImage.get_size().x / 2
    var y_offset = TowerImage.get_size().x - TowerImage.get_size().y / 2
    sprite.position += Vector2(x_offset, y_offset)
    
    add_child(sprite)
