shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D gradient;

void fragment() {
	vec4 pixelColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 gradientColor = texture(gradient, SCREEN_UV);
	COLOR = mix(pixelColor, gradientColor, 0.3);
}