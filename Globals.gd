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

const ITEMS = [
    {
        "name": "food",
        "image": preload("res://Art/curry_rice.png"),
        "title": "Food"
    }
]

enum DamageType {
    NORMAL,
    FIRE,
    SLOWNESS,
}

var playfield: Node2D

var tutorial_enabled = true

enum TutorialEvents {
    BEGIN,
    WALK,
    FOOD_SPAWNED,
    FOOD_PICKED_UP,
    DEMO_EVENT,
    UNFINISHED_EVENT,
    MONSTER_FED
}

func tutorial_event(event) -> void:
    var tc = get_tree().get_root().get_node("Game/GameUI/TutorialController")
    tc.handle_tutorial_event(event)
