extends Panel

var lookup = {}
var StatusBar = preload("res://UI/StatusBar.gd")

onready var bars = get_node("VerticalLayout/StatusBars")


# outbound signals

signal tutorial_show_toggle(button_pressed)


# Called when the node enters the scene tree for the first time.
func _ready():
    $VerticalLayout/Tutorial.visible = Globals.tutorial_enabled


func on_tutorial_message() -> void:
    $VerticalLayout/Tutorial/HBoxContainer/CheckButton.pressed = true


func set_progress_bars(barnames: Dictionary) -> void:
    for bar in barnames:
        add_progress_bar(bar, bar)


func add_progress_bar(key: String, title: String) -> void:
    lookup[key] = StatusBar.new(title)
    bars.add_child(lookup[key])


func status_change(key: String, value: float) -> void:
    var bar = lookup[key]
    bar.set_value(value * 100.0)


func _on_tutorial_show_toggle(button_pressed):
    emit_signal("tutorial_show_toggle", button_pressed)
