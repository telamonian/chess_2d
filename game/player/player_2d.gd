extends Node2D
class_name Player2D

var id: int
var color: Enum.Pcolor
var is_in_check: bool = false

var row_back: int
var row_front: int
var row_promote: int
var pawn_dir: int

func setup(new_id: int, new_color: Enum.Pcolor):
  id = new_id
  color = new_color

  if color == Enum.Pcolor.WHITE:
    row_back = 0
    row_front = 1
    row_promote = 7
    pawn_dir = 1
  elif color == Enum.Pcolor.BLACK:
    row_back = 7
    row_front = 6
    row_promote = 0
    pawn_dir = -1
