tool
extends Control
class_name PowerBar

export(float) var critical_low: = 0.1 setget set_critical_low
export(float) var danger_low: = 0.2 setget set_danger_low
export(float) var safe: = 0.4 setget set_safe
export(float) var danger_high: = 0.2 setget set_danger_high
export(float) var critical_high: = 0.1  setget set_critical_high
export(float, 0, 1) var value: = 0.5 setget set_value

const VALUE_HALF_WIDTH = 0.01

onready var critical_low_panel: ColorRect = $VBox/HBox/CriticalZoneLow
onready var danger_low_panel: ColorRect = $VBox/HBox/DangerZoneLow
onready var safe_panel: ColorRect = $VBox/HBox/SafeZone
onready var danger_high_panel: ColorRect = $VBox/HBox/DangerZoneHigh
onready var critical_high_panel: ColorRect = $VBox/HBox/CriticalZoneHigh
onready var value_rect: ColorRect = $ValueRect

func set_critical_low(value: float) -> void:
	critical_low_panel.size_flags_stretch_ratio = value
	critical_low = value


func set_danger_low(value: float) -> void:
	danger_low_panel.size_flags_stretch_ratio = value
	danger_low = value


func set_safe(value: float) -> void:
	safe_panel.size_flags_stretch_ratio = value
	safe = value


func set_danger_high(value: float) -> void:
	danger_high_panel.size_flags_stretch_ratio = value
	danger_high = value


func set_critical_high(value: float) -> void:
	critical_high_panel.size_flags_stretch_ratio = value
	critical_high = value


func set_value(new_value: float) -> void:
	value_rect.anchor_left = new_value - VALUE_HALF_WIDTH
	value_rect.anchor_right = new_value + VALUE_HALF_WIDTH
	value = new_value
