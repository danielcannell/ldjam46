extends Panel


func set_message(title: String, message: String):
    $VBoxContainer/Title.text = title
    $VBoxContainer/Message.bbcode_text = message
