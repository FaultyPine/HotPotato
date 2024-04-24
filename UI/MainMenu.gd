extends Control

@onready var langDropdown = $Languages
@onready var pan = $Background/VBoxContainer/Label/Pan
@onready var taptobegin = $Background/VBoxContainer/TapToBegin

func on_lang_change_mainmenu(locale):
	if locale != "en":
		pan.visible = false
	else:
		pan.visible = true
	taptobegin.text = "[font_size=40][center][wave amp=50]%s[/wave][/center]" % tr("TAP_BEGIN")

func initialize_lang_dropdown():
	var default_select = 0
	if langDropdown.item_count > 0:
		default_select = langDropdown.selected
	var locales = TranslationServer.get_loaded_locales()
	langDropdown.clear()
	for i in range(len(locales)):
		var locale = locales[i]
		langDropdown.add_item(tr("%s_LANGUAGE_NAME" % locale))
		langDropdown.set_item_metadata(i, locale)
	langDropdown.select(default_select)
	
func on_scene_fully_ready_lang_init():
	langDropdown.item_selected.emit(0)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.on_lang_change.connect(on_lang_change_mainmenu)
	Global.scene_fully_ready.connect(on_scene_fully_ready_lang_init)
	initialize_lang_dropdown()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_button_item_selected(index):
	var locale = langDropdown.get_item_metadata(index)
	TranslationServer.set_locale(locale)
	initialize_lang_dropdown()
	Global.on_lang_change.emit(locale)


func _on_background_gui_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			var mainroot: MainRoot = Global.get_main_root()
			if mainroot:
				mainroot.trigger_minigames_start()
