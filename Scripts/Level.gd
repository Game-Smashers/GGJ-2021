class_name Level

extends Resource

# In seconds
export(int) var time_limit = 60

# Starting state of rooms
export(float, 0, 1) var power = 0.5
export(float, 0, 1) var waste = 0.0
export(float, 0, 1) var reactor = 0.5

# HP per second
export(float, 0, 5) var health_restore_rate = 1.0
export(int) var employees = 0

export(bool) var disable_turbine_breakdown = false
export(bool) var disable_water_pump_breakdown = false

export(float) var waste_room_fill_speed_multiplier = 1.0
export(float) var turbine_room_efficiency_drain_multiplier = 1.0
export(float) var human_energy_drain_multiplier = 0.1
