extends Node

enum CollisionLayers {
    Tower,
    Enemy,
    Projectile,
}

# Really const
var TOWERS = {
    "Ballista Tower": {
        "scene": preload("res://Playfield/Towers/BasicTower.tscn"),
        "unlocked": true,
        "params": {
            "damage_type": DamageType.NORMAL,
            "attack_interval": 1.0,
        },
    },
    "Fire Tower": {
        "scene": preload("res://Playfield/Towers/FireTower.tscn"),
        "unlocked": true,
        "params": {
            "damage_type": DamageType.FIRE,
            "attack_interval": 3.0,
        },
    },
    "Sticky Sludge Tower": {
        "scene": preload("res://Playfield/Towers/SludgeTower.tscn"),
        "unlocked": true,
        "params": {
            "damage_type": DamageType.SLOWNESS,
            "attack_interval": 5.0,
        },
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

enum DamageType {
    NORMAL,
    FIRE,
    SLOWNESS,
}

var tutorial_enabled = true

enum TutorialEvents {
    BEGIN,
    WALK,
    FOOD_SPAWNED,
    FOOD_PICKED_UP,
    MONSTER_FED,
    MONSTER_V_HUNGRY,
}

func tutorial_event(event) -> void:
    var tc = get_tree().get_root().get_node("Game/GameUI/TutorialController")
    tc.handle_tutorial_event(event)


func win_condition() -> void:
    var gui = get_tree().get_root().get_node("Game/GameUI")
    get_tree().paused = true
    gui.show_win()


func lose_condition() -> void:
    var gui = get_tree().get_root().get_node("Game/GameUI")
    get_tree().paused = true
    gui.show_game_over()
