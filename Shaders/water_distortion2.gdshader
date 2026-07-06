shader_type canvas_item;

uniform float time_factor = 2.0;
uniform vec2 amplitude = vec2(0.01, 0.01);

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec2 uv = SCREEN_UV;

    uv.x += sin(TIME * time_factor + uv.y * 20.0) * amplitude.x;
    uv.y += cos(TIME * time_factor + uv.x * 20.0) * amplitude.y;

    COLOR = texture(screen_texture, uv);
}