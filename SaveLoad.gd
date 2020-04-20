extends Node2D


var playfield: Node2D
var tower_builder: Node2D
var spawners: Node2D
var ysort: YSort


func _ready() -> void:
    playfield = get_tree().get_root().get_node("Game/ViewportContainer/Viewport/Playfield")
    tower_builder = playfield.get_node("TowerBuilder")
    spawners = playfield.get_node("VillagerSpawners")
    ysort = playfield.get_node("YSort")


func _unhandled_input(event: InputEvent):
    if Config.SAVE_LOAD_ENABLED:
        if Input.is_key_pressed(KEY_CONTROL):
            if event.scancode == KEY_S:
                save_state()
            elif event.scancode == KEY_O:
                restore_state()


func _make_savefile_name(idx: int) -> String:
    return "user://savegame_" + str(idx) + ".save"


func get_save_name(exists: bool) -> String:
    var idx := 0
    var file := File.new()
    while true:
        var path := _make_savefile_name(idx)
        if not file.file_exists(path):
            if exists:
                return _make_savefile_name(idx-1)
            else:
                return path
        idx += 1
    return ""


func save_state():
    var save := File.new()
    var err := save.open(get_save_name(false), File.WRITE); assert(err == 0)
    var sdata := {}

    # Save all towers' state
    var towers: Array = []
    for tower in tower_builder.towers:
        var tdata := {}
        var map_pos: Vector2 = tower_builder.tile_map.world_to_map(tower.position)
        tdata["x"] = map_pos.x
        tdata["y"] = map_pos.y
        tdata["kind"] = tower.kind
        tdata["fname"] = tower.get_filename()
        towers.append(tdata)
    sdata["towers"] = towers

    # Save current save
    sdata["wave"] = spawners.wave_num

    save.store_line(to_json(sdata))
    save.close()


func restore_state():
    var save := File.new()
    var err := save.open(get_save_name(true), File.READ)
    if err != 0:
        return
    var sdata: Dictionary = parse_json(save.get_line())

    # Clear out all old towers
    for tower in tower_builder.towers:
        tower.queue_free()
    tower_builder.towers = []
    tower_builder.occupied_tiles = {}

    # Clear out all enemies
    for enemy in spawners.enemies.get_children():
        enemy.queue_free()

    # Load towers
    for data in sdata["towers"]:
        var tower: Tower = load(data["fname"]).instance()
        var map_pos: Vector2 = Vector2(0,0)
        map_pos.x = data["x"]
        map_pos.y = data["y"]
        tower.position = tower_builder.tile_map.map_to_world(map_pos)

        var kind: String = data["kind"]
        var params: Dictionary = Globals.TOWERS[kind]["params"]
        tower.kind = kind
        tower.state = Tower.State.BeingBuilt
        tower.build_progress = 1.0
        for param in params:
            tower.set(param, params[param])

        tower_builder.towers.append(tower)
        var top_left_pos: Vector2 = tower_builder.tile_map_pos(tower.position)
        var size_ = tower.tile_size
        for x in range(top_left_pos.x, top_left_pos.x + size_.x):
            for y in range(top_left_pos.y, top_left_pos.y + size_.y):
                var p := Vector2(x, y)
                tower_builder.occupied_tiles[p] = null
        ysort.add_child(tower)

    # Load wave
    spawners.wave_num = sdata["wave"]
    spawners.state = VillagerSpawners.State.InGap
    spawners.timer.start(0.1)
