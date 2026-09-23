extends Node


signal display_tool_tips(tool_tips_kb: Dictionary[Texture2D, String], tool_tips_gp: Dictionary[Texture2D, String], owner_name: String)
signal remove_tool_tips(owner_name : String)

signal player_change_state(state : String)

var build_controller : BuildController
