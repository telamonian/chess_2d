extends Button

const MENU_SCENE: PackedScene = preload("res://game/settings/settings_menu.tscn")

var menu
var menu_hidden = true:
  set(x):
    if not menu_hidden and x == true:
      get_parent().remove_child(menu)
    elif menu_hidden and x == false:
      get_parent().add_child(menu)

    menu_hidden = x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  menu = MENU_SCENE.instantiate()
  pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_pressed():
  if menu_hidden:
    menu_hidden = false
  else:
    menu_hidden = true
