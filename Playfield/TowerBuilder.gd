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
var color: Color = Color(0, 1, 0, 1)
var build_tower_kind: String


func building(tower):
    tower.start_building()


func _input(event: InputEvent):
    if state == State.Placing:
        if event is InputEventMouseMotion:
            set_pos(quantise_to_grid(get_global_mouse_position()))

        if event is InputEventMouseButton and event.is_pressed()  and event.button_index == BUTTON_LEFT:
            state = State.Idle
            end()
            
            var tower = Tower.new(build_tower_kind, quantise_to_grid(get_global_mouse_position()))
            add_child(tower)
            
            emit_signal("build", tower.build_position(), tower)


func _draw():
    if state == State.Placing:
        draw_rect(Rect2(pos, size), color, false)


func quantise_to_grid(x):
    return tile_map.map_to_world(tile_map.world_to_map(x - size/2 + tile_map.cell_size/2))


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
