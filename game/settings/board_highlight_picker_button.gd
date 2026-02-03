extends ColorPickerButton

var opt_section = "game"
var opt_name = "square_highlight"

func set_button_color(opt: Opt.Option):
  color = opt.value

func _ready() -> void:
  Opt.subscribe(opt_section, opt_name, set_button_color)
  color_changed.connect(_on_color_changed)

func _on_color_changed(new_color: Color):
  Opt.set_option_value(opt_section, opt_name, new_color)
