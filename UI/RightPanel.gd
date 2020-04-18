extends Panel

var lookup = {}
var StatusBar = preload("res://UI/StatusBar.gd")

onready var bars = get_node("VerticalLayout/StatusBars")

# Called when the node enters the scene tree for the first time.
func _ready():
    pass


func set_progress_bars(bars):
    for bar in bars:
        add_progress_bar(bar, bar)


func add_progress_bar(key, title):
    lookup[key] = StatusBar.new(title)
    bars.add_child(lookup[key])


func status_change(key, value):
    var bar = lookup[key]
    bar.set_value(value)
