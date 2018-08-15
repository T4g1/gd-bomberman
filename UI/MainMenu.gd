extends MarginContainer


func _on_new_game_pressed():
    get_tree().change_scene("res://UI/Controls.tscn")


func _on_quit_pressed():
    get_tree().quit()
