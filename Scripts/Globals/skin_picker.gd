extends Node

enum ENTITY_TYPE {
	BOB,
	FOOD,
	CAMA
}

# LINE COLOR
const LINE_CANDY := {"color": Color.DEEP_PINK}
const LINE_SPACE := {"color": Color.WHITE}

# STATE_LABEL COLOR 
const FONT_COLOR_CANDY := {"color": Color("9ad8ee")}
const OUTLINE_COLOR_CANDY := {"color": Color("e8a662")}
const FONT_COLOR_SPACE := {"color": Color("fbf236")}
const OUTLINE_COLOR_SPACE := {"color": Color("dc0c0c")}

# BOB
const BOB_CANDY := {"texture": preload("uid://dm6y5ehesh4wg")}
const BOB_SPACE := {"texture": preload("uid://biqh22lkslyvy")}

# FOOD
const FOOD_CANDY := {"texture": preload("uid://dgt64h8fkfp17")}
const FOOD_SPACE := {"texture": preload("uid://vaub5rxhlur4")}

# CAMA
const CAMA_CANDY := {"texture": preload("uid://bcynbwdwllm32")}
const CAMA_SPACE := {"texture": preload("uid://cs2m2vlka8yw3")}



func change_skin(entity_type: ENTITY_TYPE, sprite):
	var current_world:= CurrentLevel.current_world
	match entity_type:
		ENTITY_TYPE.BOB:
			retexture_bob(current_world, sprite)
		ENTITY_TYPE.FOOD:
			retexture_food(current_world, sprite)
		ENTITY_TYPE.CAMA:
			retexture_cama(current_world, sprite)


func retexture_bob(current_world: CurrentLevel.WORLDS, sprite):
	match current_world:
		CurrentLevel.WORLDS.CANDY:
			sprite.texture = BOB_CANDY.texture
		CurrentLevel.WORLDS.SPACE:
			sprite.texture = BOB_SPACE.texture

func retexture_food(current_world: CurrentLevel.WORLDS, sprite):
	match current_world:
		CurrentLevel.WORLDS.CANDY:
			sprite.texture = FOOD_CANDY.texture
		CurrentLevel.WORLDS.SPACE:
			sprite.texture = FOOD_SPACE.texture

func retexture_cama(current_world: CurrentLevel.WORLDS, sprite):
	match current_world:
		CurrentLevel.WORLDS.CANDY:
			sprite.texture = CAMA_CANDY.texture
		CurrentLevel.WORLDS.SPACE:
			sprite.texture = CAMA_SPACE.texture


func line_color():
	var current_world:= CurrentLevel.current_world
	match current_world:
		CurrentLevel.WORLDS.CANDY:
			return LINE_CANDY.color
		CurrentLevel.WORLDS.SPACE:
			return LINE_SPACE.color


func label_color() -> Dictionary:
	var current_world:= CurrentLevel.current_world
	match current_world:
		CurrentLevel.WORLDS.CANDY:
			return {
				"font": FONT_COLOR_CANDY.color,
				"outline": OUTLINE_COLOR_CANDY.color
			}
		CurrentLevel.WORLDS.SPACE:
			return {
				"font": FONT_COLOR_SPACE.color,
				"outline": OUTLINE_COLOR_SPACE.color
			}
		_:
			return {
				"font": FONT_COLOR_CANDY.color,
				"outline": OUTLINE_COLOR_CANDY.color
			}
