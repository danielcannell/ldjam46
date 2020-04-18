extends Node2D


const Camera = preload("res://Playfield/Camera.gd")
const Player = preload("res://Playfield/Player/Player.tscn")


var player


func _init():
    # Create the player
    player = Player.instance()
    add_child(player)
    
    # Create the camera and attach it to the player so it follows them arounds
    var camera = Camera.new()
    camera.make_current()
    player.add_child(camera)
