extends TextureRect


func _input(event):
    if event.is_action_pressed("ui_action"):
        get_tree().change_scene("res://UI/MainMenu.tscn")
