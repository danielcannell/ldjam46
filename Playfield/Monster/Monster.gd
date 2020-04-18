extends Node2D


var fear: float = 0
var fear_changed: bool = false


# args: (fear: float)
signal fear_changed


func on_attacked(dmg: float) -> void:
    if fear < Globals.MONSTER_MAX_FEAR:
        fear += dmg
        fear_changed = true


func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    if fear_changed:
        fear_changed = false
        emit_signal("fear_changed", fear)
