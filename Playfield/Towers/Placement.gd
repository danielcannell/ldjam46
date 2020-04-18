extends Node2D


const BasicTower = preload("res://Playfield/Towers/BasicTower.gd")
const LargeTower = preload("res://Playfield/Towers/LargeTower.gd")


enum State {
    Idle,
    Placing,
}


onready var tile_map: TileMap = $"../Map/TileMap"

var state: int = State.Idle
var size: Vector2
var pos: Vector2
var color: Color = Color(0, 1, 0, 1)


func _input(event: InputEvent):
    match state:
        State.Idle:
            if event is InputEventKey and event.is_pressed() and event.scancode == KEY_X:
                state = State.Placing
                begin(LargeTower.tile_size() * tile_map.cell_size)
        
        State.Placing:
            if event is InputEventMouseMotion:
                set_pos(quantise_to_grid(get_global_mouse_position()))

            if event is InputEventMouseButton and event.is_pressed()  and event.button_index == BUTTON_LEFT:
                state = State.Idle
                end()
                
                var tower = LargeTower.new(quantise_to_grid(get_global_mouse_position()))
                add_child(tower)


func _draw():
    if state == State.Placing:
        draw_rect(Rect2(pos, size), color, false)


func quantise_to_grid(x):
    return tile_map.map_to_world(tile_map.world_to_map(x - size/2 + tile_map.cell_size/2))


func begin(size_: Vector2):
    size = size_
    update()


func end():
    update()


func set_pos(pos_: Vector2):
    # Quantise the position
    self.pos = pos_
    update()
