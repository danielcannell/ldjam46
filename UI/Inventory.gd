extends VBoxContainer

var Inventory = preload("res://UI/InventoryEntry.tscn")

func update_entries(inventory):
    for child in get_children():
        remove_child(child)

    for item in Globals.ITEMS:
        if item['name'] in inventory:
            add_inventory_item(item, inventory[item['name']])


func add_inventory_item(item: Dictionary, num: int):
    var inv_node = Inventory.instance()
    add_child(inv_node)
    inv_node.get_node("TextureRect").texture = item["image"]
    inv_node.get_node("VBoxContainer/Count").text = "%d" % num
    inv_node.get_node("VBoxContainer/Name").text = item['title']

