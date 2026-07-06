shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_pct : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);

	COLOR.rgb = mix(original_color.rgb, flash_color.rgb, flash_pct);

	if (original_color.a > 0.0) {
		COLOR.a = mix(original_color.a, 1.0, flash_pct);
	} else {
		COLOR.a = 0.0;
	}
}