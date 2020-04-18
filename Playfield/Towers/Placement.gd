extends Node2D


const BasicTower = preload("res://Playfield/Towers/BasicTower.gd")


enum State {
    Idle,
    Placing,
}


var state: int = State.Idle
var tile_map: TileMap
var size: Vector2
var pos: Vector2
var color: Color = Color(0, 1, 0, 1)


func _ready():
    tile_map = $"../Map/TileMap"


func _input(event: InputEvent):
    match state:
        State.Idle:
            if event is InputEventKey and event.is_pressed() and event.scancode == KEY_X:
                state = State.Placing
                begin(BasicTower.tile_size() * tile_map.cell_size)
        
        State.Placing:
            if event is InputEventMouseMotion:
                set_pos(quantise_to_grid(get_global_mouse_position()))

            if event is InputEventMouseButton and event.is_pressed()  and event.button_index == BUTTON_LEFT:
                state = State.Idle
                end()
                
                var tower = BasicTower.new(quantise_to_grid(get_global_mouse_position()))
                add_child(tower)


func _draw():
    if state == State.Placing:
        draw_rect(Rect2(pos, size), color, false)


func quantise_to_grid(x):
    return tile_map.map_to_world(tile_map.world_to_map(x))


func begin(size_: Vector2):
    size = size_
    update()


func end():
    update()


func set_pos(pos_: Vector2):
    # Quantise the position
    self.pos = pos_
    update()
