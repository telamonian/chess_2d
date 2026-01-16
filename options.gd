class_name Options
extends Node

var by_name: Dictionary[String, Option] = {}
var by_section: Dictionary[String, Variant] = {}

class Option:
  signal changed(value)

  var _default
  var section: String
  var name: String

  var value:
    get():
      return value
    set(x):
      value = x
      changed.emit(x)

  func _init(section: String, name: String, default):
    _default = default
    self.section = section
    self.name = name

    reset()

  func reset():
    value = _default

func set_option(section: String, name: String, default) -> Option:
  var option = Option.new(section, name, default)

  by_name[option.name] = option
  var section_dir = by_section.get(option.section, {})
  section_dir[option.name] = option

  return option

func get_option_by_name(name: String) -> Option:
  return by_name[name]

func get_option_by_section(section: String, name: String) -> Option:
  return by_section[section][name]
