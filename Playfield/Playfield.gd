extends Node2D


const Camera = preload("res://Playfield/Camera.gd")
const Player = preload("res://Playfield/Player/Player.tscn")


var player: Area2D
var camera: Camera2D
var enemies: Array

onready var tower_builder: Node2D = $TowerBuilder
onready var tm: TileMap = $Map/TileMap


func on_build_requested(kind):
    tower_builder.on_build_requested(kind)


func _ready():
    # Create the player
    player = Player.instance()
    add_child(player)

    assert(tower_builder.connect("build", player, "build") == 0)
    assert(tower_builder.connect("build_complete", self, "build_complete") == 0)
    assert(player.connect("building", tower_builder, "building") == 0)
    assert(player.connect("state_changed", tower_builder, "_on_player_state_changed") == 0)

    # Create the camera and attach it to the player so it follows them around
    camera = Camera.new()
    camera.make_current()
    player.add_child(camera)


func build_complete():
    player.move(player.position)
