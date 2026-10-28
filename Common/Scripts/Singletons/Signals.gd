extends Node


signal player_change_state(state: String)
signal player_changed_state(state: String)

signal grab_item(item: Interactable)
signal clear_items

signal win

var build_controller : BuildController
var time_controller : TimeController

func empty_func():
	player_change_state.is_null()
	player_changed_state.is_null()
	grab_item.is_null()
	clear_items.is_null()
	win.is_null()
