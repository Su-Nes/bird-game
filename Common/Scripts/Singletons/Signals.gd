extends Node


signal player_change_state(state: String)
signal player_changed_state(state: String)

signal grab_item(item: Interactable)
signal clear_items

var build_controller : BuildController
