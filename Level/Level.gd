tool
extends Node


# Level size
export (int, 5, 50) var width = 10
export (int, 5, 50) var height = 10

export (bool) var generate_level_button = false setget generate_level

export (String, FILE) var wall_path


func _ready():
    if Engine.editor_hint:
        return

    generate_level()


func generate_level(value):
    """
    Generate a whole new level based on width and height
    """
    # Remove existing level
    for node in get_children():
        node.queue_free()

    var wall_class = load(wall_path)

    for x in range(width):
        for y in range(height):
            var wall_instance = wall_class.instance()
            wall_instance.position.x = (x + 1) * 16
            wall_instance.position.y = (y + 1) * 16

            wall_instance.destroyable = (x == 6)

            add_child(wall_instance)
            wall_instance.set_owner(
                get_tree().get_edited_scene_root()
            )
