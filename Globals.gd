extends Node

const MONSTER_MAX_HAPPINESS := 100.0

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

const BARS = [
    "Hunger",
    "Fear",
    "Boredom"
]
