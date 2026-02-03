class_name Options
extends Node

const defaults = [
  ["game", "piece_highlight", Color(0, 0, 0, 0)],    # Color(1.0, 0.071, 0.263, 1.0)
  ["game", "square_highlight", Color(1.0, .5, 0.259, 1.0)],
]

const OPTIONS_FILE = "user://options.ini"

var by_name: Dictionary[String, Option] = {}
var by_section: Dictionary[String, Variant] = {}

class Option:
  signal changed

  var _default
  var section: String
  var name: String

  var value:
    get():
      return value
    set(x):
      value = x
      changed.emit()

  func _init(section: String, name: String, default):
    _default = default
    self.section = section
    self.name = name

    reset()

  func reset():
    value = _default

func _init():
  load_config()

func create_option(section: String, name: String, default) -> Option:
  var option = Option.new(section, name, default)

  by_name[option.name] = option

  if option.section in by_section:
    by_section[option.section][option.name] = option
  else:
    by_section[option.section] = {option.name: option}

  return option

func set_option_value(section: String, name: String, value):
  get_option_by_section(section, name).value = value
  save_config()

func get_option_by_name(name: String) -> Option:
  return by_name[name]

func get_option_by_section(section: String, name: String) -> Option:
  return by_section[section][name]

func load_config() -> bool:
  var config = ConfigFile.new()
  var err = config.load(OPTIONS_FILE)
  if err == OK:
    for d in defaults:
      if config.has_section_key(d[0], d[1]):
        create_option(d[0], d[1], config.get_value(d[0], d[1]))
      else:
        create_option(d[0], d[1], d[2])
    print_debug("updating user preference file at: " + OPTIONS_FILE)
    save_config()
    return true
  else:
    for d in defaults:
      create_option(d[0], d[1], d[2])
    print_debug("creating user preference file at: " + OPTIONS_FILE)
    save_config()
    return false

func save_config():
  var config = ConfigFile.new()

  for o in by_name.values():
    config.set_value(o.section, o.name, o.value)

  # Save it to a file (overwrite if already exists).
  config.save(OPTIONS_FILE)

# connect a callback to the "changed" signal of an option, but run the callback once first
func subscribe(section: String, name: String, callback: Callable):
  var o = get_option_by_section(section, name)
  var callback_bound = callback.bind(o)
  callback_bound.call()
  o.changed.connect(callback_bound)
