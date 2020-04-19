extends Node

const MONSTER_MAX_FEAR := 100.0

const TOWERS = {
    "basic": {
        "image": preload("res://Art/BasicTower.png"),
        "unlocked": true,
    },

    "large": {
        "image": preload("res://Art/LargeTower.png"),
        "unlocked": true,
    }
}

const BARS = {
    "Hunger": {

    },
    "Fear": {

    },
    "Boredom": {

    }
}

var tutorial_enabled = true

enum TutorialEvents {
    BEGIN,
    DEMO_EVENT,
    UNFINISHED_EVENT,
}

func tutorial_event(event) -> void:
    var tc = get_tree().get_root().get_node("Game/GameUI/TutorialController")
    tc.handle_tutorial_event(event)
