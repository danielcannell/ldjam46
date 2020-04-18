extends Node2D


var happiness: float = Globals.MONSTER_MAX_HAPPINESS


func on_attacked() -> void:
    print("Attacked!")


func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    # TODO update health bars
    pass
