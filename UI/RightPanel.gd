extends Panel

var lookup = {}
var StatusBar = preload("res://UI/StatusBar.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
    add_progress_bar('foo', 'Bar Baz')
    add_progress_bar('bing', 'Bang Bong')


func add_progress_bar(key, title):
    lookup[key] = StatusBar.new(title)
    get_node("VerticalLayout/StatusBars").add_child(lookup[key])
