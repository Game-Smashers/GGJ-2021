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
