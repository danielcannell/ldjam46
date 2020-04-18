extends Node2D


const Camera = preload("res://Playfield/Camera.gd")
const Player = preload("res://Playfield/Player/Player.tscn")
const TowerBuilder = preload("res://Playfield/Towers/TowerBuilder.gd")


var player: Position2D
var tower_builder: TowerBuilder
var camera: Camera2D
var enemies: Array
onready var tm: TileMap = get_node("Map/TileMap")


func _init():
    # Create the tower builder
    tower_builder = TowerBuilder.new()
    add_child(tower_builder)

    # Create the player
    player = Player.instance()
    add_child(player)
    
    tower_builder.connect("build", player, "build")
    player.connect("building", tower_builder, "building")

    # Create the camera and attach it to the player so it follows them around
    camera = Camera.new()
    camera.make_current()
    player.add_child(camera)
