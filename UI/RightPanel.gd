extends Panel

var lookup = {}
var StatusBar = preload("res://UI/StatusBar.gd")

onready var bars = get_node("VerticalLayout/StatusBars")

# Called when the node enters the scene tree for the first time.
func _ready():
    add_progress_bar('foo', 'Bar Baz')
    add_progress_bar('bing', 'Bang Bong')


func add_progress_bar(key, title):
    var bar = bars.add_child(StatusBar.new(title))
    lookup[key] = bars.get_child_count()


func status_change(key, value):
    var bar = bars.get_child(lookup[key])
    bar.set_value(value)
