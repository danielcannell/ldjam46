extends Node2D


const Camera = preload("res://Playfield/Camera.gd")
const Player = preload("res://Playfield/Player/Player.tscn")
const Placement = preload("res://Playfield/Towers/Placement.gd")


var player: Position2D
var placement: Placement
var camera: Camera2D


func _init():
    placement = Placement.new()
    add_child(placement)
    
    # Create the player
    player = Player.instance()
    add_child(player)

    # Create the camera and attach it to the player so it follows them arounds
    camera = Camera.new()
    camera.make_current()
    player.add_child(camera)


func _input(event):
    if event is InputEventKey and event.is_pressed():
        if event.scancode == KEY_X:
            placement.begin(Vector2(100, 100), Vector2(0, 0))

    if event is InputEventMouseMotion:
        placement.set_pos(get_global_mouse_position())
