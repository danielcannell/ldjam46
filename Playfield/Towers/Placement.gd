extends Node2D

var tilemap: TileMap

var size = null
var pos = null
var color: Color = Color(0, 1, 0, 1)


func _ready():
    tilemap = $"../Map/TileMap"


func _draw():
    if size != null and pos != null:
        draw_rect(Rect2(pos, size), color, false)


func begin(tile_size: Vector2):
    # TODO: There must be a better way
    var tile_shape = tilemap.map_to_world(Vector2(1, 1)) - tilemap.map_to_world(Vector2(0, 0))
    size = Vector2(tile_size.x * tile_shape.x, tile_size.y * tile_shape.y)
    
    update()


func end():
    size = null
    pos = null
    update()


func set_pos(world_pos: Vector2):
    # Quantise the position
    self.pos = tilemap.map_to_world(tilemap.world_to_map(world_pos))
    update()
