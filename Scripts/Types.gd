class_name Types

enum RoomType {
	WATER_PUMP,
	TURBINE,
	REACTOR,
	WASTE_CLOSET,
	CAFETERIA
}

# One per sprite set
const human_traits = [
	[RoomType.TURBINE, RoomType.WASTE_CLOSET],
	[RoomType.REACTOR, RoomType.TURBINE],
	[RoomType.WATER_PUMP, RoomType.WASTE_CLOSET],
	[RoomType.WASTE_CLOSET, RoomType.WATER_PUMP],
	[RoomType.REACTOR, RoomType.TURBINE]
	]
