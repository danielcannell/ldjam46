extends Node2D


onready var rpanel = $CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/RightPanel
onready var lpanel = $CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/LeftPanel


# outbound signals
signal build_requested

func _on_build_requested(build_id: String):
    emit_signal("build_requested", build_id)


# inbound slots

func on_tutorial_message(message: String):
    var controls = $CanvasLayer/MainControls
    controls.on_tutorial_message(message)

func on_status_change(status_id: String, status_val: float):
    rpanel.status_change(status_id, status_val)

func on_wave_start(wave_num: int, wave_max: int, num_spawns: int) -> void:
    lpanel.wave_start(wave_num, wave_max, num_spawns)

func on_spawns_change(num_spawns: int) -> void:
    lpanel.spawns_change(num_spawns)

func on_kills_change(num_kills: int) -> void:
    lpanel.kills_change(num_kills)

func set_buildable_items(_towers):
    var unlocked = []
    var locked = []
    for t in Globals.TOWERS:
        if Globals.TOWERS[t]['unlocked']:
            unlocked.append(t)
        else:
            locked.append(t)

    lpanel.add_buttons(unlocked, locked)


func set_status_bars(bar_names):
    rpanel.set_progress_bars(bar_names)


# implementation

func _ready():
    # Show tutorial after 3 seconds
    var timer = Timer.new()
    add_child(timer)
    timer.connect("timeout", self ,"_begin_event")
    timer.start(0.1)


func _begin_event():
    Globals.tutorial_event(Globals.TutorialEvents.BEGIN)


func show_game_over():
    $CanvasLayer/GameOverDialog.visible = true


func _on_playfield_inventory_updated(inventory):
    rpanel._on_inventory_updated(inventory)
