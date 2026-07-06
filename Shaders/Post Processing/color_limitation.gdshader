shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

uniform int red_levels : hint_range(2, 16) = 5;
uniform int green_levels : hint_range(2, 16) = 4;
uniform int blue_levels : hint_range(2, 16) = 5;

uniform float saturation : hint_range(0.0, 3.0) = 1.0;

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    screen_color.r = floor(screen_color.r * float(red_levels)) / float(red_levels - 1);
    screen_color.g = floor(screen_color.g * float(green_levels)) / float(green_levels - 1);
    screen_color.b = floor(screen_color.b * float(blue_levels)) / float(blue_levels - 1);

    float gray = dot(screen_color.rgb, vec3(0.3, 0.59, 0.11));

    screen_color.rgb = vec3(gray) + (screen_color.rgb - vec3(gray)) * saturation;

    COLOR = screen_color;
}