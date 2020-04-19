extends Area2D

var Player = preload("res://Playfield/Player/Player.gd")
onready var feeding_timer := Timer.new()
const feeding_time = 4

const hunger_inc_delay := 10.0
const hunger_inc := 0.01
onready var hunger_timer := Timer.new()
var hunger: float = 0.25
var food_amount: float = 0.25

var fear: float = 0
var fear_changed: bool = false


# args: (fear: float)
signal fear_changed

# args: (hunger: float)
signal hunger_changed


func on_attacked(dmg: float) -> void:
    if fear < Globals.MONSTER_MAX_FEAR:
        fear += dmg
        fear_changed = true


func on_hunger_timeout() -> void:
    hunger_timer.start(hunger_inc_delay)
    hunger += hunger_inc
    emit_signal("hunger_changed", hunger)


func on_area_entered(area: Area2D) -> void:
    if area is Player:
        feeding_timer.start(feeding_time)


func on_area_exited(area: Area2D) -> void:
    if area is Player:
        feeding_timer.stop()


func feeding_complete() -> void:
    for area in get_overlapping_areas():
        if area is Player:
            if area.feed_one():
                hunger -= food_amount
                emit_signal("hunger_changed", hunger)


func _ready() -> void:
    add_child(feeding_timer)
    assert( feeding_timer.connect("timeout", self, "feeding_complete") == 0 )

    add_child(hunger_timer)
    assert( hunger_timer.connect("timeout", self, "on_hunger_timeout") == 0 )
    call_deferred("on_hunger_timeout")

    assert( connect("area_entered", self, "on_area_entered") == 0 )
    assert( connect("area_exited", self, "on_area_exited") == 0 )


func _process(_delta: float) -> void:
    if fear_changed:
        fear_changed = false
        emit_signal("fear_changed", fear)
