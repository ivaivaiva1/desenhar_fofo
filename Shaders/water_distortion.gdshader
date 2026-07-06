shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform float frequency = 20.0;
uniform float intensity = 0.01;	
uniform float speed = 0.9;

void fragment() {
	vec2 uv = SCREEN_UV;
	
	float x = uv.x * frequency + TIME * speed;
	float y = uv.y * frequency + TIME * speed;
	
	uv.y += cos(x + y) * (intensity * 1.0) * cos(y);
	uv.x += sin(x + y) * intensity * sin(y);
	
	COLOR = texture(SCREEN_TEXTURE, uv);
}
