extends Node

enum CollisionLayers {
    Tower,
    Enemy,
    Projectile,
}

const MONSTER_MAX_FEAR := 100.0

const TOWERS = {
    "basic": {
        "scene": preload("res://Playfield/Towers/BasicTower.tscn"),
        "unlocked": true,
    },
}

const BARS = {
    "Hunger": {

    },
    "Fear": {

    },
    "Boredom": {

    }
}

var playfield: Node2D

var tutorial_enabled = true

enum TutorialEvents {
    BEGIN,
    DEMO_EVENT,
    UNFINISHED_EVENT,
}

func tutorial_event(event) -> void:
    var tc = get_tree().get_root().get_node("Game/GameUI/TutorialController")
    tc.handle_tutorial_event(event)
