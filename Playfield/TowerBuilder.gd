extends Node2D


signal build(world_position, target)


const Tower = preload("res://Playfield/Towers/Tower.gd")


enum State {
    Idle,
    Placing,
}


onready var tile_map: TileMap = $"../Map/TileMap"

var state: int = State.Idle
var size: Vector2
var pos: Vector2
var can_place: bool = false
var build_tower_kind: String


func building(tower):
    tower.start_building()


func _unhandled_input(event: InputEvent):
    if state == State.Placing:
        if event is InputEventMouseMotion:
            set_pos(quantise_to_grid(get_global_mouse_position()))
            can_place = check_pos_is_buildable(get_global_mouse_position())

        if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
            if can_place:
                state = State.Idle
                end()

                var tower = Tower.new(build_tower_kind, quantise_to_grid(get_global_mouse_position()))
                add_child(tower)
                
                emit_signal("build", tower.build_position(), tower)


func check_pos_is_buildable(pos: Vector2):
    var top_left_pos = tile_map_pos(pos)
    var size = Tower.tile_size(build_tower_kind)
    
    for x in range(top_left_pos.x, top_left_pos.x + size.x):
        for y in range(top_left_pos.y, top_left_pos.y + size.y):
            if not tile_map.is_tile_placeable(x, y):
                return false
    
    return true


func _draw():
    if state == State.Placing:
        var color = Color(0, 1, 0, 1) if can_place else Color(1, 0, 0, 1)
        draw_rect(Rect2(pos, size), color, false)


func tile_map_pos(x: Vector2) -> Vector2:
    return tile_map.world_to_map(x - size/2 + tile_map.cell_size/2)


func quantise_to_grid(x) -> Vector2:
    return tile_map.map_to_world(tile_map_pos(x))


func on_build_requested(kind: String):
    build_tower_kind = kind
    state = State.Placing
    size = Tower.tile_size(kind) * tile_map.cell_size
    update()


func end():
    update()


func set_pos(pos_: Vector2):
    # Quantise the position
    self.pos = pos_
    update()
