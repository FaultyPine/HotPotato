shader_type canvas_item;

uniform vec4 first_color : source_color = vec4(1.0);
uniform vec4 second_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float position : hint_range(-0.5, 0.5) = 0.0;
uniform float size : hint_range(0.5, 2) = 0.5;
uniform float angle : hint_range(0.0, 360.0) = 0.0;
uniform float angle_over_time = 0.0;

vec4 background_gradient(vec2 input_uv)
{
	float sway_angle = angle + sin(TIME)*angle_over_time; 
	float pivot = position + 0.5;
	vec2 uv = input_uv - pivot;
	float rotated = uv.x * cos(radians(sway_angle)) - uv.y * sin(radians(sway_angle)); 
	float pos = smoothstep((1.0 - size) + position, size + 0.0001 + position, rotated + pivot);
	return mix(first_color, second_color, pos); 
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = background_gradient(UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
