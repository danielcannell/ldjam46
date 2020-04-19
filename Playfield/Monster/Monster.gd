tool
extends Area2D

var Player = preload("res://Playfield/Player/Player.gd")
onready var feeding_timer := Timer.new()
const feeding_time = 3

const hunger_inc_delay := 5.0
const hunger_inc := 0.005
onready var hunger_timer := Timer.new()
var hunger: float = 0.25
var food_amount: float = 0.25
var hunger_fear_threshold: float = 0.75

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

    if fear >= Globals.MONSTER_MAX_FEAR:
        Globals.lose_condition()


func on_hunger_timeout() -> void:
    hunger_timer.start(hunger_inc_delay)
    if hunger < 1:
        hunger += hunger_inc
    if hunger > hunger_fear_threshold - 0.05:
        Globals.tutorial_event(Globals.TutorialEvents.MONSTER_V_HUNGRY)
    if hunger > hunger_fear_threshold:
        on_attacked(1.0)
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
                Globals.tutorial_event(Globals.TutorialEvents.MONSTER_FED)
                hunger -= food_amount
                emit_signal("hunger_changed", hunger)


func _ready() -> void:
    if Engine.editor_hint:
        set_process(false)
        return

    var err: int = 0
    add_child(feeding_timer)
    err = feeding_timer.connect("timeout", self, "feeding_complete"); assert(err == 0)

    add_child(hunger_timer)
    err = hunger_timer.connect("timeout", self, "on_hunger_timeout"); assert(err == 0)
    call_deferred("on_hunger_timeout")

    err = connect("area_entered", self, "on_area_entered"); assert(err == 0)
    err = connect("area_exited", self, "on_area_exited"); assert(err == 0)


func _process(_delta: float) -> void:
    if fear_changed:
        fear_changed = false
        emit_signal("fear_changed", fear)
