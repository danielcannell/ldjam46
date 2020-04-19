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
}

const ITEMS = [
    {
        "name": "food",
        "image": preload("res://Art/curry_rice.png"),
        "title": "Food"
    }
]

var playfield: Node2D

var tutorial_enabled = true

enum TutorialEvents {
    BEGIN,
    WALK,
    FOOD_SPAWNED,
    FOOD_PICKED_UP,
    DEMO_EVENT,
    UNFINISHED_EVENT,
    MONSTER_FED,
    MONSTER_V_HUNGRY,
}

func tutorial_event(event) -> void:
    var tc = get_tree().get_root().get_node("Game/GameUI/TutorialController")
    tc.handle_tutorial_event(event)


func lose_condition() -> void:
    var gui = get_tree().get_root().get_node("Game/GameUI")
    get_tree().paused = true
    gui.show_game_over()
