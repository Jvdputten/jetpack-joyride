class_name HotkeyRebindButton
extends Control

@export var label: Label
@export var button: Button
@export var action_name: String

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	button.toggled.connect(_on_button_toggled)

func set_action_name() -> void:
	label.text = "Unassigned"

	# add all action names here and a name that will appear on the button>>>.
	match action_name:
		"fly":
			label.text = "Fly up"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]

	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)

	button.text = "%s" % action_keycode

func _on_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(button_pressed)

		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else:

		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()


func _unhandled_key_input(event) -> void:
	rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

	set_process_unhandled_input(false)
	set_text_for_key()
	set_action_name()

