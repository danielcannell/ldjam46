extends Node2D


const Camera = preload("res://Playfield/Camera.gd")
const Player = preload("res://Playfield/Player/Player.tscn")
const Placement = preload("res://Playfield/Towers/Placement.gd")
const Enemy = preload("res://Playfield/Enemy/Enemy.tscn")


var player: Position2D
var placement: Placement
var camera: Camera2D
var enemies: Array
onready var tm: TileMap = get_node("Map/TileMap")


func _init():
    placement = Placement.new()
    add_child(placement)

    # Create the player
    player = Player.instance()
    add_child(player)

    # Create the camera and attach it to the player so it follows them around
    camera = Camera.new()
    camera.make_current()
    player.add_child(camera)


func _input(event: InputEvent):
    if event is InputEventKey and event.is_pressed():
        if event.scancode == KEY_X:
            placement.begin(Vector2(2, 2))

    if event is InputEventMouseMotion:
        placement.set_pos(get_global_mouse_position())

    if event is InputEventMouseButton:
        if event.button_index == BUTTON_RIGHT:
            if event.is_pressed():
                # Create new enemy here
                var pos := get_global_mouse_position()
                var enemy = Enemy.instance()
                var ep = tm.get_closest_point_on_path(pos)
                enemy.position = ep
                add_child(enemy)
