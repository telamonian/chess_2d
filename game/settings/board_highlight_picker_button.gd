extends ColorPickerButton

var opt = Opt.get_option_by_section("game", "square_highlight")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  color = opt.value
  color_changed.connect(_on_color_changed)

func _on_color_changed(new_color: Color):
  Opt.set_option_value(opt.section, opt.name, new_color)
