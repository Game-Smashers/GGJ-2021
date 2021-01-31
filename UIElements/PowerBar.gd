tool
extends Control
class_name PowerBar

export(float) var critical_low: = 0.1
export(float) var danger_low: = 0.2
export(float) var safe: = 0.4
export(float) var danger_high: = 0.2
export(float) var critical_high: = 0.1
export(float, 0, 1) var value: = 0.5

const VALUE_HALF_WIDTH = 0.01

onready var critical_low_panel: ColorRect = $VBox/HBox/CriticalZoneLow
onready var danger_low_panel: ColorRect = $VBox/HBox/DangerZoneLow
onready var safe_panel: ColorRect = $VBox/HBox/SafeZone
onready var danger_high_panel: ColorRect = $VBox/HBox/DangerZoneHigh
onready var critical_high_panel: ColorRect = $VBox/HBox/CriticalZoneHigh
onready var value_rect: ColorRect = $ValueRect

func _ready() -> void:
	critical_low_panel.size_flags_stretch_ratio = critical_low
	danger_low_panel.size_flags_stretch_ratio = danger_low
	safe_panel.size_flags_stretch_ratio = safe
	danger_high_panel.size_flags_stretch_ratio = danger_high
	critical_high_panel.size_flags_stretch_ratio = critical_high
	value_rect.anchor_left = value - VALUE_HALF_WIDTH
	value_rect.anchor_right = value + VALUE_HALF_WIDTH
