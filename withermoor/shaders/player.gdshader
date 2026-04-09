shader_type canvas_item;

uniform vec4 filter_color = vec4(0.9, 0.5, 0.0, 1.0);
uniform float weight = 0.9;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = texture(TEXTURE, UV);
	if (COLOR.a != 0.0) {
		COLOR = (1.0-weight)*COLOR + weight*filter_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
