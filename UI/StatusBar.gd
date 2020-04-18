extends VBoxContainer

var StatusBarUI = preload("res://UI/StatusBarUI.tscn")
var inner = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _process(delta):
    inner.get_node("ProgressBar").value += 1
    if inner.get_node("ProgressBar").value >= 100:
        inner.get_node("ProgressBar").value = 0

# Construct a status bar with this title
func _init(bartitle: String):
    inner = StatusBarUI.instance()
    inner.get_node("BarHeading").bbcode_text = "[center]%s[/center]" % bartitle
    add_child(inner)
